module View exposing (..)

import Html exposing (Html, div)
import Model exposing (Model)
import Messages exposing (Msg)
import Routing exposing (Route(..))
import Home.View exposing (homePage)
import Login.View exposing (loginPage)
import NotFoundPage.View exposing (notFoundPage)


view : Model -> Html Msg
view model =
    div [] [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Just HomeRoute ->
            homePage model

        Just LoginRoute ->
            Html.map Messages.MsgForLogin (loginPage model.currentUser model.csrfToken)

        Nothing ->
            notFoundPage model
