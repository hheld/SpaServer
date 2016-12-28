module Model exposing (..)

import Routing exposing (Route)
import User.Model as User exposing (User)
import Login.Model as Login exposing (LoginData)
import AllUsersTable.Model as AllUsers exposing (AllUsersData)


type alias Model =
    { route : Maybe Route
    , csrfToken : String
    , currentUser : User
    , loginData : LoginData
    , allUsersData : AllUsersData
    }


initialModel : Maybe Route -> String -> Model
initialModel route csrfToken =
    { route = route
    , csrfToken = csrfToken
    , currentUser = User.emptyUser
    , loginData = Login.emptyLoginData
    , allUsersData = AllUsers.emptyAllUsers
    }
