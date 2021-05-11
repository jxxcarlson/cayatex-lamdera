module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events
import Browser.Navigation as Nav
import Data
import Frontend.Cmd
import Frontend.Update
import Html exposing (Html)
import Lamdera exposing (sendToBackend)
import Types exposing (..)
import Url
import User
import Util
import View.Main


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
      , message = "Welcome!"

      -- UI
      , windowWidth = 600
      , windowHeight = 900

      -- USER
      , currentUser = Nothing

      -- DOCUMENT
      , counter = 0
      , documents = [ Data.notSignedIn ]
      , currentDocument = Data.notSignedIn
      }
    , Cmd.batch [ Frontend.Cmd.setupWindow ]
    )



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
                                    Cmd.none

                                -- View.Sync.setViewportForElement id
                                Nothing ->
                                    Nav.pushUrl model.key (Url.toString url)
                    in
                    ( model, cmd )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        GotNewWindowDimensions w h ->
            ( { model | windowWidth = w, windowHeight = h }, Cmd.none )

        GotViewport vp ->
            Frontend.Update.updateWithViewport vp model

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        -- USER
        SignIn ->
            ( { model | currentUser = Just User.defaultUser, message = "signed  in" }
            , sendToBackend (GetUserDocuments User.defaultUser.username)
            )

        -- DOCUMENT
        InputText str ->
            let
                document =
                    model.currentDocument

                newDocument =
                    { document | content = str }
            in
            ( { model | currentDocument = newDocument, counter = model.counter + 1 }, sendToBackend (SaveDocument newDocument) )

        AskFoDocumentById id ->
            ( model, sendToBackend (GetDocumentById id) )

        NewDocument ->
            Frontend.Update.newDocument model

        CYT _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        SendDocument doc ->
            let
                documents =
                    Util.insertInList doc model.documents

                message =
                    "Docements: " ++ String.fromInt (List.length documents)
            in
            ( { model | currentDocument = doc, documents = documents }, Cmd.none )

        SendDocuments docs ->
            ( { model | documents = docs, message = "Documents received: " ++ String.fromInt (List.length docs) }
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
