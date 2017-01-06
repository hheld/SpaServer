module ChangePwd.Model exposing (..)


type alias ChangePwdData =
    { newPwd : String
    , oldPwd : String
    , controlPwd : String
    }


emptyChangePwd : ChangePwdData
emptyChangePwd =
    ChangePwdData "" "" ""
