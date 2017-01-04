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
                newSelectedUser =
                    case allUsers.selectedUser of
                        Just u ->
                            if u == user then
                                Nothing
                            else
                                Just user

                        Nothing ->
                            Just user
            in
                { allUsers
                    | selectedUser = newSelectedUser
                    , originalSelectedUser = newSelectedUser
                }

        SetUserName userName ->
            let
                updatedSelectedUser =
                    case allUsers.selectedUser of
                        Just u ->
                            Just { u | userName = userName }

                        Nothing ->
                            Nothing
            in
                { allUsers | selectedUser = updatedSelectedUser }

        SetFirstName firstName ->
            let
                updatedSelectedUser =
                    case allUsers.selectedUser of
                        Just u ->
                            Just { u | firstName = firstName }

                        Nothing ->
                            Nothing
            in
                { allUsers | selectedUser = updatedSelectedUser }

        SetLastName lastName ->
            let
                updatedSelectedUser =
                    case allUsers.selectedUser of
                        Just u ->
                            Just { u | lastName = lastName }

                        Nothing ->
                            Nothing
            in
                { allUsers | selectedUser = updatedSelectedUser }

        SetEmail email ->
            let
                updatedSelectedUser =
                    case allUsers.selectedUser of
                        Just u ->
                            Just { u | email = email }

                        Nothing ->
                            Nothing
            in
                { allUsers | selectedUser = updatedSelectedUser }

        SetRoles roles ->
            let
                updatedSelectedUser =
                    case allUsers.selectedUser of
                        Just u ->
                            Just { u | roles = roles }

                        Nothing ->
                            Nothing
            in
                { allUsers | selectedUser = updatedSelectedUser }

        OnUserUpdated (Ok _) ->
            allUsers

        OnUserUpdated (Err _) ->
            allUsers

        UpdateUser ->
            allUsers

        DeleteUser _ ->
            allUsers

        OnUserDeleted (Ok _) ->
            { allUsers
                | selectedUser = Nothing
                , originalSelectedUser = Nothing
            }

        OnUserDeleted (Err _) ->
            allUsers

        ResetPwd _ ->
            allUsers

        OnPwdReset (Ok _) ->
            allUsers

        OnPwdReset (Err _) ->
            allUsers
