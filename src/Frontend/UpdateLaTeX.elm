module Frontend.UpdateLaTeX exposing (..)

import Codec
import Config
import Document exposing (Document)
import Http
import Parser.Function
import Parser.RunLoopFunctions
import Process
import Render.LaTeX
import Task
import Types exposing (FrontendModel, FrontendMsg(..), PrintingState(..))


type alias Model =
    FrontendModel


printToPDF model =
    ( { model | message = "printToPDF" }
    , Cmd.batch
        [ generatePdf model.currentDocument
        , Process.sleep 1 |> Task.perform (always (ChangePrintingState PrintProcessing))
        ]
    )


generatePdf : Document -> Cmd FrontendMsg
generatePdf document =
    let
        contentForExport =
            document.content
                |> Render.LaTeX.renderAsDocument

        imageUrls =
            document.content
                |> Parser.RunLoopFunctions.rl
                |> Parser.Function.getElementTexts "image"
    in
    Http.request
        { method = "POST"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = Config.pdfServer ++ "/pdf"
        , body = Http.jsonBody (Codec.encodeForPDF document.id "-" contentForExport imageUrls)
        , expect = Http.expectString GotPdfLink
        , timeout = Nothing
        , tracker = Nothing
        }


gotPdfLink : FrontendModel -> Result error value -> ( FrontendModel, Cmd FrontendMsg )
gotPdfLink model result =
    case result of
        Err _ ->
            ( model, Cmd.none )

        Ok docId ->
            ( model
            , Cmd.batch
                [ Process.sleep 5 |> Task.perform (always (ChangePrintingState PrintReady))
                ]
            )
