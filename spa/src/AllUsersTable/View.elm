module AllUsersTable.View exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, th, tr, td, form, button, span, ul, li, a)
import Html.Attributes exposing (class, type_, classList, attribute)
import Html.Events exposing (onClick, onWithOptions)
import Model exposing (Model)
import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsersData)
import User.Model exposing (User, emptyUser)
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
            [ usersTable model.allUsersData model.currentUser
            , editor
            ]


usersTable : AllUsersData -> User -> Html Msg
usersTable allUsers currentUser =
    let
        rows : List (Html Msg)
        rows =
            List.map
                (\u ->
                    tr
                        [ classList
                            [ ( "info", u == Maybe.withDefault emptyUser allUsers.selectedUser )
                            ]
                        ]
                        [ td [ onClick (OnRowClicked u) ] [ text u.userName ]
                        , td [ onClick (OnRowClicked u) ] [ text u.firstName ]
                        , td [ onClick (OnRowClicked u) ] [ text u.lastName ]
                        , td [ onClick (OnRowClicked u) ] [ text u.email ]
                        , td [ onClick (OnRowClicked u) ] (roleLabels u.roles)
                        , td []
                            [ userActions u (u == currentUser)
                            ]
                        ]
                )
                allUsers.allUsers
    in
        div [ class "table-responsive" ]
            [ table
                [ class "table table-striped table-condensed table-hover" ]
                [ thead []
                    [ th [] [ text "User name" ]
                    , th [] [ text "First name" ]
                    , th [] [ text "Last name" ]
                    , th [] [ text "Email" ]
                    , th [] [ text "Roles" ]
                    , th [] [ text "" ]
                    ]
                , tbody []
                    rows
                ]
            ]


userActions : User -> Bool -> Html Msg
userActions user isCurrentUser =
    let
        actions : List (Html Msg)
        actions =
            [ if not isCurrentUser then
                li []
                    [ a
                        [ onClick <| DeleteUser user.userName
                        ]
                        [ text "Delete"
                        ]
                    ]
              else
                text ""
            ]
    in
        div [ class "dropdown" ]
            [ button
                [ class "btn btn-default btn-xs dropdown-toggle"
                , type_ "button"
                , attribute "data-toggle" "dropdown"
                ]
                [ text "Actions"
                , span [ class "caret" ] []
                ]
            , ul [ class "dropdown-menu" ]
                actions
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
