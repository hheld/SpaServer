module AddUser.Model exposing (..)

import User.Model exposing (User, emptyUser)


type alias AddUserData =
    { newUser : User
    , password : String
    , passwordControl : String
    }


emptyAddUserData : AddUserData
emptyAddUserData =
    AddUserData emptyUser "" ""
