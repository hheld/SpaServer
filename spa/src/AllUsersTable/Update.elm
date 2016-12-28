module AllUsersTable.Update exposing (..)

import AllUsersTable.Messages exposing (Msg(..))
import AllUsersTable.Model exposing (AllUsersData, emptyAllUsers)


update : Msg -> AllUsersData -> AllUsersData
update msg allUsers =
    case msg of
        OnGetAllUsers (Ok users) ->
            { allUsers | allUsers = users }

        OnGetAllUsers (Err _) ->
            emptyAllUsers

        OnRowClicked user ->
            let
                dbg =
                    Debug.log "OnUserClicked" user
            in
                allUsers
