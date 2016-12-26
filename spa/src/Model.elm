module Model exposing (..)

import Routing exposing (Route)
import User.Model as User exposing (User)
import Login.Model as Login exposing (LoginData)


type alias Model =
    { route : Maybe Route
    , csrfToken : String
    , currentUser : User
    , loginData : LoginData
    }


initialModel : Maybe Route -> String -> Model
initialModel route csrfToken =
    { route = route
    , csrfToken = csrfToken
    , currentUser = User.emptyUser
    , loginData = Login.emptyLoginData
    }
