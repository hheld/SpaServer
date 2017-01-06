module Model exposing (..)

import Routing exposing (Route)
import User.Model as User exposing (User)
import Login.Model as Login exposing (LoginData)
import AllUsersTable.Model as AllUsers exposing (AllUsersData)
import AddUser.Model as AddUser exposing (AddUserData)
import ChangePwd.Model as ChgPwd exposing (ChangePwdData)
import NotificationArea.Model as NotificationArea exposing (NotificationData)


type alias Model =
    { route : Maybe Route
    , csrfToken : String
    , pageHeader : String
    , currentUser : User
    , loginData : LoginData
    , allUsersData : AllUsersData
    , addUserData : AddUserData
    , chgPwdData : ChangePwdData
    , notificationData : NotificationData
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
    , chgPwdData = ChgPwd.emptyChangePwd
    , notificationData = NotificationArea.emptyNotification
    }
