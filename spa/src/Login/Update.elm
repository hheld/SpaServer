module Login.Update exposing (..)

import Login.Messages exposing (Msg(..))
import Login.Model exposing (LoginData)
import Login.Rest exposing (getTokenCmd)


update : Msg -> LoginData -> ( LoginData, Cmd Msg )
update msg loginData =
    case msg of
        DoLogin ->
            ( loginData, getTokenCmd loginData )

        DoLogout ->
            ( loginData, Cmd.none )

        OnGetToken (Ok token) ->
            ( loginData, Cmd.none )

        OnGetToken (Err err) ->
            ( loginData, Cmd.none )

        SetPassword pwd ->
            ( { loginData | password = pwd }, Cmd.none )

        SetUserName userName ->
            ( { loginData | userName = userName }, Cmd.none )
