module Frontend.UpdateLaTeX exposing (..)

import Codec
import Config
import Document exposing (Document)
import File.Download
import Http
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
        contentToProcess =
            document.content

        contentForExport =
            contentToProcess
                |> Render.LaTeX.renderAsDocument
    in
    Http.request
        { method = "POST"
        , headers = [ Http.header "Content-Type" "application/json" ]
        , url = Config.pdfServer ++ "/pdf"
        , body = Http.jsonBody (Codec.encodeForPDF document.id "-" contentForExport [])
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
