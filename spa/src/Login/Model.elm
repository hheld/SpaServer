module Login.Model exposing (..)

import Json.Encode as JE exposing (..)


type alias LoginData =
    { userName : String
    , password : String
    }


loginDataEncoder : LoginData -> JE.Value
loginDataEncoder loginData =
    JE.object
        [ ( "username", JE.string loginData.userName )
        , ( "password", JE.string loginData.password )
        ]


emptyLoginData : LoginData
emptyLoginData =
    LoginData "" ""
