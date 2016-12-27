module AllUsersTable.Model exposing (..)

import User.Model exposing (User)


type alias AllUsers =
    List User


emptyAllUsers : AllUsers
emptyAllUsers =
    []
