module Backend exposing (..)

import Backend.Cmd
import Backend.Update
import Data
import Html
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import List.Extra
import Random
import Token
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
      , documents =
            [ Data.aboutCayatex
            , Data.docsNotFound
            , Data.notSignedIn
            , Data.foo
            ]
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

        -- ADMIN
        RunTest ->
            let
                ids =
                    List.map (\doc -> (doc.id |> String.left 5) ++ " (" ++ (doc.username |> String.left 3) ++ ": " ++ (doc.title |> String.left 5) ++ ")") model.documents

                message =
                    "ids (" ++ String.fromInt (List.length ids) ++ "): " ++ String.join ", " ids

                filteredDocs =
                    List.filter (\doc -> doc.id /= "1" || String.length doc.title > 0) model.documents
            in
            ( { model | documents = filteredDocs }, sendToFrontend clientId (SendMessage message) )

        -- DOCUMENTS
        GetUserDocuments username ->
            ( model, sendToFrontend clientId (SendDocuments (List.filter (\doc -> doc.username == username) model.documents)) )

        RegisterNewDocument doc_ ->
            let
                { token, seed } =
                    Token.get model.randomSeed 3 5

                doc =
                    { doc_ | id = token }

                newDocuments =
                    doc :: model.documents

                message =
                    "Registered document: " ++ doc.title ++ "(" ++ String.fromInt (List.length newDocuments) ++ ")"
            in
            ( { model | randomSeed = seed, documents = newDocuments }
            , Cmd.batch
                [ sendToFrontend clientId (SendDocument doc)
                , sendToFrontend clientId (SendMessage message)
                ]
            )

        SaveDocument document ->
            let
                newDocuments =
                    List.Extra.setIf (\doc -> doc.id == document.id) document model.documents
            in
            ( { model | documents = newDocuments }, sendToFrontend clientId (SendMessage ("Saved document: " ++ document.title)) )

        GetDocumentById id ->
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
