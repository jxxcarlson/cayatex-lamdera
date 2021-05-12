module Document exposing (Access(..), Document, empty, setAccess)

import Time


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


type alias Username =
    String


type Access
    = Public
    | Private
    | Shared { canRead : List Username, canWrite : List Username }


empty =
    { title = "Empty Doc"
    , author = "No Name"
    , username = "noname123"
    , id = "1"
    , created = Time.millisToPosix 0
    , modified = Time.millisToPosix 0
    , tags = []
    , content = ""
    , access = Private
    }


setAccess access document =
    { document | access = access }
