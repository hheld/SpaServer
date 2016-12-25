module Update exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Model exposing (..)
import UrlParser as Url
import Routing exposing (route)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model
                | route = Url.parseHash route location
              }
            , Cmd.none
            )
