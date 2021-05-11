module Frontend.Update exposing
    ( newDocument
    , updateWithViewport
    )

import Document exposing (Document)
import Lamdera exposing (sendToBackend)
import Types exposing (..)


updateWithViewport vp model =
    let
        w =
            round vp.viewport.width

        h =
            round vp.viewport.height
    in
    ( { model
        | windowWidth = w
        , windowHeight = h
      }
    , Cmd.none
    )


newDocument model =
    case model.currentUser of
        Nothing ->
            ( model, Cmd.none )

        Just user ->
            let
                emptyDoc =
                    Document.empty

                doc =
                    { emptyDoc
                        | author = user.realname
                        , username = user.username
                        , content = "[title New Document]"
                    }
            in
            ( model, sendToBackend (RegisterNewDocument doc) )
