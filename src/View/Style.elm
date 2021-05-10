module View.Style exposing (fgGray,
   bgGray)

import Element exposing(Element)

import Element.Font as Font
import Element.Background as Background

fgGray g =
    Font.color (Element.rgb g g g)


bgGray g =
    Background.color (Element.rgb g g g)