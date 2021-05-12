module Evergreen.V22.Authentication exposing (..)

import Dict
import Evergreen.V22.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V22.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
