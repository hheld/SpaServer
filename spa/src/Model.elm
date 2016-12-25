module Model exposing (..)

import Routing exposing (Route)
import User.Model as User exposing (User)


type alias Model =
    { route : Maybe Route
    , csrfToken : String
    , currentUser : User
    }


initialModel : Maybe Route -> String -> Model
initialModel route csrfToken =
    { route = route
    , csrfToken = csrfToken
    , currentUser = User.emptyUser
    }
