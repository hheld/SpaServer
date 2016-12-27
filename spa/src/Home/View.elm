module Home.View exposing (..)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Messages exposing (Msg(..))


homePage : Model -> Html Msg
homePage model =
    text "This is the home page"
