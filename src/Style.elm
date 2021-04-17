module Style exposing (..)

import Element exposing (..)
import Element.Font as Font


monospace : Attribute msg
monospace =
    Font.family
        [ Font.typeface "Roboto Mono"
        , Font.typeface "Space Mono"
        , Font.monospace
        ]


pagePadding =
    [ padding 32
    , spacing 32
    ]
