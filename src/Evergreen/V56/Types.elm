module Evergreen.V56.Types exposing (..)

import Browser
import Browser.Dom
import Browser.Navigation
import Evergreen.V56.Authentication
import Evergreen.V56.Document
import Evergreen.V56.Parser.Element
import Evergreen.V56.User
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
    , message : String
    , users : List Evergreen.V56.User.User
    , currentUser : Maybe Evergreen.V56.User.User
    , inputUsername : String
    , inputPassword : String
    , windowWidth : Int
    , windowHeight : Int
    , popupStatus : PopupStatus
    , showEditor : Bool
    , currentDocument : Evergreen.V56.Document.Document
    , documents : List Evergreen.V56.Document.Document
    , inputSearchKey : String
    , printingState : PrintingState
    , counter : Int
    }


type alias BackendModel =
    { message : String
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int
    , authenticationDict : Evergreen.V56.Authentication.AuthenticationDict
    , documents : List Evergreen.V56.Document.Document
    }


type SearchTerm
    = Query String


type alias CaYaTeXMsg =
    Evergreen.V56.Parser.Element.CYTMsg


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
    | SaveDocument Evergreen.V56.Document.Document
    | GetUserDocuments String
    | GetDocumentsWithQuery (Maybe Evergreen.V56.User.User) SearchTerm
    | GetDocumentById String
    | RegisterNewDocument Evergreen.V56.Document.Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
    | GotUsers (List Evergreen.V56.User.User)
    | SendUser Evergreen.V56.User.User
    | SendDocument Evergreen.V56.Document.Document
    | SendDocuments (List Evergreen.V56.Document.Document)
    | SendMessage String
