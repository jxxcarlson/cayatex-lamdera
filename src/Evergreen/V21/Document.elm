module Evergreen.V21.Document exposing (..)

import Time


type alias Username =
    String


type Access
    = Public
    | Private
    | Restricted
        { canRead : List Username
        , canWrite : List Username
        }


type alias Document =
    { title : String
    , author : String
    , username : String
    , id : String
    , created : Time.Posix
    , modified : Time.Posix
    , tags : List String
    , content : String
    , access : Access
    }
