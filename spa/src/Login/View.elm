module Login.View exposing (..)

import Html exposing (Html, div, text, input, form, button, img, nav, a, p)
import Html.Attributes exposing (class, type_, placeholder, value, src, style, href, height)
import Html.Events exposing (onClick, onInput)
import User.Model exposing (User)
import Login.Messages exposing (Msg(..))
import MD5
import ViewHelpers exposing (..)


loginPage : User -> String -> Html Msg
loginPage user csrfToken =
    let
        content =
            if csrfToken /= "" then
                userInfo user
            else
                loginForm user
    in
        nav
            [ class "navbar navbar-inverse navbar-fixed-top" ]
            [ div
                [ class "container" ]
                [ div
                    [ class "navbar-header" ]
                    content
                ]
            ]


userInfo : User -> List (Html Msg)
userInfo user =
    [ a
        [ class "navbar-brand"
        , href "#"
        ]
        [ gravatarImg user.email ]
    , p
        [ class "navbar-text" ]
        [ text <| "Signed in as " ++ user.userName ]
    , p
        [ class "navbar-text" ]
        [ text <| user.firstName ++ " " ++ user.lastName ]
    , p
        [ class "navbar-text" ]
        [ text <| user.email ]
    , button
        [ class "btn btn-default navbar-btn"
        , type_ "button"
        , onClick DoLogout
        ]
        [ text "Logout" ]
    ]


loginForm : User -> List (Html Msg)
loginForm user =
    [ form
        [ class "navbar-form navbar-left" ]
        [ div [ class "form-group" ]
            [ input
                [ type_ "text"
                , class "form-control"
                , placeholder "User name"
                , onInput SetUserName
                ]
                []
            ]
        , div [ class "form-group" ]
            [ input
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
              -- , height 25
            ]
            []
