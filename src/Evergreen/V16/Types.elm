module Evergreen.V16.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V16.Document
import Evergreen.V16.Parser.Element
import Evergreen.V16.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V16.User.User
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V16.Document.Document
    , documents : List Evergreen.V16.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , documents : List Evergreen.V16.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V16.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Browser.Dom.Viewport
    | SignIn
    | SignOut
    | Test
    | InputText String
    | NewDocument
    | AskFoDocumentById String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SaveDocument Evergreen.V16.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V16.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendDocument Evergreen.V16.Document.Document
    | SendDocuments (List Evergreen.V16.Document.Document)
    | SendMessage String
