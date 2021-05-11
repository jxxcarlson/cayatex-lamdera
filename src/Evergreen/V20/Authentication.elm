module Evergreen.V20.Authentication exposing (..)

import Dict
import Evergreen.V20.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V20.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
