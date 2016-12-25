module Messages exposing (..)

import Navigation
import User.Messages as UM


type Msg
    = UrlChange Navigation.Location
    | MsgForUser UM.Msg
