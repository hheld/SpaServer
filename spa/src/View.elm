module View exposing (..)

import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (class)
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
    let
        content =
            case model.route of
                Just HomeRoute ->
                    homePage model

                Just LoginRoute ->
                    Html.map Messages.MsgForLogin (loginPage model.currentUser model.csrfToken)

                Nothing ->
                    notFoundPage model
    in
        outerLayout model content


outerLayout : Model -> Html Msg -> Html Msg
outerLayout model content =
    div [ class "container" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col-md-8" ]
                [ div
                    [ class "page-header" ]
                    [ h1 []
                        [ text "Page header" ]
                    ]
                , content
                ]
            , div
                [ class "pull-right col-md-4" ]
                [ Html.map Messages.MsgForLogin (loginPage model.currentUser model.csrfToken)
                ]
            ]
        ]
