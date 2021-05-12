module View.Input exposing (passwordInput, usernameInput)

import Element as E exposing (Element, px)
import Element.Font as Font
import Element.Input as Input
import Types exposing (FrontendMsg(..))


inputFieldTemplate : String -> (String -> msg) -> String -> Element msg
inputFieldTemplate default msg text =
    Input.text [ E.moveUp 5, Font.size 16, E.height (px 33) ]
        { onChange = msg
        , text = text
        , label = Input.labelHidden default
        , placeholder = Just <| Input.placeholder [ E.moveUp 5 ] (E.text default)
        }


passwordTemplate : String -> (String -> msg) -> String -> Element msg
passwordTemplate default msg text =
    Input.currentPassword [ E.moveUp 5, Font.size 16, E.height (px 33) ]
        { onChange = msg
        , text = text
        , label = Input.labelHidden default
        , placeholder = Just <| Input.placeholder [ E.moveUp 5 ] (E.text default)
        , show = False
        }


usernameInput model =
    inputFieldTemplate "Username" InputUsername model.inputUsername


passwordInput model =
    passwordTemplate "Password" InputPassword model.inputPassword
