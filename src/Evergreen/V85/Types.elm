module Evergreen.V85.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V85.Authentication
import Evergreen.V85.Document
import Evergreen.V85.Parser.Element
import Evergreen.V85.User
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


type DocumentDeleteState
    = WaitingForDeleteAction
    | DocumentDeletePending


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , message : String
    , users : List Evergreen.V85.User.User
    , currentUser : Maybe Evergreen.V85.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , popupStatus : PopupStatus
    , showEditor : Bool
    , currentDocument : Evergreen.V85.Document.Document
    , documents : List Evergreen.V85.Document.Document
    , inputSearchKey : String
    , printingState : PrintingState
    , documentDeleteState : DocumentDeleteState
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V85.Authentication.AuthenticationDict
    , documents : List Evergreen.V85.Document.Document
    }


type SearchTerm
    = Query String


type alias CaYaTeXMsg =
    Evergreen.V85.Parser.Element.CYTMsg


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
    | AdminRunTask
    | GetUsers
    | InputText String
    | InputSearchKey String
    | NewDocument
    | ChangeDocumentDeleteStateFrom DocumentDeleteState
    | AskFoDocumentById String
    | FetchDocuments SearchTerm
    | ExportToLaTeX
    | Export
    | PrintToPDF
    | GotPdfLink (Result Http.Error String)
    | ChangePrintingState PrintingState
    | FinallyDoCleanPrintArtefacts String
    | ToggleAccess
    | Help String
    | CYT CaYaTeXMsg


type ToBackend
    = NoOpToBackend
    | RunTask
    | SendUsers
    | SignInOrSignUp String String
    | SaveDocument Evergreen.V85.Document.Document
    | DeleteDocumentById String
    | GetUserDocuments String
    | GetDocumentsWithQuery (Maybe Evergreen.V85.User.User) SearchTerm
    | GetDocumentById String
    | GetDocumentByIdForGuest String
    | RegisterNewDocument Evergreen.V85.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | GotUsers (List Evergreen.V85.User.User)
    | SendUser Evergreen.V85.User.User
    | LoginGuest
    | SendDocument Evergreen.V85.Document.Document
    | SendDocuments (List Evergreen.V85.Document.Document)
    | SendMessage String
