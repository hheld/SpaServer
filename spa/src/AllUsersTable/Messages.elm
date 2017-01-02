module AllUsersTable.Messages exposing (..)

import Http
import User.Model exposing (User)


type Msg
    = OnGetAllUsers (Result Http.Error (List User))
    | OnRowClicked User
    | SetUserName String
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetRoles (List String)
    | OnUserUpdated (Result Http.Error String)
    | UpdateUser
    | DeleteUser String
    | OnUserDeleted (Result Http.Error String)
