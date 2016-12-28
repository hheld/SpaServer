module AllUsersTable.Messages exposing (..)

import Http
import User.Model exposing (User)


type Msg
    = OnGetAllUsers (Result Http.Error (List User))
    | OnRowClicked User
