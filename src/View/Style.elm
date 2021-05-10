module View.Style exposing
    ( bgGray
    , buttonStyle
    , fgGray
    )

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font


fgGray g =
    Font.color (Element.rgb g g g)


bgGray g =
    Background.color (Element.rgb g g g)


buttonStyle =
    [ Font.color (Element.rgb255 255 255 255)
    , Element.paddingXY 15 8
    ]
