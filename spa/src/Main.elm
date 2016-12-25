module Main exposing (..)

import Navigation
import UrlParser as Url
import Messages exposing (Msg(..))
import Update exposing (update)
import Model exposing (Model, initialModel)
import Routing
import View exposing (view)
import Js exposing (newCookieValue, getCookieValue)
import Navigation.Messages exposing (NavigationMsg(..))


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Url.parseHash Routing.route location

        currentModel =
            initialModel currentRoute

        getCsrfTokenFromCookie : Cmd Msg
        getCsrfTokenFromCookie =
            getCookieValue "Csrf-token"
    in
        currentModel ! [ getCsrfTokenFromCookie ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map MsgForCookie (newCookieValue Messages.OnCookieValue)



-- Main


main : Program Never Model Msg
main =
    Navigation.program (\l -> MsgForNavigation <| UrlChange l)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
