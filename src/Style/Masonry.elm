module Style.Masonry exposing (fromItems)

import Array
import Element exposing (..)


type alias Position =
    Int


type alias Height =
    Int


type alias Masonry =
    List (List ( Position, Height ))


columnHeight : List ( Position, Height ) -> Height
columnHeight column =
    List.foldl (\( _, height ) total -> height + total) 0 column


columnsHeights : Masonry -> List Height
columnsHeights masonry =
    List.map columnHeight masonry


positionOfShortestHeight : List Height -> Position
positionOfShortestHeight listOfHeights =
    let
        helper itemPosition itemHeight accPosition =
            if itemHeight == (Maybe.withDefault 0 <| List.minimum listOfHeights) then
                itemPosition

            else
                accPosition
    in
    indexedFoldl helper 0 listOfHeights


indexedFoldl func acc_ list =
    list
        |> List.foldl
            (\elem ( counter, acc ) ->
                ( counter + 1, func counter elem acc )
            )
            ( 0, acc_ )
        |> Tuple.second


minimumHeightPosition : Masonry -> Position
minimumHeightPosition masonry =
    masonry |> columnsHeights |> positionOfShortestHeight


addItemToMasonry : Position -> Height -> Masonry -> Masonry
addItemToMasonry position height masonry =
    let
        minPosition =
            minimumHeightPosition masonry

        column =
            Maybe.withDefault [] <| Array.get minPosition (Array.fromList masonry)

        newColumn_ =
            ( position, height ) :: column
    in
    Array.toList <| Array.set minPosition newColumn_ (Array.fromList masonry)


fromItems : List Height -> Int -> Masonry
fromItems items columns =
    indexedFoldl addItemToMasonry (List.repeat columns []) items
