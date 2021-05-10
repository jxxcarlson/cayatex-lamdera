module Backend.Update exposing (..)

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
                    let
                        _ =
                            Debug.log "ERRROR" "could not get random atmos number"
                    in
                    ( model, Cmd.none )

                Just rn ->
                    let
                        newRandomSeed =
                            Random.initialSeed rn
                    in
                    ( { model
                        | randomAtmosphericInt = Just rn |> Debug.log "RN ATMOS"
                        , randomSeed = newRandomSeed |> Debug.log "RN SEED"
                      }
                    , Cmd.none
                    )

        Err _ ->
            ( model, Cmd.none )
