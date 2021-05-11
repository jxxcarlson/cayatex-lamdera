module View.Button exposing (getDocument, linkTemplate, signIn)

import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Types exposing (..)
import View.Color as Color
import View.Style
import View.Utility


buttonTemplate : msg -> String -> Element msg
buttonTemplate msg label_ =
    E.row [ View.Style.bgGray 0.2, E.pointer, E.mouseDown [ Background.color Color.darkRed ] ]
        [ Input.button View.Style.buttonStyle
            { onPress = Just msg
            , label = E.el [ E.centerX, E.centerY, Font.size 14 ] (E.text label_)
            }
        ]


linkTemplate : msg -> String -> Element msg
linkTemplate msg label_ =
    E.row [ E.pointer, E.mouseDown [ Background.color Color.paleBlue ] ]
        [ Input.button linkStyle
            { onPress = Just msg
            , label = E.el [ E.centerX, E.centerY, Font.size 14, Font.color Color.blue ] (E.text label_)
            }
        ]


linkStyle =
    [ Font.color (E.rgb255 255 255 255)
    , E.paddingXY 8 2
    ]


getDocument : Element FrontendMsg
getDocument =
    buttonTemplate (AskFoDocumentById "aboutCYT") "Get document"


signIn : Element FrontendMsg
signIn =
    buttonTemplate SignIn "Sign in"
