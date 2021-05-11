module Token exposing (randomWords, token)

import Random
import Random.Char
import Random.String


token : Random.Seed -> Int -> Int -> { word : String, seed : Random.Seed }
token seed n wordLength =
    randomWords seed n wordLength |> (\result -> { word = String.join "-" result.words, seed = result.seed })


randomWords : Random.Seed -> Int -> Int -> { words : List String, seed : Random.Seed }
randomWords seed n wordLength =
    loop
        { words = []
        , seed = seed
        , wordLength = wordLength
        , wordsToMake = n
        }
        nextState


type alias State =
    { words : List String
    , seed : Random.Seed
    , wordLength : Int
    , wordsToMake : Int
    }


nextState : State -> Step State { words : List String, seed : Random.Seed }
nextState state =
    if state.wordsToMake == 0 then
        Done { words = state.words, seed = state.seed }

    else
        let
            ( newWord, newSeed ) =
                Random.step (Random.String.string state.wordLength Random.Char.lowerCaseLatin) state.seed
        in
        Loop { state | wordsToMake = state.wordsToMake - 1, words = newWord :: state.words, seed = newSeed }


type Step state a
    = Loop state
    | Done a


loop : state -> (state -> Step state a) -> a
loop s nextState_ =
    case nextState_ s of
        Loop s_ ->
            loop s_ nextState_

        Done b ->
            b
