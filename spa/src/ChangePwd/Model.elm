module ChangePwd.Model exposing (..)


type alias ChangePwdData =
    { newPwd : String
    , oldPwd : String
    , controlPwd : String
    , notification : Maybe ( String, Bool )
    }


emptyChangePwd : ChangePwdData
emptyChangePwd =
    ChangePwdData "" "" "" Nothing
