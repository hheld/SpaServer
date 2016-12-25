module Main exposing (..)

import Navigation
import UrlParser as Url
import Messages exposing (Msg(..))
import Update exposing (update)
import Model exposing (Model, initialModel)
import Routing
import View exposing (view)


type alias Flags =
    { csrfToken : String
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Url.parseHash Routing.route location

        currentModel =
            initialModel currentRoute

        dbg =
            Debug.log "init" flags
    in
        currentModel ! []



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Main


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
