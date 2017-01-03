module Routing exposing (..)

import Navigation
import UrlParser as Url exposing ((</>), top, s)


type Route
    = HomeRoute
    | AllUsersRoute
    | AddUserRoute
    | ChangePwdRoute


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map HomeRoute top
        , Url.map AllUsersRoute (s "users")
        , Url.map AddUserRoute (s "newUser")
        , Url.map ChangePwdRoute (s "changePwd")
        ]
