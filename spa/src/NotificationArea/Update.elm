module NotificationArea.Update exposing (..)

import NotificationArea.Model exposing (NotificationData, Notification, emptyNotification, MsgType)
import NotificationArea.Messages exposing (Msg(..))
import Process exposing (sleep)
import Task exposing (succeed, perform)


update : Msg -> NotificationData -> ( NotificationData, Cmd Msg )
update msg notification =
    case msg of
        ClearNotifications ->
            emptyNotification ! []

        AddDismissableNotification msgType msgText ->
            { notification
                | msgs = (Notification msgText msgType notification.totalCounter True) :: notification.msgs
                , totalCounter = notification.totalCounter + 1
            }
                ! []

        AddTemporaryNotification duration msgType msgText ->
            let
                currentId : Int
                currentId =
                    notification.totalCounter
            in
                { notification
                    | msgs = (Notification msgText msgType currentId False) :: notification.msgs
                    , totalCounter = currentId + 1
                }
                    ! [ sleep duration
                            |> perform (\_ -> RemoveNotification currentId)
                      ]

        RemoveNotification id ->
            { notification
                | msgs = List.filter (\n -> n.id /= id) notification.msgs
            }
                ! []
