module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events
import Browser.Navigation as Nav
import CaYaTeX
import Data
import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Frontend.Cmd
import Frontend.Update
import Html exposing (Html)
import Html.Attributes as Attr
import Lamdera exposing (sendToBackend)
import Types exposing (..)
import Url
import View.Style
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
      , message = "Welcome!"

      -- UI
      , windowWidth = 600
      , windowHeight = 900

      -- DOCUMENT
      , counter = 0
      , currentDocument = Data.docsNotFound
      }
    , Cmd.batch [ Frontend.Cmd.setupWindow, sendToBackend (GetDocumentById "aboutCYT") ]
    )


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

                --( model
                --, Cmd.none
                --  --, Cmd.batch [ Nav.pushUrl model.key (Url.toString url) ]
                --)
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

        CYT _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        SendDocument doc ->
            ( { model | currentDocument = doc }, Cmd.none )

        SendMessage message ->
            ( { model | message = message }, Cmd.none )


view : Model -> { title : String, body : List (Html.Html FrontendMsg) }
view model =
    { title = ""
    , body =
        [ view_ model ]
    }


view_ : Model -> Html FrontendMsg
view_ model =
    E.layoutWith { options = [ E.focusStyle View.Utility.noFocus ] }
        [ View.Style.bgGray 0.9, E.clipX, E.clipY ]
        (mainColumn model)


mainColumn : Model -> Element FrontendMsg
mainColumn model =
    E.column (mainColumnStyle model)
        [ E.column [ E.spacing 12, E.width (E.px <| appWidth_ model), E.height (E.px (appHeight_ model)) ]
            [ title "CaYaTeX Test App"
            , E.row [] [ getDocumentButton ]
            , E.column [ E.spacing 12 ]
                [ E.row [ E.spacing 12 ] [ inputElement model, viewRendered model ]
                ]
            , E.row [ E.moveUp 10, E.spacing 12, E.paddingXY 12 8, E.height (E.px 25), E.width (E.px (2 * panelWidth_ model + 15)), Font.size 14, View.Style.bgGray 0.1, View.Style.fgGray 1.0 ]
                [ E.text model.message, E.text ("width: " ++ String.fromInt model.windowWidth), E.text ("height: " ++ String.fromInt model.windowHeight) ]
            ]
        ]


inputElement : Model -> Element FrontendMsg
inputElement model =
    E.column [ E.spacing 8, E.alignTop, E.moveUp 8 ]
        [ E.row [ E.spacing 12 ] []
        , inputText model
        ]


inputText : Model -> Element FrontendMsg
inputText model =
    Input.multiline [ E.height (E.px (panelHeight_ model)), E.width (E.px (panelWidth_ model)), Font.size 14 ]
        { onChange = InputText
        , text = model.currentDocument.content
        , placeholder = Nothing
        , label = Input.labelHidden "Enter source text here"
        , spellcheck = False
        }


viewRendered : Model -> Element FrontendMsg
viewRendered model =
    E.column [ E.paddingXY 12 12, View.Style.bgGray 0.9, E.width (E.px (panelWidth_ model)), E.height (E.px (panelHeight_ model)), E.centerX, Font.size 14, E.alignTop, E.scrollbarY ]
        [ View.Utility.katexCSS
        , CaYaTeX.renderString model.counter model.currentDocument.content |> E.map CYT
        ]



-- DIMENSIONS


panelWidth_ model =
    min 600 ((model.windowWidth - 100) // 2)


appHeight_ model =
    model.windowHeight - 100


panelHeight_ model =
    appHeight_ model - 100


appWidth_ model =
    2 * panelWidth_ model + 15


mainColumnStyle model =
    [ E.centerX
    , E.centerY
    , View.Style.bgGray 0.5
    , E.paddingXY 20 20
    , E.width (E.px (appWidth_ model + 40))
    , E.height (E.px (appHeight_ model + 40))
    ]


title : String -> Element msg
title str =
    E.row [ E.centerX, View.Style.fgGray 0.9 ] [ E.text str ]


getDocumentButton : Element FrontendMsg
getDocumentButton =
    E.row [ View.Style.bgGray 0.2 ]
        [ Input.button View.Style.buttonStyle
            { onPress = Just (AskFoDocumentById "jc0001")
            , label = E.el [ E.centerX, E.centerY, Font.size 14 ] (E.text "Get document")
            }
        ]
