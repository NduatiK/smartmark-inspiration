module Colors exposing (..)

import Element exposing (..)
import Element.Background exposing (gradient)


backgroundTop =
    rgb255 170 244 248


backgroundBottom =
    rgb255 202 173 255


backgroundGradient =
    gradient
        { angle = pi
        , steps =
            [ backgroundTop
            , backgroundBottom
            ]
        }


withAlpha : Float -> Color -> Color
withAlpha alpha color =
    let
        rgbColor =
            toRgb color
    in
    rgba rgbColor.red rgbColor.green rgbColor.blue alpha


white : Color
white =
    Element.rgb 1 1 1


black : Color
black =
    Element.rgb 0 0 0


colorToRGB color =
    let
        rgbColor =
            toRgb color
    in
    "rgba("
        ++ String.fromFloat (rgbColor.red * 255)
        ++ ","
        ++ String.fromFloat (rgbColor.green * 255)
        ++ ","
        ++ String.fromFloat (rgbColor.blue * 255)
        ++ ","
        ++ String.fromFloat rgbColor.alpha
        ++ ")"
