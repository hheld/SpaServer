module Messages exposing (..)

import Navigation
import User.Messages as UM
import Login.Messages as LM


type Msg
    = UrlChange Navigation.Location
    | OnCookieValue ( String, String )
    | MsgForUser UM.Msg
    | MsgForLogin LM.Msg
