module Backend exposing (..)

import Backend.Cmd
import Backend.Update
import Data
import Html
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import List.Extra
import Random
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "Hello!"

      -- RANDOM
      , randomSeed = Random.initialSeed 1234
      , uuidCount = 0
      , randomAtmosphericInt = Nothing

      -- DOCUMENTS
      , documents = [ Data.docsNotFound, Data.aboutCayatex ]
      }
    , Backend.Cmd.getRandomNumber
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        GotAtomsphericRandomNumber result ->
            Backend.Update.gotAtomsphericRandomNumber model result


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        SaveDocument document ->
            let
                newDocuments =
                    List.Extra.setIf (\doc -> doc.id == document.id) document model.documents
            in
            ( { model | documents = newDocuments }, sendToFrontend clientId (SendMessage ("Saved document: " ++ document.title)) )

        GetDocumentById id ->
            let
                _ =
                    Debug.log "IDS" (List.map .id model.documents)
            in
            case List.head (List.filter (\doc -> doc.id == id) model.documents) of
                Nothing ->
                    ( model
                    , sendToFrontend clientId (SendMessage <| "Could not find document: " ++ id ++ ", " ++ idMessage model)
                    )

                Just doc ->
                    ( model
                    , Cmd.batch
                        [ sendToFrontend clientId (SendDocument doc)
                        , sendToFrontend clientId (SendMessage ("Found & sent document: " ++ doc.title))
                        ]
                    )


idMessage model =
    "ids: " ++ (List.map .id model.documents |> String.join ", ")
