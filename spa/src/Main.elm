module Main exposing (..)

import Navigation
import UrlParser as Url
import Messages exposing (Msg(..))
import Update exposing (update)
import Model exposing (Model, initialModel)
import Routing
import View exposing (view)
import Http
import User.Messages as UM
import Rest.User as Api


type alias Flags =
    { csrfToken : String
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Url.parseHash Routing.route location

        currentModel =
            initialModel currentRoute flags.csrfToken

        getCurrentUser : Cmd UM.Msg
        getCurrentUser =
            if flags.csrfToken /= "" then
                Http.send UM.OnGetUser <| Api.getCurrentUser currentModel
            else
                Cmd.none
    in
        currentModel ! [ Cmd.map MsgForUser getCurrentUser ]



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
