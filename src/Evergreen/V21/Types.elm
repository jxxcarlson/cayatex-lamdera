module Evergreen.V21.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V21.Authentication
import Evergreen.V21.Document
import Evergreen.V21.Parser.Element
import Evergreen.V21.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V21.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V21.Document.Document
    , documents : List Evergreen.V21.Document.Document
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V21.Authentication.AuthenticationDict
    , documents : List Evergreen.V21.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V21.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotNewWindowDimensions Int Int
    | NoOpFrontendMsg
    | GotViewport Browser.Dom.Viewport
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
    | SaveDocument Evergreen.V21.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V21.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendUser Evergreen.V21.User.User
    | SendDocument Evergreen.V21.Document.Document
    | SendDocuments (List Evergreen.V21.Document.Document)
    | SendMessage String
