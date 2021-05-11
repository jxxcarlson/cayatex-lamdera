module Evergreen.V9.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V9.Document
import Evergreen.V9.Parser.Element
import Evergreen.V9.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V9.User.User
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V9.Document.Document
    , documents : List Evergreen.V9.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , documents : List Evergreen.V9.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V9.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Browser.Dom.Viewport
    | SignIn
    | InputText String
    | NewDocument
    | AskFoDocumentById String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | SaveDocument Evergreen.V9.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V9.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendDocument Evergreen.V9.Document.Document
    | SendDocuments (List Evergreen.V9.Document.Document)
    | SendMessage String
