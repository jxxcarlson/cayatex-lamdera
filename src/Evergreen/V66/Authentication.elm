module Evergreen.V66.Authentication exposing (..)

import Dict
import Evergreen.V66.User


type alias Username =
    String


type alias UserData =
    { user : Evergreen.V66.User.User
    , token : String
    }


type alias AuthenticationDict =
    Dict.Dict Username UserData
