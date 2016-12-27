module Routing exposing (..)

import Navigation
import UrlParser as Url exposing ((</>), top, s)


type Route
    = HomeRoute
    | AllUsersRoute


route : Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map HomeRoute top
        , Url.map AllUsersRoute (s "users")
        ]
