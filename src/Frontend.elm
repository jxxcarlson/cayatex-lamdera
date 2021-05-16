module Frontend exposing (..)

import Authentication
import Browser exposing (UrlRequest(..))
import Browser.Events
import Browser.Navigation as Nav
import CaYaTeX
import Data
import Document exposing (Access(..))
import File.Download as Download
import Frontend.Cmd
import Frontend.Update
import Frontend.UpdateLaTeX as UpdateLaTeX
import Html exposing (Html)
import Lamdera exposing (sendToBackend)
import List.Extra
import Parser.Element exposing (CYTMsg(..))
import Process
import Render.LaTeX
import Task
import Types exposing (..)
import Url exposing (Url)
import UrlManager
import User
import Util
import View.Main
import View.Utility


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


subscriptions model =
    Sub.batch
        [ Browser.Events.onResize (\w h -> GotNewWindowDimensions w h)
        ]


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , url = url
      , message = "Welcome!"

      -- ADMIN
      , users = []

      -- UI
      , windowWidth = 600
      , windowHeight = 900
      , popupStatus = PopupClosed
      , showEditor = False

      -- USER
      , currentUser = Nothing
      , inputUsername = ""
      , inputPassword = ""

      -- DOCUMENT
      , counter = 0
      , inputSearchKey = ""
      , documents = [ Data.notSignedIn ]
      , currentDocument = Data.notSignedIn
      , printingState = PrintWaiting
      , documentDeleteState = WaitingForDeleteAction
      }
    , Cmd.batch [ Frontend.Cmd.setupWindow, sendToBackend (getStartupDocument url) ]
    )


getStartupDocument : Url -> ToBackend
getStartupDocument url =
    let
        id =
            url.path |> String.dropLeft 1
    in
    GetDocumentByIdForGuest id



-- , sendToBackend (GetDocumentById "aboutCYT")


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    let
                        cmd =
                            case .fragment url of
                                Just id ->
                                    View.Utility.setViewportForElement id

                                Nothing ->
                                    Nav.pushUrl model.key (Url.toString url)
                    in
                    ( model, cmd )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            -- ( model, Cmd.none )
            ( { model | url = url }
            , Cmd.batch
                [ UrlManager.handleDocId url
                ]
            )

        -- UI
        GotNewWindowDimensions w h ->
            ( { model | windowWidth = w, windowHeight = h }, Cmd.none )

        GotViewport vp ->
            Frontend.Update.updateWithViewport vp model

        SetViewPortForElement result ->
            case result of
                Ok ( element, viewport ) ->
                    ( model, View.Utility.setViewPortForSelectedLine element viewport )

                Err _ ->
                    ( model, Cmd.none )

        ChangePopupStatus status ->
            ( { model | popupStatus = status }, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        ToggleEditor ->
            ( { model | showEditor = not model.showEditor }, Cmd.none )

        Help docId ->
            ( model, sendToBackend (GetDocumentById docId) )

        -- USER
        SignIn ->
            if String.length model.inputPassword >= 8 then
                ( model
                , sendToBackend (SignInOrSignUp model.inputUsername (Authentication.encrypt model.inputPassword))
                )

            else
                ( { model | message = "Password must be at least 8 letters long." }, Cmd.none )

        InputUsername str ->
            ( { model | inputUsername = str }, Cmd.none )

        InputPassword str ->
            ( { model | inputPassword = str }, Cmd.none )

        SignOut ->
            ( { model
                | currentUser = Nothing
                , currentDocument = Data.notSignedIn
                , documents = [ Data.notSignedIn ]
                , message = "Signed out"
              }
            , Cmd.none
            )

        -- ADMIN
        Test ->
            ( model, sendToBackend RunTest )

        GetUsers ->
            ( model, sendToBackend SendUsers )

        -- DOCUMENT
        InputText str ->
            let
                document =
                    model.currentDocument

                newTitle =
                    CaYaTeX.getTitle str

                newDocument =
                    { document | content = str, title = newTitle }

                documents =
                    List.Extra.setIf (\doc -> doc.id == newDocument.id) newDocument model.documents
            in
            ( { model | documents = documents, currentDocument = newDocument, counter = model.counter + 1 }
            , Frontend.Cmd.saveDocument model newDocument
            )

        AskFoDocumentById id ->
            ( model, sendToBackend (GetDocumentById id) )

        InputSearchKey str ->
            ( { model | inputSearchKey = str }, Cmd.none )

        NewDocument ->
            Frontend.Update.newDocument model

        ChangeDocumentDeleteStateFrom docDeleteState ->
            case docDeleteState of
                WaitingForDeleteAction ->
                    if Just model.currentDocument.username /= Maybe.map .username model.currentUser then
                    (model, Cmd.none)

                    ( { model | documentDeleteState = DocumentDeletePending }, Cmd.none )

                DocumentDeletePending ->
                    Frontend.Update.deleteDocument model

        FetchDocuments searchTerm ->
            ( model, sendToBackend (GetDocumentsWithQuery model.currentUser searchTerm) )

        ExportToLaTeX ->
            let
                latexText =
                    Render.LaTeX.renderAsDocument model.currentDocument.content

                fileName =
                    model.currentDocument.title |> String.replace " " "-" |> String.toLower |> (\name -> name ++ ".tex")
            in
            ( model, Download.string fileName "application/x-latex" latexText )

        PrintToPDF ->
            UpdateLaTeX.printToPDF model

        GotPdfLink result ->
            UpdateLaTeX.gotPdfLink model result

        ChangePrintingState printingState ->
            let
                cmd =
                    if printingState == PrintWaiting then
                        Process.sleep 1000 |> Task.perform (always (FinallyDoCleanPrintArtefacts model.currentDocument.id))

                    else
                        Cmd.none
            in
            ( { model | printingState = printingState }, cmd )

        FinallyDoCleanPrintArtefacts id ->
            ( model, Cmd.none )

        ToggleAccess ->
            let
                document =
                    case model.currentDocument.access of
                        Public ->
                            Document.setAccess Private model.currentDocument

                        Private ->
                            Document.setAccess Public model.currentDocument

                        Shared _ ->
                            model.currentDocument
            in
            ( Frontend.Update.updateCurrentDocument document model, Frontend.Cmd.saveDocument model document )

        CYT msg_ ->
            case msg_ of
                CYDocumentLink docId ->
                    ( model, sendToBackend (GetDocumentById docId) )

                _ ->
                    ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        -- ADMIN
        GotUsers users ->
            ( { model | users = users }, Cmd.none )

        -- USER
        SendUser user ->
            ( { model | currentUser = Just user }, Cmd.none )

        LoginGuest ->
            ( { model | currentUser = Just User.guest }, Cmd.none )

        -- DOCUMENT
        SendDocument doc ->
            let
                documents =
                    Util.insertInList doc model.documents

                message =
                    "Documents: " ++ String.fromInt (List.length documents)
            in
            ( { model | currentDocument = doc, documents = documents }, Cmd.none )

        SendDocuments docs ->
            let
                sortedDocs =
                    List.sortBy (\doc -> doc.title) docs
            in
            ( { model
                | documents = sortedDocs
                , message = "Documents received: " ++ String.fromInt (List.length docs)
                , currentDocument = List.head sortedDocs |> Maybe.withDefault Data.docsNotFound
              }
            , Cmd.none
            )

        SendMessage message ->
            ( { model | message = message }, Cmd.none )


view : Model -> { title : String, body : List (Html.Html FrontendMsg) }
view model =
    { title = ""
    , body =
        [ View.Main.view model ]
    }
