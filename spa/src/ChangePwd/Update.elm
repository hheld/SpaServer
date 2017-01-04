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
            { model
                | notification = Just ( "Password changed successfully", True )
            }

        OnPwdChanged (Err err) ->
            let
                errMsg : String
                errMsg =
                    case err of
                        Http.BadStatus resp ->
                            resp.body

                        _ ->
                            ""
            in
                { model
                    | notification = Just ( errMsg, False )
                }

        ClearModel ->
            emptyChangePwd
