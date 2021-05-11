module Backend.Update exposing (..)

import Lamdera exposing (ClientId, broadcast, sendToFrontend)
import Random
import Types exposing (..)


type alias Model =
    BackendModel


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
