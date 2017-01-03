module ChangePwd.Update exposing (..)

import ChangePwd.Model exposing (ChangePwdData, emptyChangePwd)
import ChangePwd.Messages exposing (Msg(..))


update : Msg -> ChangePwdData -> ChangePwdData
update msg model =
    case msg of
        SetNewPwd pwd ->
            { model
                | newPwd = pwd
                , notification = Nothing
            }

        SetCurrentPwd pwd ->
            { model
                | oldPwd = pwd
                , notification = Nothing
            }

        SetControlPwd pwd ->
            { model
                | controlPwd = pwd
            }

        ChangePwd ->
            model

        OnPwdChanged (Ok _) ->
            { emptyChangePwd
                | notification = Just ( "Password changed successfully", True )
            }

        OnPwdChanged (Err err) ->
            { model
                | notification = Just ( toString err, False )
            }
