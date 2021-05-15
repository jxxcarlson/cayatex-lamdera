module Evergreen.V66.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V66.Authentication
import Evergreen.V66.Document
import Evergreen.V66.Parser.Element
import Evergreen.V66.User
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
    , users : List Evergreen.V66.User.User
    , currentUser : Maybe Evergreen.V66.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , popupStatus : PopupStatus
    , showEditor : Bool
    , currentDocument : Evergreen.V66.Document.Document
    , documents : List Evergreen.V66.Document.Document
    , inputSearchKey : String
    , printingState : PrintingState
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V66.Authentication.AuthenticationDict
    , documents : List Evergreen.V66.Document.Document
    }


type SearchTerm
    = Query String


type alias CaYaTeXMsg =
    Evergreen.V66.Parser.Element.CYTMsg


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
    | SaveDocument Evergreen.V66.Document.Document
    | GetUserDocuments String
    | GetDocumentsWithQuery (Maybe Evergreen.V66.User.User) SearchTerm
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V66.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | GotUsers (List Evergreen.V66.User.User)
    | SendUser Evergreen.V66.User.User
    | SendDocument Evergreen.V66.Document.Document
    | SendDocuments (List Evergreen.V66.Document.Document)
    | SendMessage String
