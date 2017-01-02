module Model exposing (..)

import Routing exposing (Route)
import User.Model as User exposing (User)
import Login.Model as Login exposing (LoginData)
import AllUsersTable.Model as AllUsers exposing (AllUsersData)
import AddUser.Model as AddUser exposing (AddUserData)


type alias Model =
    { route : Maybe Route
    , csrfToken : String
    , pageHeader : String
    , currentUser : User
    , loginData : LoginData
    , allUsersData : AllUsersData
    , addUserData : AddUserData
    }


initialModel : Maybe Route -> String -> String -> Model
initialModel route csrfToken pageHeader =
    { route = route
    , csrfToken = csrfToken
    , pageHeader = pageHeader
    , currentUser = User.emptyUser
    , loginData = Login.emptyLoginData
    , allUsersData = AllUsers.emptyAllUsers
    , addUserData = AddUser.emptyAddUserData
    }
