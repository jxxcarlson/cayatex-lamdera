module Frontend.Update exposing
    ( newDocument
    , updateCurrentDocument
    , updateWithViewport
    )

import Document exposing (Document)
import Lamdera exposing (sendToBackend)
import List.Extra
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
                        | title = "New Document"
                        , author = user.realname
                        , username = user.username
                        , content = "[title New Document]"
                    }
            in
            ( model, sendToBackend (RegisterNewDocument doc) )


updateCurrentDocument : Document -> FrontendModel -> FrontendModel
updateCurrentDocument doc model =
    { model | currentDocument = doc, documents = List.Extra.setIf (\d -> d.id == doc.id) doc model.documents }
