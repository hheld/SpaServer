module Home.View exposing (..)

import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Messages exposing (Msg(..))


homePage : Model -> Html Msg
homePage model =
    div []
        [ text "This is the home page"
        , text ("User: " ++ (toString model.currentUser) ++ "; CSRF token: " ++ model.csrfToken)
        ]
