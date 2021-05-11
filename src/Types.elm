module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom as Dom
import Browser.Navigation exposing (Key)
import Data
import Document exposing (Document)
import Http
import Parser.Element
import Random
import Url exposing (Url)
import User exposing (User)


type alias FrontendModel =
    { key : Key
    , message : String

    -- USER
    , currentUser : Maybe User
    , inputUsername : String

    -- UI
    , windowWidth : Int
    , windowHeight : Int

    -- DOCUMENT
    , currentDocument : Document
    , documents : List Document
    , counter : Int
    }


type alias BackendModel =
    { message : String

    -- RANDOM
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int

    -- USER
    , authenticationDict : AuthenticationDict

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
      -- USER
    | SignIn
    | SignOut
    | InputUsername String
      -- ADMIN
    | Test
      -- DOC
    | InputText String
    | NewDocument
    | AskFoDocumentById String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
      -- ADMIN
    | RunTest
      -- DOCUMENT
    | SaveDocument Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
      -- DOCUMENT
    | SendDocument Document
    | SendDocuments (List Document)
    | SendMessage String
