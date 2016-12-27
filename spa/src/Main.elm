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
import AllUsersTable.Messages as AUM
import Rest.User as Api
import Js exposing (newCookieValue)


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

        initialFetchCmdForRoute =
            case currentRoute of
                Just (Routing.AllUsersRoute) ->
                    Api.getAllUsers currentModel
                        |> Http.send AUM.OnGetAllUsers
                        |> Cmd.map MsgForAllUsersTable

                _ ->
                    Cmd.none

        getCurrentUser : Cmd UM.Msg
        getCurrentUser =
            if flags.csrfToken /= "" then
                Http.send UM.OnGetUser <| Api.getCurrentUser currentModel
            else
                Cmd.none
    in
        currentModel ! [ Cmd.map MsgForUser getCurrentUser, initialFetchCmdForRoute ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    newCookieValue OnCookieValue



-- Main


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
