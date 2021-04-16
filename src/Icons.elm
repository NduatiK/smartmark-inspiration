module Icons exposing (..)

import Colors
import Element exposing (..)
import FeatherIcons
import Html.Attributes


iconElement icon =
    el [] <|
        html
            (icon
                |> FeatherIcons.toHtml []
            )


{-| Render a custom icon

    Icons.customIconElement
        { icon = FeatherIcons.camera
        , color = Colors.white
        , size = 16
        , stroke = 1
        }

-}
customIconElement { icon, color, size, stroke } =
    el [] <|
        html
            (icon
                |> FeatherIcons.withSize size
                |> FeatherIcons.withStrokeWidth stroke
                |> FeatherIcons.toHtml
                    [ Html.Attributes.style "color" (Colors.colorToRGB color)
                    ]
            )
