module Types exposing (..)

import Authentication exposing (AuthenticationDict)
import Browser exposing (UrlRequest)
import Browser.Dom as Dom
import Browser.Navigation exposing (Key)
import Data
import Document exposing (Document)
import Http
import Parser.Element
import Random
import Url exposing (Url)
import User exposing (User)


type alias FrontendModel =
    { key : Key
    , url : Url
    , message : String

    -- ADMIN
    , users : List User

    -- USER
    , currentUser : Maybe User
    , inputUsername : String
    , inputPassword : String

    -- UI
    , windowWidth : Int
    , windowHeight : Int
    , popupStatus : PopupStatus
    , showEditor : Bool

    -- DOCUMENT
    , currentDocument : Document
    , documents : List Document
    , inputSearchKey : String
    , printingState : PrintingState
    , counter : Int
    }


type PopupWindow
    = AdminPopup


type PopupStatus
    = PopupOpen PopupWindow
    | PopupClosed


type alias BackendModel =
    { message : String

    -- RANDOM
    , randomSeed : Random.Seed
    , uuidCount : Int
    , randomAtmosphericInt : Maybe Int

    -- USER
    , authenticationDict : AuthenticationDict

    -- DOCUMENT
    , documents : List Document
    }


type alias CaYaTeXMsg =
    Parser.Element.CYTMsg


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
      -- UI
    | GotNewWindowDimensions Int Int
    | GotViewport Dom.Viewport
    | SetViewPortForElement (Result Dom.Error ( Dom.Element, Dom.Viewport ))
    | ChangePopupStatus PopupStatus
    | ToggleEditor
      -- USER
    | SignIn
    | SignOut
    | InputUsername String
    | InputPassword String
      -- ADMIN
    | Test
    | GetUsers
      -- DOC
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


type PrintingState
    = PrintWaiting
    | PrintProcessing
    | PrintReady


type SearchTerm
    = Query String


type ToBackend
    = NoOpToBackend
      -- ADMIN
    | RunTest
    | SendUsers
      -- USER
    | SignInOrSignUp String String
      -- DOCUMENT
    | SaveDocument Document
    | GetUserDocuments String
    | GetDocumentsWithQuery (Maybe User) SearchTerm
    | GetDocumentById String
    | RegisterNewDocument Document


type BackendMsg
    = NoOpBackendMsg
    | GotAtomsphericRandomNumber (Result Http.Error String)


type ToFrontend
    = NoOpToFrontend
      -- ADMIN
    | GotUsers (List User)
      -- USER
    | SendUser User
      -- DOCUMENT
    | SendDocument Document
    | SendDocuments (List Document)
    | SendMessage String
