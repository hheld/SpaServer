module User.Update exposing (..)

import User.Model exposing (User, emptyUser)
import User.Messages exposing (Msg(..))
import Http
import User.Jwt exposing (extractInfoFromToken)


update : Msg -> User -> User
update msg user =
    case msg of
        OnGetUser (Ok u) ->
            u

        OnGetUser (Err err) ->
            emptyUser

        UpdateUserFromToken token ->
            extractInfoFromToken token
