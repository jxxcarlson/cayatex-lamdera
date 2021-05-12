module Evergreen.V22.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V22.Authentication
import Evergreen.V22.Document
import Evergreen.V22.Parser.Element
import Evergreen.V22.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V22.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V22.Document.Document
    , documents : List Evergreen.V22.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V22.Authentication.AuthenticationDict
    , documents : List Evergreen.V22.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V22.Parser.Element.CYTMsg


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
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SignInOrSignUp String String
    | SaveDocument Evergreen.V22.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V22.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendUser Evergreen.V22.User.User
    | SendDocument Evergreen.V22.Document.Document
    | SendDocuments (List Evergreen.V22.Document.Document)
    | SendMessage String
