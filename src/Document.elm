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
    }


empty =
    { title = ""
    , author = ""
    , id = "1"
    , created = Time.millisToPosix 0
    , modified = Time.millisToPosix 0
    , tags = []
    , content = ""
    }
