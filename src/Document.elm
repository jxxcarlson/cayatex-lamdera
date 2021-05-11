module Document exposing (Document, empty)

import Time


type alias Document =
    { title : String
    , author : String
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
    | Restricted { canRead : List Username, canWrite : List Username }


empty =
    { title = ""
    , author = ""
    , id = "1"
    , created = Time.millisToPosix 0
    , modified = Time.millisToPosix 0
    , tags = []
    , content = ""
    , access = Private
    }
