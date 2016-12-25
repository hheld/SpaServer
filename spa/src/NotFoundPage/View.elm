module NotFoundPage.View exposing (..)

import Html exposing (Html, div, text)
import Model exposing (Model)
import Messages exposing (Msg)


notFoundPage : Model -> Html Msg
notFoundPage model =
    div [] [ text "Not found" ]
