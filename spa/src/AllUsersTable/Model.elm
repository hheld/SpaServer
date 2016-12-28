module AllUsersTable.Model exposing (..)

import User.Model exposing (User)


type alias AllUsersData =
    { allUsers : List User
    , selectedUser : Maybe User
    }


emptyAllUsers : AllUsersData
emptyAllUsers =
    AllUsersData [] Nothing
