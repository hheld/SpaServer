module Login.Rest exposing (..)

import Login.Model exposing (LoginData, loginDataEncoder)
import Http
import Json.Decode as JD
import Login.Messages exposing (Msg(..))


tokenUrl : String
tokenUrl =
    "/token"


getTokenCmd : LoginData -> Cmd Msg
getTokenCmd loginData =
    let
        request =
            Http.post tokenUrl
                (Http.jsonBody <|
                    loginDataEncoder loginData
                )
                (JD.field "id_token" JD.string)
    in
        Http.send OnGetToken request
