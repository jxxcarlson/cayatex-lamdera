module View.Main exposing (view)

import CaYaTeX
import Document exposing (Access(..), Document)
import Element as E exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Types exposing (..)
import View.Button as Button
import View.Color as Color
import View.Input
import View.Popup
import View.Style
import View.Utility


type alias Model =
    FrontendModel


view : Model -> Html FrontendMsg
view model =
    E.layoutWith { options = [ E.focusStyle View.Utility.noFocus ] }
        [ View.Style.bgGray 0.9, E.clipX, E.clipY ]
        (mainColumn model)


mainColumn : Model -> Element FrontendMsg
mainColumn model =
    E.column (mainColumnStyle model)
        [ E.column [ E.spacing 12, E.width (E.px <| appWidth_ model), E.height (E.px (appHeight_ model)) ]
            [ title "CaYaTeX"
            , header model
            , E.column [ E.spacing 12 ]
                [ E.row [ E.spacing 12 ]
                    [ docList model
                    , View.Utility.showIf model.showEditor <| viewEditor model
                    , viewRendered model
                    , View.Utility.showIf (not model.showEditor) <| viewDummy model
                    ]
                ]
            , footer model
            ]
        ]


footer model =
    E.row
        [ E.spacing 12
        , E.paddingXY 0 8
        , E.height (E.px 25)
        , E.width (E.px (2 * panelWidth_ model + 226))
        , Font.size 14
        , E.inFront (View.Popup.admin model)
        ]
        [ Button.exportToLaTeX, Button.printToPDF model, messageRow model ]


messageRow model =
    E.row
        [ E.width E.fill
        , E.height (E.px 30)
        , E.paddingXY 8 4
        , View.Style.bgGray 0.1
        , View.Style.fgGray 1.0
        ]
        [ E.text model.message, viewId model ]


footerButtons model =
    E.row [ E.width (E.px (panelWidth_ model)), E.spacing 12 ] [ Button.exportToLaTeX, Button.printToPDF model ]


viewId model =
    E.el [ E.alignRight, E.moveUp 3, Font.color (E.rgb 0.7 0.7 0.7) ]
        (E.text model.currentDocument.id)


header model =
    case model.currentUser of
        Nothing ->
            notSignedInHeader model

        Just user ->
            signedInHeader model user


notSignedInHeader model =
    E.row
        [ E.spacing 12
        , Font.size 14
        ]
        [ Button.signIn
        , View.Input.usernameInput model
        , View.Input.passwordInput model
        , E.el [ E.height (E.px 31), E.paddingXY 12 3, Background.color Color.paleBlue ]
            (E.el [ E.centerY ] (E.text model.message))
        , Button.toggleEditor model
        , Button.startupHelp
        ]


signedInHeader model user =
    E.row [ E.spacing 12 ]
        [ Button.signOut user.username
        , Button.fetchDocuments model.inputSearchKey
        , Button.newDocument
        , Button.toggleAccess model
        , Button.toggleEditor model
        , author model
        , wordCount model
        , Button.adminPopup model
        , Button.help
        ]


wordCount : Model -> Element FrontendMsg
wordCount model =
    E.el [ Font.size 14, Font.color Color.lightGray ] (E.text <| "words: " ++ (String.fromInt <| Document.wordCount model.currentDocument))


author : Model -> Element FrontendMsg
author model =
    E.el [ Font.size 14, Font.color Color.lightGray ] (E.text <| "Author: " ++ model.currentDocument.username)


searchDocPaneHeight =
    40


docList : Model -> Element FrontendMsg
docList model =
    E.column [ E.alignTop, E.moveUp 3 ]
        [ searchDocsPanel model
        , docList_ model
        ]


searchDocsPanel model =
    E.row
        [ E.height (E.px searchDocPaneHeight)
        , E.width (E.px docListWidth)
        ]
        [ View.Input.searchDocsInput model ]


docList_ : Model -> Element FrontendMsg
docList_ model =
    E.column
        [ View.Style.bgGray 0.85
        , E.height (E.px (panelHeight_ model - searchDocPaneHeight))
        , E.spacing 4
        , E.width (E.px docListWidth)
        , E.paddingXY 8 12
        , Background.color Color.paleViolet
        , E.scrollbarY
        ]
        (List.map (docItemView model.currentDocument)
            (List.sortBy (\doc -> doc.title) (Document.search model.currentUser model.inputSearchKey model.documents))
        )


decoratedTitle : Document -> String
decoratedTitle doc =
    if doc.access == Private then
        doc.title

    else
        -- Unicode: '\u{xxxx}'
        doc.title ++ " " ++ String.fromChar '○'


docItemView : Document -> Document -> Element FrontendMsg
docItemView currentDocument document =
    let
        title_ =
            if document.title == "" then
                "Untitled"

            else
                document.title

        fontColor =
            if currentDocument.id == document.id then
                Color.darkRed

            else
                Color.blue

        style =
            if document.access == Private then
                Font.regular

            else
                -- Unicode: '\u{xxxx}'
                Font.italic
    in
    E.el [ style ] (Button.linkTemplate (AskFoDocumentById document.id) fontColor title_)


viewEditor : Model -> Element FrontendMsg
viewEditor model =
    E.column
        [ E.alignTop
        , E.spacing 8
        ]
        [ viewEditor_ model
        ]


viewEditor_ : Model -> Element FrontendMsg
viewEditor_ model =
    Input.multiline
        [ E.height (E.px (panelHeight_ model))
        , E.width (E.px (panelWidth_ model))
        , Font.size 14
        ]
        { onChange = InputText
        , text = model.currentDocument.content
        , placeholder = Nothing
        , label = Input.labelHidden "Enter source text here"
        , spellcheck = False
        }


viewRendered : Model -> Element FrontendMsg
viewRendered model =
    E.column
        [ E.paddingEach { left = 24, right = 24, top = 12, bottom = 96 }
        , View.Style.bgGray 0.9
        , E.width (E.px (panelWidth_ model))
        , E.height (E.px (panelHeight_ model))
        , E.centerX
        , Font.size 14
        , E.alignTop
        , E.scrollbarY
        , View.Utility.elementAttribute "id" "__RENDERED_TEXT__"
        ]
        [ View.Utility.katexCSS
        , CaYaTeX.renderString model.counter model.currentDocument.content |> E.map CYT
        ]


viewDummy : Model -> Element FrontendMsg
viewDummy model =
    E.column
        [ E.paddingEach { left = 24, right = 24, top = 12, bottom = 96 }
        , Background.color Color.veryPaleBlue
        , E.width (E.px (panelWidth_ model))
        , E.height (E.px (panelHeight_ model))
        , E.centerX
        , Font.size 14
        , E.alignTop
        ]
        []



-- DIMENSIONS


panelWidth_ model =
    min 600 ((model.windowWidth - 100 - docListWidth) // 2)


docListWidth =
    200


appHeight_ model =
    model.windowHeight - 100


panelHeight_ model =
    appHeight_ model - 110


appWidth_ model =
    2 * panelWidth_ model + docListWidth + 15


mainColumnStyle model =
    [ E.centerX
    , E.centerY
    , View.Style.bgGray 0.5
    , E.paddingXY 20 20
    , E.width (E.px (appWidth_ model + 40))
    , E.height (E.px (appHeight_ model + 40))
    ]


title : String -> Element msg
title str =
    E.row [ E.centerX, View.Style.fgGray 0.9 ] [ E.text str ]
