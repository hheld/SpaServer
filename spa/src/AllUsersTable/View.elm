module AllUsersTable.View exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, th, tr, td, form, button)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onClick)
import Model exposing (Model)
import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsersData)
import User.Model exposing (User)
import ViewHelpers exposing (..)
import String exposing (split)


allUsersPage : Model -> Html Msg
allUsersPage model =
    let
        editor =
            case model.allUsersData.selectedUser of
                Just u ->
                    userEditor u

                Nothing ->
                    text ""
    in
        div []
            [ usersTable model.allUsersData
            , editor
            ]


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


userEditor : User -> Html Msg
userEditor user =
    form [ class "form-horizontal" ]
        [ inputField SetUserName identity "text" "User name" "User name" user.userName
        , inputField SetFirstName identity "text" "First name" "First name" user.firstName
        , inputField SetLastName identity "text" "Last name" "Last name" user.lastName
        , inputField SetEmail identity "email" "Email" "Email" user.email
        , inputField SetRoles
            (\r ->
                r
                    |> cleanRoles
                    |> split ";"
                    |> List.map
                        (\s ->
                            String.filter (\c -> c /= ' ') s
                        )
            )
            "text"
            "Roles"
            "Roles"
            (List.foldl
                (\r s ->
                    if s == "" then
                        r
                    else
                        s ++ "; " ++ r
                )
                ""
                user.roles
            )
        , button
            [ type_ "button"
            , class "btn btn-warning"
            , onClick UpdateUser
            ]
            [ text "Update user"
            ]
        ]
