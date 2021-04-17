module Style exposing (..)

import Element exposing (..)
import Element.Font as Font


monospace : Attribute msg
monospace =
    Font.family
        [ Font.typeface "Space Mono"
        , Font.external { name = "Space Mono", url = "https://fonts.googleapis.com/css2?family=Space+Mono:ital,wght@0,400;1,700&display=swap" }
        , Font.monospace
        ]


pagePadding =
    [ padding 32
    , spacing 32
    ]
