module Evergreen.V17.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V17.Document
import Evergreen.V17.Parser.Element
import Evergreen.V17.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V17.User.User
    , inputUsername : String
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V17.Document.Document
    , documents : List Evergreen.V17.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , documents : List Evergreen.V17.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V17.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Browser.Dom.Viewport
    | SignIn
    | SignOut
    | InputUsername String
    | Test
    | InputText String
    | NewDocument
    | AskFoDocumentById String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SaveDocument Evergreen.V17.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V17.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendDocument Evergreen.V17.Document.Document
    | SendDocuments (List Evergreen.V17.Document.Document)
    | SendMessage String
