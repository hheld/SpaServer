module Messages exposing (..)

import Navigation
import User.Messages as UM
import Login.Messages as LM
import AllUsersTable.Messages as AUM
import AddUser.Messages as AddUM


type Msg
    = UrlChange Navigation.Location
    | OnCookieValue ( String, String )
    | MsgForUser UM.Msg
    | MsgForLogin LM.Msg
    | MsgForAllUsersTable AUM.Msg
    | MsgForAddUser AddUM.Msg
