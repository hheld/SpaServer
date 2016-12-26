module User.Jwt exposing (..)

import User.Model exposing (User, emptyUser)
import Array
import Base64
import Json.Decode as Json


extractInfoFromToken : String -> User
extractInfoFromToken token =
    let
        payload : Maybe String
        payload =
            String.split "." token
                |> Array.fromList
                |> Array.get 1
                |> Maybe.withDefault ""
                |> Base64.decode
                |> Result.toMaybe

        userInfoDecoder : Json.Decoder User
        userInfoDecoder =
            Json.map5 User
                (Json.at [ "userInfo", "userName" ] Json.string)
                (Json.at [ "userInfo", "firstName" ] Json.string)
                (Json.at [ "userInfo", "lastName" ] Json.string)
                (Json.at [ "userInfo", "email" ] Json.string)
                (Json.at [ "userInfo", "roles" ] (Json.list Json.string))

        userInfo : Result String User
        userInfo =
            Json.decodeString userInfoDecoder (String.dropRight 1 <| Maybe.withDefault "" payload)

        updatedUser =
            case userInfo of
                Err _ ->
                    emptyUser

                Ok ui ->
                    ui
    in
        updatedUser
