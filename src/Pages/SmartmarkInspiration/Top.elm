module Pages.SmartmarkInspiration.Top exposing (Model, Msg, Params, page)

import Array
import Browser.Dom
import Colors
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FeatherIcons
import Html
import Html.Attributes
import Icons
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import Style
import Style.Masonry
import Task
import Url


type alias Params =
    ()


type alias Model =
    { url : Url Params
    , data : List ( Item, Float )
    }


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , view = view
        , load =
            \_ model ->
                ( model
                , model.data
                    |> List.indexedMap
                        (\i x ->
                            getSizeOfItem i
                        )
                    |> Cmd.batch
                )
        , save = \_ shared -> shared
        , subscriptions = \_ -> Sub.none
        }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init _ url =
    let
        data =
            buildData
    in
    ( { url = url
      , data = data
      }
    , data
        |> List.indexedMap
            (\i x ->
                getSizeOfItem i
            )
        |> Cmd.batch
    )


getSizeOfItem : Int -> Cmd Msg
getSizeOfItem itemIndex =
    Browser.Dom.getViewportOf ("item-" ++ String.fromInt itemIndex)
        |> Task.onError
            (\_ ->
                Task.succeed
                    { scene =
                        { width = -1
                        , height = -1
                        }
                    , viewport =
                        { x = -1
                        , y = -1
                        , width = -1
                        , height = -1
                        }
                    }
            )
        |> Task.perform (\info -> SetHeightOfIndex itemIndex info.scene.height)


type Item
    = Note String
    | Quote String
    | Link String ImageURL
    | Image ImageURL
    | TodoList
        { title : String
        , tasks : List { text : String, done : Bool }
        }


type ImageURL
    = ImageURL String


buildData : List ( Item, Float )
buildData =
    [ Link "https://unsplash.com/photos/PB4VfA6mLek" (ImageURL "https://images.unsplash.com/photo-1617205058411-52d937f27b75?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80")
    , Link "https://dribbble.com/shots/14866937-A-Modern-Jukebox-Stone-Ceramic" (ImageURL "https://cdn.dribbble.com/users/449429/screenshots/14866937/media/f48dfa50d6fa14c737fa84e114847e4b.jpg?compress=1&resize=400x300")
    , Image (ImageURL "https://images.unsplash.com/photo-1617205058411-52d937f27b75?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80")
    , Note "Ask Mira for the task related to the project. Clarify the list of edits for next week."
    , TodoList
        { title = "Should be done today"
        , tasks =
            [ { text = "Complete main workflow wireframes", done = True }
            , { text = "Design profile dashboard", done = False }
            , { text = "Upload source files to Dropbox", done = False }
            ]
        }
    , Quote "Don't joke."
    , Link "https://dribbble.com/shots/14866937-A-Modern-Jukebox-Stone-Ceramic" (ImageURL "https://cdn.dribbble.com/users/449429/screenshots/14866937/media/f48dfa50d6fa14c737fa84e114847e4b.jpg?compress=1&resize=400x300")
    ]
        |> List.map (\x -> Tuple.pair x -1)



-- UPDATE


type Msg
    = NoOp
    | SetHeightOfIndex Int Float


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SetHeightOfIndex item height ->
            let
                array =
                    model.data
                        |> Array.fromList
            in
            ( { model
                | data =
                    array
                        |> Array.get item
                        |> Maybe.map (Tuple.mapSecond (\_ -> height))
                        |> Maybe.map
                            (\value ->
                                Array.set item value array
                                    |> Array.toList
                            )
                        |> Maybe.withDefault model.data
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Homepage"
    , body =
        [ column
            (width fill
                :: Style.pagePadding
            )
            [ row [ width fill ]
                [ el
                    [ Style.monospace
                    , Font.size 24
                    , Font.medium
                    ]
                    (text "Smartmark")
                , row [ alignRight ]
                    [ Icons.iconElement FeatherIcons.search
                    , el [ width (px 16) ] none
                    , Icons.iconElement FeatherIcons.menu
                    ]
                ]

            -- , wrappedRow [ width fill, spacing 12 ]
            --     (List.indexedMap (\i d -> viewItem -i d) model.data)
            , viewColumn model.data
            ]
        ]
    }


viewItem index ( item, itemHeight ) =
    el
        [ width fill
        , htmlAttribute (Html.Attributes.id ("item-" ++ String.fromInt index))
        , borderRadius
        , clip
        , inFront
            (el
                [ width fill
                , borderRadius
                , height fill
                , borderColor
                , Border.width 1
                ]
                none
            )
        ]
    <|
        case item of
            Note noteString ->
                el
                    [ alignTop
                    , width fill
                    , padding 12
                    , Font.size 16
                    , Background.color (Colors.withAlpha 0.9 Colors.white)
                    ]
                    (paragraph [ Font.size 14 ] [ text noteString ])

            Quote quoteString ->
                el
                    [ alignTop
                    , width fill
                    , padding 12
                    , Font.size 16
                    , Background.color (Colors.withAlpha 0.9 Colors.white)
                    ]
                    (column
                        [ spacing -16, width fill ]
                        [ el [ Font.size 44, Font.bold, alpha 0.3, centerX, centerY ]
                            (text "\"")
                        , paragraph [ width fill, Font.size 14, Font.center ]
                            [ text
                                quoteString
                            ]
                        ]
                    )

            Link url (ImageURL imageUrl) ->
                let
                    baseUrl =
                        Url.fromString imageUrl
                            |> Maybe.map .host
                            |> Maybe.withDefault
                                (imageUrl
                                    |> String.replace "https://" ""
                                    |> String.replace "http://" ""
                                    |> String.split "/"
                                    |> List.head
                                    |> Maybe.withDefault "link"
                                )
                in
                image
                    [ alignTop
                    , Background.color Colors.backgroundBottom
                    , inFront
                        (el
                            [ alignBottom
                            , borderRadius
                            , Font.size 12
                            , Background.color (Colors.withAlpha 0.9 Colors.white)
                            , padding 6
                            , moveRight 6
                            , moveUp 6
                            ]
                            (text baseUrl)
                        )
                    , width fill
                    , height
                        (shrink
                            |> minimum 100
                            |> maximum 400
                        )
                    ]
                    { src = imageUrl
                    , description = "Internet image for url"
                    }

            Image (ImageURL imageUrl) ->
                image
                    [ Background.color Colors.backgroundTop
                    , alignTop
                    , inFront
                        (el
                            [ padding 6
                            , moveRight 6
                            , moveUp 6
                            , alignBottom
                            , Background.color (Colors.withAlpha 0.9 Colors.white)
                            , Border.rounded 20
                            ]
                            (Icons.customIconElement
                                { icon = FeatherIcons.camera
                                , color = Colors.black
                                , size = 16
                                , stroke = 1
                                }
                            )
                        )
                    , width fill
                    , height
                        (shrink
                            |> minimum 100
                            |> maximum 400
                        )
                    ]
                    { src = imageUrl
                    , description = "Internet image for url"
                    }

            TodoList todos ->
                column
                    [ paddingXY 16 12
                    , Background.color (Colors.withAlpha 0.9 Colors.white)
                    , spacing 16
                    , Style.monospace
                    , width fill
                    ]
                    [ row [ width fill ]
                        [ el [ Font.size 15, Font.bold, width fill ] (text todos.title)
                        , el [ alignRight ] (Icons.iconElement FeatherIcons.moreHorizontal)
                        ]
                    , column [ width fill, spacing 12 ]
                        (List.map renderTodo todos.tasks)
                    ]


renderTodo : { done : Bool, text : String } -> Element Msg
renderTodo task =
    row [ width fill, spacing 8 ]
        [ if task.done then
            el
                [ Background.color
                    (Colors.withAlpha 0.7 Colors.black)
                , padding 2
                , Border.rounded 4
                ]
                (Icons.customIconElement
                    { icon =
                        FeatherIcons.check
                    , size = 12
                    , stroke = 3
                    , color = Colors.white
                    }
                )

          else
            el
                [ Background.color
                    (Colors.withAlpha 0.2 Colors.black)
                , padding 2
                , Border.rounded 4
                ]
                (el [ width (px 14), height (px 14) ] none)
        , el
            ([ Font.size 13
             , centerY
             ]
                ++ (if task.done then
                        [ Font.strike
                        , Font.color (Colors.withAlpha 0.4 Colors.black)
                        ]

                    else
                        []
                   )
            )
            (text task.text)
        ]



-- { title : String
-- , tasks : List { text : String, done : Bool }
-- }


borderRadius =
    Border.rounded 7


borderColor =
    Border.color (Colors.withAlpha 0.2 Colors.black)


viewColumn data =
    let
        renderItem pos item hei =
            el [ width fill, height (px hei) ]
                (viewItem pos item)

        viewMasonry args =
            let
                heights =
                    args.items
                        |> List.map
                            (\( item, itemHeight ) ->
                                if itemHeight > 0 then
                                    truncate itemHeight

                                else
                                    case item of
                                        Link _ _ ->
                                            300

                                        Quote _ ->
                                            100

                                        Note _ ->
                                            100

                                        Image _ ->
                                            300

                                        TodoList _ ->
                                            300
                            )

                dataArray =
                    args.items
                        |> Array.fromList
            in
            row [ width fill, spacing args.spacing, padding args.padding ] <|
                List.map
                    (\masonryColumn ->
                        column [ width fill, alignTop, spacing args.spacing ] <|
                            List.map
                                (\( position, height_ ) ->
                                    Array.get position dataArray
                                        |> Maybe.map
                                            (\d ->
                                                args.viewItem position d height_
                                            )
                                        |> Maybe.withDefault none
                                )
                                (List.reverse masonryColumn)
                    )
                    (List.reverse <| Style.Masonry.fromItems heights args.columns)
    in
    data
        |> List.foldr
            (\item acc ->
                case item of
                    ( TodoList _, h ) ->
                        FullWidth item :: acc

                    _ ->
                        case acc of
                            (Mosaic list) :: tail ->
                                Mosaic (item :: list) :: tail

                            _ ->
                                Mosaic [ item ] :: acc
            )
            []
        |> List.map
            (\x ->
                case x of
                    Mosaic items ->
                        viewMasonry
                            { items = items
                            , columns = 2
                            , spacing = 16
                            , padding = 0
                            , viewItem = renderItem
                            }

                    FullWidth item ->
                        viewItem -1 item
            )
        |> column [ spacing 16 ]


type Mosaic item
    = Mosaic (List item)
    | FullWidth item
