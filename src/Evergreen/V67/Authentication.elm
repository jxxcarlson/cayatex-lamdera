module Evergreen.V67.Authentication exposing (..)

import Dict
import Evergreen.V67.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V67.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
