module Evergreen.V37.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V37.Authentication
import Evergreen.V37.Document
import Evergreen.V37.Parser.Element
import Evergreen.V37.User
import Http
import Random
import Url


type PopupWindow
    = AdminPopup


type PopupStatus
    = PopupOpen PopupWindow
    | PopupClosed


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , message : String
    , users : List Evergreen.V37.User.User
    , currentUser : Maybe Evergreen.V37.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , popupStatus : PopupStatus
    , showEditor : Bool
    , currentDocument : Evergreen.V37.Document.Document
    , documents : List Evergreen.V37.Document.Document
    , inputSearchKey : String
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V37.Authentication.AuthenticationDict
    , documents : List Evergreen.V37.Document.Document
    }


type alias CaYaTeXMsg =
    Evergreen.V37.Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | GotNewWindowDimensions Int Int
    | GotViewport Browser.Dom.Viewport
    | SetViewPortForElement (Result Browser.Dom.Error ( Browser.Dom.Element, Browser.Dom.Viewport ))
    | ChangePopupStatus PopupStatus
    | ToggleEditor
    | SignIn
    | SignOut
    | InputUsername String
    | InputPassword String
    | Test
    | GetUsers
    | InputText String
    | InputSearchKey String
    | NewDocument
    | AskFoDocumentById String
    | ToggleAccess
    | Help
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SendUsers
    | SignInOrSignUp String String
    | SaveDocument Evergreen.V37.Document.Document
    | GetUserDocuments String
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V37.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | GotUsers (List Evergreen.V37.User.User)
    | SendUser Evergreen.V37.User.User
    | SendDocument Evergreen.V37.Document.Document
    | SendDocuments (List Evergreen.V37.Document.Document)
    | SendMessage String
