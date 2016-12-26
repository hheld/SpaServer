module Home.View exposing (..)

import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Messages exposing (Msg(..))
import Login.View exposing (loginPage)


homePage : Model -> Html Msg
homePage model =
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
                , text "This is the home page"
                ]
            , div
                [ class "pull-right col-md-4" ]
                [ Html.map Messages.MsgForLogin (loginPage model.currentUser model.csrfToken)
                ]
            ]
        ]
