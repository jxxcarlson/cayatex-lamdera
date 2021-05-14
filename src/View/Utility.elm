module View.Utility exposing
    ( cssNode
    , getElementWithViewPort
    , htmlAttribute
    , katexCSS
    , noFocus
    , setViewPortForSelectedLine
    , setViewportForElement
    , showIf
    , showIfIsAdmin
    )

import Browser.Dom as Dom
import Element exposing (Element)
import Html
import Html.Attributes as HA
import Task exposing (Task)
import Types exposing (FrontendModel, FrontendMsg)


showIfIsAdmin : FrontendModel -> Element msg -> Element msg
showIfIsAdmin model element =
    showIf (Maybe.map .username model.currentUser == Just "jxxcarlson") element


showIf : Bool -> Element msg -> Element msg
showIf isVisible element =
    if isVisible then
        element

    else
        Element.none


setViewportForElement : String -> Cmd FrontendMsg
setViewportForElement id =
    Dom.getViewportOf "__RENDERED_TEXT__"
        |> Task.andThen (\vp -> getElementWithViewPort vp id)
        |> Task.attempt Types.SetViewPortForElement


setViewPortForSelectedLine : Dom.Element -> Dom.Viewport -> Cmd FrontendMsg
setViewPortForSelectedLine element viewport =
    let
        y =
            viewport.viewport.y + element.element.y - element.element.height - 100
    in
    Task.attempt (\_ -> Types.NoOpFrontendMsg) (Dom.setViewportOf "__RENDERED_TEXT__" 0 y)


getElementWithViewPort : Dom.Viewport -> String -> Task Dom.Error ( Dom.Element, Dom.Viewport )
getElementWithViewPort vp id =
    Dom.getElement id
        |> Task.map (\el -> ( el, vp ))


noFocus : Element.FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


cssNode : String -> Element FrontendMsg
cssNode fileName =
    Html.node "link" [ HA.rel "stylesheet", HA.href fileName ] [] |> Element.html



-- Include KaTeX CSS


katexCSS : Element FrontendMsg
katexCSS =
    Element.html <|
        Html.node "link"
            [ HA.attribute "rel" "stylesheet"
            , HA.attribute "href" "https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.css"
            ]
            []


htmlAttribute : String -> String -> Element.Attribute msg
htmlAttribute key value =
    Element.htmlAttribute (HA.attribute key value)
