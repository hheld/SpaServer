module ChangePwd.Update exposing (..)

import ChangePwd.Model exposing (ChangePwdData, emptyChangePwd)
import ChangePwd.Messages exposing (Msg(..))
import Http


update : Msg -> ChangePwdData -> ChangePwdData
update msg model =
    case msg of
        SetNewPwd pwd ->
            { model
                | newPwd = pwd
            }

        SetCurrentPwd pwd ->
            { model
                | oldPwd = pwd
            }

        SetControlPwd pwd ->
            { model
                | controlPwd = pwd
            }

        ChangePwd ->
            model

        OnPwdChanged (Ok _) ->
            emptyChangePwd

        OnPwdChanged (Err err) ->
            model

        ClearModel ->
            emptyChangePwd
