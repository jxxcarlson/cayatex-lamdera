module Evergreen.V1.Document exposing (..)

import Time


type alias Document =
    { title : String
    , author : String
    , id : String
    , created : Time.Posix
    , modified : Time.Posix
    , tags : List String
    , content : String
    }
