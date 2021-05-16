module Evergreen.V72.Authentication exposing (..)

import Dict
import Evergreen.V72.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V72.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
