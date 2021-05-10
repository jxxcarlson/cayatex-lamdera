module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import CaYaTeX
import Data
import Element exposing (Element)
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes as Attr
import Lamdera
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


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome!"
      , currentDocument = Data.aboutCayatex
      }
    , Cmd.none
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

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        CYT _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


view : Model -> { title : String, body : List (Html.Html FrontendMsg) }
view model =
    { title = ""
    , body =
        [ view_ model ]
    }


view_ : Model -> Html FrontendMsg
view_ model =
    Element.layoutWith { options = [ Element.focusStyle View.Utility.noFocus ] }
        [ View.Style.bgGray 0.9, Element.clipX, Element.clipY ]
        (mainView model)


mainView : Model -> Element FrontendMsg
mainView model =
    Element.column [ Element.width (Element.px 500), Element.centerX, Font.size 14 ]
        [ View.Utility.katexCSS
        , innerMainView model |> Element.map CYT
        ]


innerMainView model =
    CaYaTeX.renderString 0 model.currentDocument.content
