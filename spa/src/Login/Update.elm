module Login.Update exposing (..)

import Login.Messages exposing (Msg(..))
import Login.Model exposing (LoginData, emptyLoginData)
import Login.Rest exposing (getTokenCmd, logoutCmd)
import Navigation


update : Msg -> LoginData -> ( LoginData, Cmd Msg )
update msg loginData =
    case msg of
        DoLogin ->
            ( loginData, getTokenCmd loginData )

        DoLogout ->
            ( loginData, logoutCmd )

        OnLogout (Ok _) ->
            ( loginData, Navigation.newUrl "#" )

        OnLogout (Err _) ->
            ( emptyLoginData, Cmd.none )

        OnGetToken (Ok token) ->
            ( loginData, Navigation.newUrl "#" )

        OnGetToken (Err err) ->
            ( loginData, Cmd.none )

        SetPassword pwd ->
            ( { loginData | password = pwd }, Cmd.none )

        SetUserName userName ->
            ( { loginData | userName = userName }, Cmd.none )
