module AddUser.Messages exposing (..)

import Http


type Msg
    = SetUserName String
    | SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetRoles (List String)
    | SetPassword String
    | SetPasswordControl String
    | AddUser
    | OnUserAdded (Result Http.Error String)
