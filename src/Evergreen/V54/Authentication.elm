module Evergreen.V54.Authentication exposing (..)

import Dict
import Evergreen.V54.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V54.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
