module Evergreen.V31.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V31.Authentication
import Evergreen.V31.Document
import Evergreen.V31.Parser.Element
import Evergreen.V31.User
import Http
import Random
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , currentUser : Maybe Evergreen.V31.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , currentDocument : Evergreen.V31.Document.Document
    , documents : List Evergreen.V31.Document.Document
    , inputSearchKey : String
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V31.Authentication.AuthenticationDict
    , documents : List Evergreen.V31.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V31.Parser.Element.CYTMsg


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
    | InputSearchKey String
    | NewDocument
    | AskFoDocumentById String
    | ToggleAccess
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SignInOrSignUp String String
    | SaveDocument Evergreen.V31.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V31.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | SendUser Evergreen.V31.User.User
    | SendDocument Evergreen.V31.Document.Document
    | SendDocuments (List Evergreen.V31.Document.Document)
    | SendMessage String
