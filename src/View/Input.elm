module View.Input exposing (usernameInput)

import Element as E exposing (Element, px)
import Element.Font as Font
import Element.Input as Input
import Types exposing (FrontendMsg(..))


inputFieldTemplate : String -> (String -> msg) -> String -> Element msg
inputFieldTemplate default msg text =
    Input.text [ E.moveUp 4, Font.size 16, E.height (px 33) ] { onChange = msg, text = text, label = Input.labelHidden default, placeholder = Nothing }


usernameInput model =
    inputFieldTemplate "Username" InputUsername model.inputUsername
