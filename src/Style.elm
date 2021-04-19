module Style exposing (..)

import Element exposing (..)
import Element.Font as Font
import Html.Attributes


monospace : Attribute msg
monospace =
    Font.family
        [ Font.typeface "Roboto Mono"
        , Font.typeface "Space Mono"
        , Font.monospace
        ]


sticky =
    htmlAttribute (Html.Attributes.class "sticky")


zIndex value =
    htmlAttribute (Html.Attributes.style "z-index" (String.fromInt (value + 10)))


backgroundBlur radius =
    [ htmlAttribute
        (Html.Attributes.style "-webkit-backdrop-filter" ([ "blur(", String.fromInt radius, "px)" ] |> String.join ""))
    , htmlAttribute
        (Html.Attributes.style "backdrop-filter" ([ "blur(", String.fromInt radius, "px)" ] |> String.join ""))
    ]


pagePadding =
    [ padding 24
    , spacing 32
    ]
