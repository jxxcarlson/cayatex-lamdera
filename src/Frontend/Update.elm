module Frontend.Update exposing (updateWithViewport)


updateWithViewport vp model =
    let
        w =
            round vp.viewport.width

        h =
            round vp.viewport.height
    in
    ( { model
        | windowWidth = w
        , windowHeight = h
      }
    , Cmd.none
    )
