module Login.View exposing (..)

import Html exposing (Html, div, text, input, label, form, button, img, h3, h6, span, strong)
import Html.Attributes exposing (class, type_, placeholder, value, defaultValue, src, style)
import Html.Events exposing (onClick, onInput)
import User.Model exposing (User)
import Login.Messages exposing (Msg(..))
import MD5
import ViewHelpers exposing (..)


loginPage : User -> String -> Html Msg
loginPage user csrfToken =
    if csrfToken /= "" then
        userInfo user
    else
        loginForm user


userInfo : User -> Html Msg
userInfo user =
    div
        [ class "container-fluid well well-sm" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col-md-4" ]
                [ gravatarImg user.email
                , div
                    [ class "row" ]
                    [ div
                        [ class "col-xs-12" ]
                        (roleLabels user.roles)
                    ]
                ]
            , div
                [ class "col-md-4" ]
                [ h3 [] [ text user.userName ]
                , h6 []
                    [ strong [] [ text "Full name: " ]
                    , text (user.firstName ++ " " ++ user.lastName)
                    ]
                , h6 []
                    [ strong [] [ text "Email: " ]
                    , text user.email
                    ]
                ]
            , div
                [ class "col-md-4" ]
                [ button
                    [ class "btn btn-default"
                    , type_ "button"
                    , onClick DoLogout
                    ]
                    [ text "Logout" ]
                ]
            ]
        ]


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


gravatarImg : String -> Html Msg
gravatarImg email =
    let
        imgUrl : String
        imgUrl =
            "https://www.gravatar.com/avatar/" ++ (MD5.hex email) ++ "?d=mm"
    in
        img
            [ src imgUrl
            , class "img-circle"
            ]
            []
