module UnauthorizedPage.View exposing (..)

import Html exposing (Html, text)
import Model exposing (Model)


unauthorizedPage : Model -> Html msg
unauthorizedPage model =
    text "You are note authorized to see this page."
