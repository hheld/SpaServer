module Login.Messages exposing (..)

import Http


type Msg
    = DoLogin
    | DoLogout
    | OnGetToken (Result Http.Error String)
    | SetPassword String
    | SetUserName String
