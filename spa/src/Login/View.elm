module Login.View exposing (..)

import Html exposing (Html, div, text, input, label, form, button)
import Html.Attributes exposing (class, type_, placeholder, value, defaultValue)
import Html.Events exposing (onClick, onInput)
import User.Model exposing (User)
import Login.Messages exposing (Msg(..))


loginPage : User -> String -> Html Msg
loginPage user csrfToken =
    if csrfToken /= "" then
        div []
            [ text ("Already logged in as " ++ user.userName)
            , button
                [ class "btn btn-default"
                , type_ "button"
                , onClick DoLogout
                ]
                [ text "Logout" ]
            ]
    else
        loginForm user


loginForm : User -> Html Msg
loginForm user =
    div
        [ class "formContainer container-fluid well" ]
        [ form
            []
            [ div [ class "form-group" ]
                [ label [] [ text "User name" ]
                , input
                    [ type_ "text"
                    , class "form-control"
                    , placeholder "User name"
                    , onInput SetUserName
                    , defaultValue user.userName
                    ]
                    []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Password" ]
                , input
                    [ type_ "password"
                    , class "form-control"
                    , placeholder "Password"
                    , onInput SetPassword
                    ]
                    []
                ]
            , button
                [ class "btn btn-default"
                , type_ "button"
                , onClick DoLogin
                ]
                [ text "Login" ]
            ]
        ]
