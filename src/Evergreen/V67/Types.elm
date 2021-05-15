module Evergreen.V67.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V67.Authentication
import Evergreen.V67.Document
import Evergreen.V67.Parser.Element
import Evergreen.V67.User
import Http
import Random
import Url


type PopupWindow
    = AdminPopup


type PopupStatus
    = PopupOpen PopupWindow
    | PopupClosed


type PrintingState
    = PrintWaiting
    | PrintProcessing
    | PrintReady


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , message : String
    , users : List Evergreen.V67.User.User
    , currentUser : Maybe Evergreen.V67.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , popupStatus : PopupStatus
    , showEditor : Bool
    , currentDocument : Evergreen.V67.Document.Document
    , documents : List Evergreen.V67.Document.Document
    , inputSearchKey : String
    , printingState : PrintingState
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V67.Authentication.AuthenticationDict
    , documents : List Evergreen.V67.Document.Document
    }


type SearchTerm
    = Query String


type alias CaYaTeXMsg =
    Evergreen.V67.Parser.Element.CYTMsg


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
    | FetchDocuments SearchTerm
    | ExportToLaTeX
    | PrintToPDF
    | GotPdfLink (Result Http.Error String)
    | ChangePrintingState PrintingState
    | FinallyDoCleanPrintArtefacts String
    | ToggleAccess
    | Help String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTest
    | SendUsers
    | SignInOrSignUp String String
    | SaveDocument Evergreen.V67.Document.Document
    | GetUserDocuments String
    | GetDocumentsWithQuery (Maybe Evergreen.V67.User.User) SearchTerm
    | GetDocumentById String
    | GetDocumentByIdForGuest String
    | RegisterNewDocument Evergreen.V67.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | GotUsers (List Evergreen.V67.User.User)
    | SendUser Evergreen.V67.User.User
    | LoginGuest
    | SendDocument Evergreen.V67.Document.Document
    | SendDocuments (List Evergreen.V67.Document.Document)
    | SendMessage String
