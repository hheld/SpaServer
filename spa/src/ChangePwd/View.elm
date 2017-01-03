module ChangePwd.View exposing (..)

import Html exposing (Html, text, button, div, form)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import ChangePwd.Messages exposing (Msg(..))
import ChangePwd.Model exposing (ChangePwdData)
import Model exposing (Model)
import ViewHelpers exposing (..)


changePwdPage : Model -> Html Msg
changePwdPage model =
    let
        chgPwdBtn : Html Msg
        chgPwdBtn =
            if model.chgPwdData.userName /= "" && model.chgPwdData.oldPwd /= "" && model.chgPwdData.newPwd /= "" && model.chgPwdData.newPwd == model.chgPwdData.controlPwd then
                button
                    [ class "btn btn-warning"
                    , onClick ChangePwd
                    ]
                    [ text "Change password" ]
            else
                text ""
    in
        div []
            [ notificationView model.chgPwdData
            , pwdForm model.chgPwdData
            , chgPwdBtn
            ]


notificationView : ChangePwdData -> Html Msg
notificationView chgPwdData =
    case chgPwdData.notification of
        Just ( msg, ok ) ->
            div
                [ classList
                    [ ( "alert", True )
                    , ( "alert-danger", not ok )
                    ]
                ]
                [ text msg ]

        Nothing ->
            text ""


pwdForm : ChangePwdData -> Html Msg
pwdForm chgPwdData =
    form [ class "form-horizontal" ]
        [ inputField SetUserName identity "text" "User name" "User name" chgPwdData.userName
        , inputField SetCurrentPwd identity "password" "Current password" "Current password" chgPwdData.oldPwd
        , inputField SetNewPwd identity "password" "New password" "New password" chgPwdData.newPwd
        , inputField SetControlPwd identity "password" "Repeat password" "Repeat password" chgPwdData.controlPwd
        ]
