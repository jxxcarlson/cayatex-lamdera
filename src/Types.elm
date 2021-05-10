module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Dom as Dom
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

    -- UI
    , windowWidth : Int
    , windowHeight : Int

    -- DOCUMENT
    , currentDocument : Document
    , counter : Int
    }


type alias BackendModel =
    { message : String

    -- RANDOM
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int

    -- DOCUMENT
    , documents : List Document
    }


type alias CaYaTeXMsg =
    Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
      -- UI
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Dom.Viewport
      -- DOC
    | InputText String
    | AskFoDocumentById String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | SaveDocument Document
    | GetDocumentById String


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendDocument Document
    | SendMessage String
