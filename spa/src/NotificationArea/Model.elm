module NotificationArea.Model exposing (..)


type MsgType
    = Success
    | Info
    | Warning
    | Error


type alias Notification =
    { msg : String
    , kind : MsgType
    , id : Int
    , isDismissable : Bool
    }


type alias NotificationData =
    { msgs : List Notification
    , totalCounter : Int
    }


emptyNotification : NotificationData
emptyNotification =
    NotificationData [] 0
