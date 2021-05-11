module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V2.Document
import Evergreen.V2.Parser.Element
import Evergreen.V2.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V2.User.User
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V2.Document.Document
    , documents : List Evergreen.V2.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , documents : List Evergreen.V2.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V2.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Browser.Dom.Viewport
    | SignIn
    | InputText String
    | AskFoDocumentById String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | SaveDocument Evergreen.V2.Document.Document
    | GetUserDocuments String
    | GetDocumentById String


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendDocument Evergreen.V2.Document.Document
    | SendDocuments (List Evergreen.V2.Document.Document)
    | SendMessage String
