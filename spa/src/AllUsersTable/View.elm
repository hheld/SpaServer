module AllUsersTable.View exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, th, tr, td, form, label, input, button)
import Html.Attributes exposing (class, type_, placeholder, defaultValue)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model)
import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsersData)
import User.Model exposing (User)
import ViewHelpers exposing (..)
import String exposing (split)
import Regex


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


userPropertyInput : (msg -> Msg) -> (String -> msg) -> String -> String -> String -> String -> Html Msg
userPropertyInput msgOnInput inputTransform inputType labelText placeholderVal defaultVal =
    div [ class "form-group" ]
        [ label [ class "col-sm-2 control-label" ]
            [ text labelText ]
        , div [ class "col-sm-10" ]
            [ input
                [ type_ inputType
                , class "form-control"
                , placeholder placeholderVal
                , defaultValue defaultVal
                , onInput (msgOnInput << inputTransform)
                ]
                []
            ]
        ]


cleanRoles : String -> String
cleanRoles roles =
    let
        cleanBeginning : String -> String
        cleanBeginning b =
            Regex.replace
                Regex.All
                (Regex.regex "^(?:\\s*;*\\s*)*")
                (\_ -> "")
                b

        cleanMiddle : String -> String
        cleanMiddle m =
            Regex.replace
                Regex.All
                (Regex.regex "([^\\s;])?(?:\\s*;\\s*)+([^\\s;])?")
                (\{ match, submatches } ->
                    let
                        front =
                            submatches
                                |> List.head
                                |> Maybe.withDefault (Just "")
                                |> Maybe.withDefault ""

                        back =
                            submatches
                                |> List.tail
                                |> Maybe.withDefault ([ Just "" ])
                                |> List.head
                                |> Maybe.withDefault (Just "")
                                |> Maybe.withDefault ""
                    in
                        if back /= "" then
                            front ++ ";" ++ back
                        else
                            front
                )
                m
    in
        roles
            |> cleanBeginning
            |> cleanMiddle


userEditor : User -> Html Msg
userEditor user =
    form [ class "form-horizontal" ]
        [ userPropertyInput SetUserName identity "text" "User name" "User name" user.userName
        , userPropertyInput SetFirstName identity "text" "First name" "First name" user.firstName
        , userPropertyInput SetLastName identity "text" "Last name" "Last name" user.lastName
        , userPropertyInput SetEmail identity "email" "Email" "Email" user.email
        , userPropertyInput SetRoles
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
