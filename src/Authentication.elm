module Authentication exposing (..)

import Crypto.HMAC exposing (sha256)
import Dict exposing (Dict)
import Env
import User exposing (User)


type alias Username =
    String


type alias UserData =
    { user : User, token : String }


type alias AuthenticationDict =
    Dict Username UserData


insert : User -> String -> AuthenticationDict -> AuthenticationDict
insert user token authDict =
    Dict.insert user.username { user = user, token = Crypto.HMAC.digest sha256 Env.authKey token } authDict


authorized : String -> String -> AuthenticationDict -> Bool
authorized username token authDict =
    case Dict.get username authDict of
        Nothing ->
            False

        Just data ->
            token == data.token
