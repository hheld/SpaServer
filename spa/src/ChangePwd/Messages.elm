module ChangePwd.Messages exposing (..)

import Http


type Msg
    = SetUserName String
    | SetNewPwd String
    | SetCurrentPwd String
    | SetControlPwd String
    | ChangePwd
    | OnPwdChanged (Result Http.Error String)
