module Main exposing (..)

import Navigation
import UrlParser as Url
import Messages exposing (Msg(..))
import Update exposing (update)
import Model exposing (Model, initialModel)
import Routing
import View exposing (view)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Url.parseHash Routing.route location

        currentModel =
            initialModel currentRoute
    in
        currentModel ! []



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Main


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
