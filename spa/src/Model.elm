module Model exposing (..)

import Routing exposing (Route)


type alias Model =
    { route : Maybe Route }


initialModel : Maybe Route -> Model
initialModel route =
    { route = route }
