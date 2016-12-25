module User.Model exposing (..)

import Json.Decode as JD exposing (..)


type alias User =
    { userName : String
    , firstName : String
    , lastName : String
    , email : String
    , roles : List String
    }


emptyUser : User
emptyUser =
    User "" "" "" "" []


userDecoder : JD.Decoder User
userDecoder =
    JD.map5 User
        (JD.at [ "UserName" ] JD.string)
        (JD.at [ "FirstName" ] JD.string)
        (JD.at [ "LastName" ] JD.string)
        (JD.at [ "Email" ] JD.string)
        (JD.at [ "Roles" ] (JD.list JD.string))
