module Backend exposing (..)

import Authentication
import Backend.Cmd
import Backend.Update
import Data
import Dict
import Document exposing (Access(..))
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

      -- USER
      , authenticationDict = Dict.empty

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
                    List.map (\doc -> (doc.id |> String.left 5) ++ " (" ++ (doc.username |> String.left 3) ++ ": " ++ (doc.title |> String.left 5) ++ ")")
                        (List.filter (\doc -> doc.username == "jxxcarlson") model.documents)

                message =
                    "ids (" ++ String.fromInt (List.length ids) ++ "): " ++ String.join ", " ids

                filteredDocs =
                    List.filter (\doc -> doc.id /= "1" || String.length doc.title > 0) model.documents
            in
            ( { model | documents = filteredDocs }, sendToFrontend clientId (SendMessage message) )

        SendUsers ->
            ( model, sendToFrontend clientId (GotUsers (Authentication.users model.authenticationDict)) )

        -- USER
        SignInOrSignUp username encryptedPassword ->
            case Dict.get username model.authenticationDict of
                Just userData ->
                    if Authentication.verify username encryptedPassword model.authenticationDict then
                        ( model
                        , Cmd.batch
                            [ sendToFrontend clientId (SendDocuments (List.filter (\doc -> doc.username == username || doc.access == Public) model.documents))
                            , sendToFrontend clientId (SendUser userData.user)
                            ]
                        )

                    else
                        ( model, sendToFrontend clientId (SendMessage <| "Sorry, password and username don't match") )

                Nothing ->
                    Backend.Update.setupUser model clientId username encryptedPassword

        -- DOCUMENTS
        GetUserDocuments username ->
            ( model, sendToFrontend clientId (SendDocuments (List.filter (\doc -> doc.username == username) model.documents)) )

        GetDocumentsWithQuery user (Query searchTerm) ->
            let
                _ =
                    Debug.log "ST" searchTerm

                docsFound =
                    Document.search user searchTerm model.documents

                _ =
                    Debug.log "TITLES FOUND" (List.map .title docsFound)
            in
            ( model, sendToFrontend clientId (SendDocuments docsFound) )

        RegisterNewDocument doc_ ->
            let
                { token, seed } =
                    Token.get model.randomSeed

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
                        , sendToFrontend clientId (SendMessage ("Found: " ++ doc.title))
                        ]
                    )


idMessage model =
    "ids: " ++ (List.map .id model.documents |> String.join ", ")
