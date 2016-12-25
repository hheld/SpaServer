module View exposing (..)

import Html exposing (Html, div, text)
import Model exposing (Model)
import Messages exposing (Msg)
import Routing exposing (Route(..))
import Views.Login exposing (loginPage)
import Views.HomePage exposing (homePage)
import Views.NotFoundPage exposing (notFoundPage)


view : Model -> Html Msg
view model =
    div [] [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Just HomeRoute ->
            homePage model

        Just LoginRoute ->
            loginPage model.user

        Nothing ->
            notFoundPage model
