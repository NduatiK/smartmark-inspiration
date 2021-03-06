module Pages.NotFound exposing (Model, Msg, Params, page)

import Element exposing (..)
import Spa.Document exposing (Document)
import Spa.Generated.Route exposing (Route)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    ()


type alias Model =
    Url Params


type alias Msg =
    Never


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }



-- VIEW


view : Url Params -> Document Msg
view { params } =
    { title = "404"
    , body =
        [ link []
            { url = Spa.Generated.Route.toString Spa.Generated.Route.SmartmarkInspiration__Top
            , label = text "Home"
            }
        ]
    }
