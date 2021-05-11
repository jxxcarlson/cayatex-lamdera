module User exposing (User, defaultUser)


type alias User =
    { username : String
    , id : String
    , realname : String
    , email : String
    }


defaultUser =
    { username = "jxxcarlson"
    , id = "ekvdo-oaeaw"
    , realname = "James Carlson"
    , email = "jxxcarlson@gmail.com"
    }
