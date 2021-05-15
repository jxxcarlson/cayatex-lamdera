module Evergreen.V70.Authentication exposing (..)

import Dict
import Evergreen.V70.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V70.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
