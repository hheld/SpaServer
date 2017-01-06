module NotificationArea.View exposing (..)

import NotificationArea.Messages exposing (Msg(..))
import NotificationArea.Model exposing (NotificationData, Notification, MsgType(..))
import Html exposing (Html, text, div, button, span)
import Html.Attributes exposing (class, attribute, type_)


notificationArea : NotificationData -> Html Msg
notificationArea model =
    let
        notifications : List (Html Msg)
        notifications =
            List.map
                (\n ->
                    let
                        classes : String
                        classes =
                            case n.kind of
                                Success ->
                                    "alert alert-success"

                                Info ->
                                    "alert alert-info"

                                Warning ->
                                    "alert alert-warning"

                                Error ->
                                    "alert alert-danger"
                    in
                        div
                            [ if n.isDismissable then
                                class (classes ++ " " ++ "alert-dismissible")
                              else
                                class classes
                            ]
                            [ if n.isDismissable then
                                dismissButton
                              else
                                text ""
                            , text n.msg
                            ]
                )
                model.msgs
    in
        div [] notifications


dismissButton : Html Msg
dismissButton =
    button
        [ type_ "button"
        , class "close"
        , attribute "data-dismiss" "alert"
        ]
        [ span []
            [ text "×" ]
        ]
