module AllUsersTable.View exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, th, tr, td)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model exposing (Model)
import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsersData)
import User.Model exposing (User)
import ViewHelpers exposing (..)


allUsersPage : Model -> Html Msg
allUsersPage model =
    usersTable model.allUsersData


usersTable : AllUsersData -> Html Msg
usersTable allUsers =
    let
        rows : List (Html Msg)
        rows =
            List.map
                (\u ->
                    tr [ onClick (OnRowClicked u) ]
                        [ td [] [ text u.userName ]
                        , td [] [ text u.firstName ]
                        , td [] [ text u.lastName ]
                        , td [] [ text u.email ]
                        , td [] (roleLabels u.roles)
                        ]
                )
                allUsers.allUsers
    in
        div [ class "table-responsive" ]
            [ table
                [ class "table table-striped table-condensed" ]
                [ thead []
                    [ th [] [ text "User name" ]
                    , th [] [ text "First name" ]
                    , th [] [ text "Last name" ]
                    , th [] [ text "Email" ]
                    , th [] [ text "Roles" ]
                    ]
                , tbody []
                    rows
                ]
            ]
