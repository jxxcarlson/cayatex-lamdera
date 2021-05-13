module Evergreen.V36.Authentication exposing (..)

import Dict
import Evergreen.V36.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V36.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
