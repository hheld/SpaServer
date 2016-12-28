module AllUsersTable.Model exposing (..)

import User.Model exposing (User)


type alias AllUsersData =
    { allUsers : List User
    }


emptyAllUsers : AllUsersData
emptyAllUsers =
    AllUsersData []
