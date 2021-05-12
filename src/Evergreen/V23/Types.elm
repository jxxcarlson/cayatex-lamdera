module Evergreen.V23.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V23.Authentication
import Evergreen.V23.Document
import Evergreen.V23.Parser.Element
import Evergreen.V23.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V23.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V23.Document.Document
    , documents : List Evergreen.V23.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V23.Authentication.AuthenticationDict
    , documents : List Evergreen.V23.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V23.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Browser.Dom.Viewport
    | SetViewPortForElement (Result Browser.Dom.Error ( Browser.Dom.Element, Browser.Dom.Viewport ))
    | SignIn
    | SignOut
    | InputUsername String
    | InputPassword String
    | Test
    | InputText String
    | NewDocument
    | AskFoDocumentById String
    | ToggleAccess
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SignInOrSignUp String String
    | SaveDocument Evergreen.V23.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V23.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendUser Evergreen.V23.User.User
    | SendDocument Evergreen.V23.Document.Document
    | SendDocuments (List Evergreen.V23.Document.Document)
    | SendMessage String
