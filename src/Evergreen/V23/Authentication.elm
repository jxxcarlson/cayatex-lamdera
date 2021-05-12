module Evergreen.V23.Authentication exposing (..)

import Dict
import Evergreen.V23.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V23.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
