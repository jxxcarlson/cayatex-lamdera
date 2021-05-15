module Evergreen.V56.Authentication exposing (..)

import Dict
import Evergreen.V56.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V56.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
