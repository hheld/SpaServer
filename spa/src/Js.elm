port module Js exposing (..)


port getCookieValue : String -> Cmd msg


port newCookieValue : (( String, String ) -> msg) -> Sub msg
