module AllUsersTable.View exposing (..)

import Html exposing (Html, text)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Messages exposing (Msg(..))


allUsersPage : Model -> Html Msg
allUsersPage model =
    text "This is the all users page"
