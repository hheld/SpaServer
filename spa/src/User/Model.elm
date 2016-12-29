module User.Model exposing (..)

import Json.Decode as JD
import Json.Encode as JE


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


userEncoder : User -> JE.Value
userEncoder user =
    JE.object
        [ ( "UserName", JE.string user.userName )
        , ( "FirstName", JE.string user.firstName )
        , ( "LastName", JE.string user.lastName )
        , ( "Email", JE.string user.email )
        , ( "Roles", JE.list (List.map JE.string user.roles) )
        ]
