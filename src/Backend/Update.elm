module Backend.Update exposing
    ( gotAtomsphericRandomNumber
    , setupUser
    )

import Authentication
import Document exposing (Access(..))
import Lamdera exposing (ClientId, broadcast, sendToFrontend)
import Random
import Token
import Types exposing (..)
import User exposing (User)


type alias Model =
    BackendModel



-- SYSTEM


gotAtomsphericRandomNumber : Model -> Result error String -> ( Model, Cmd msg )
gotAtomsphericRandomNumber model result =
    case result of
        Ok str ->
            case String.toInt (String.trim str) of
                Nothing ->
                    ( model, Cmd.none )

                Just rn ->
                    let
                        newRandomSeed =
                            Random.initialSeed rn
                    in
                    ( { model
                        | randomAtmosphericInt = Just rn
                        , randomSeed = newRandomSeed
                      }
                    , Cmd.none
                    )

        Err _ ->
            ( model, Cmd.none )



-- USER


setupUser : Model -> ClientId -> String -> String -> ( BackendModel, Cmd BackendMsg )
setupUser model clientId username encryptedPassword =
    let
        { token, seed } =
            Token.get model.randomSeed

        tokenData =
            Token.get seed

        user =
            { username = username, id = tokenData.token, realname = "Undefined", email = "Undefined" }

        homePage =
            Document.makeHomePage username

        -- TO BE DEFINED LATER BY USER: realname, email
        newAuthDict =
            Authentication.insert user encryptedPassword model.authenticationDict
    in
    ( { model | randomSeed = tokenData.seed, authenticationDict = newAuthDict, documents = homePage :: model.documents }
    , Cmd.batch
        [ sendToFrontend clientId (SendMessage "Success! You have set up your CaYaTeX account")
        , sendToFrontend clientId (SendUser user)
        , sendToFrontend clientId (SendDocuments (homePage :: List.filter (\doc -> doc.access == Public) model.documents))
        ]
    )
