module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Data
import Document exposing (Document)
import Http
import Parser.Element
import Random
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String

    -- DOCUMENT
    , currentDocument : Document
    }


type alias BackendModel =
    { message : String

    -- RANDOM
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    }


type alias CaYaTeXMsg =
    Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
