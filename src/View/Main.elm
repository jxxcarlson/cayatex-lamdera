module View.Main exposing (view)

import CaYaTeX
import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes as Attr
import Types exposing (..)
import View.Button as Button
import View.Style
import View.Utility


type alias Model =
    FrontendModel


view : Model -> Html FrontendMsg
view model =
    E.layoutWith { options = [ E.focusStyle View.Utility.noFocus ] }
        [ View.Style.bgGray 0.9, E.clipX, E.clipY ]
        (mainColumn model)


mainColumn : Model -> Element FrontendMsg
mainColumn model =
    E.column (mainColumnStyle model)
        [ E.column [ E.spacing 12, E.width (E.px <| appWidth_ model), E.height (E.px (appHeight_ model)) ]
            [ title "CaYaTeX"
            , buttonHeader model
            , E.column [ E.spacing 12 ]
                [ E.row [ E.spacing 12 ] [ inputElement model, viewRendered model ]
                ]
            , E.row [ E.moveUp 10, E.spacing 12, E.paddingXY 12 8, E.height (E.px 25), E.width (E.px (2 * panelWidth_ model + 15)), Font.size 14, View.Style.bgGray 0.1, View.Style.fgGray 1.0 ]
                [ E.text model.message, E.text ("width: " ++ String.fromInt model.windowWidth), E.text ("height: " ++ String.fromInt model.windowHeight) ]
            ]
        ]


buttonHeader model =
    E.row [ E.spacing 12 ] [ Button.getDocument, Button.signIn ]


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
