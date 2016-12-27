module AllUsersTable.Update exposing (..)

import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsers)


update : Msg -> AllUsers -> AllUsers
update msg allUsers =
    case msg of
        OnGetAllUsers (Ok users) ->
            users

        OnGetAllUsers (Err _) ->
            allUsers
