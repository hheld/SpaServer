module AddUser.View exposing (..)

import AddUser.Model exposing (AddUserData)
import AddUser.Messages exposing (Msg(..))
import Html exposing (Html, text, div, form, button)
import Html.Attributes exposing (class, type_)
import Html.Events exposing (onClick)
import ViewHelpers exposing (..)
import User.Model exposing (User)
import String exposing (split)


addUserPage : AddUserData -> Html Msg
addUserPage model =
    let
        addUserBtn : Html Msg
        addUserBtn =
            if model.password == model.passwordControl && model.password /= "" && model.newUser.userName /= "" then
                button
                    [ type_ "button"
                    , class "btn btn-warning"
                    , onClick AddUser
                    ]
                    [ text "Add user"
                    ]
            else
                text ""
    in
        div []
            [ userDataForm model.newUser model.password model.passwordControl
            , addUserBtn
            ]


userDataForm : User -> String -> String -> Html Msg
userDataForm user pwd pwdCtrl =
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
        , inputField SetPassword identity "password" "Password" "Password" pwd
        , inputField SetPasswordControl identity "password" "Repeat password" "Repeat password" pwdCtrl
        ]
