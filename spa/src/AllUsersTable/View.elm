module AllUsersTable.View exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, th, tr, td)
import Html.Attributes exposing (class)
import Model exposing (Model)
import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsers)
import User.Model exposing (User)
import ViewHelpers exposing (..)


allUsersPage : Model -> Html Msg
allUsersPage model =
    usersTable model.allUsersData


usersTable : AllUsers -> Html Msg
usersTable allUsers =
    let
        rows : List (Html Msg)
        rows =
            List.map
                (\u ->
                    tr []
                        [ td [] [ text u.userName ]
                        , td [] [ text u.firstName ]
                        , td [] [ text u.lastName ]
                        , td [] [ text u.email ]
                        , td [] (roleLabels u.roles)
                        ]
                )
                allUsers
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
