module Evergreen.V40.Authentication exposing (..)

import Dict
import Evergreen.V40.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V40.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
