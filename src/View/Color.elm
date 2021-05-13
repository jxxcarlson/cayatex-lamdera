module View.Color exposing
    ( black
    , blue
    , darkRed
    , lightGray
    , paleBlue
    , paleViolet
    , transparentBlue
    , white
    )

import Element as E


white : E.Color
white =
    E.rgb 255 255 255


lightGray : E.Color
lightGray =
    gray 0.9


black : E.Color
black =
    E.rgb 20 20 20


darkRed : E.Color
darkRed =
    E.rgb255 140 0 0


blue : E.Color
blue =
    E.rgb255 0 0 200


paleBlue : E.Color
paleBlue =
    E.rgb255 180 180 255


transparentBlue : E.Color
transparentBlue =
    E.rgba 0.5 0.5 1 0.9


paleViolet : E.Color
paleViolet =
    E.rgb255 230 230 255


gray : Float -> E.Color
gray g =
    E.rgb g g g
