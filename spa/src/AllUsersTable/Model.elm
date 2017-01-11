module AllUsersTable.Model exposing (..)

import User.Model exposing (User)


type alias AllUsersData =
    { allUsers : List User
    , selectedUser : Maybe User
    , originalSelectedUser : Maybe User
    , filter : Maybe String
    }


emptyAllUsers : AllUsersData
emptyAllUsers =
    AllUsersData [] Nothing Nothing Nothing
