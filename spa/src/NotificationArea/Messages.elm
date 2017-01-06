module NotificationArea.Messages exposing (..)

import NotificationArea.Model exposing (MsgType)
import Time exposing (Time)


type Msg
    = ClearNotifications
    | AddDismissableNotification MsgType String
    | AddTemporaryNotification Time MsgType String
    | RemoveNotification Int
