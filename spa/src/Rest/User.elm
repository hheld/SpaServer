module Rest.User exposing (..)

import Http
import Model exposing (Model)
import User.Model exposing (User)
import Json.Decode as JD


userInfoUrl : String
userInfoUrl =
    "/userInfo"


allUsersUrl : String
allUsersUrl =
    "/allUsers"


getCurrentUser : Model -> Http.Request User
getCurrentUser model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
        , url = userInfoUrl
        , expect = Http.expectJson User.Model.userDecoder
        , timeout = Nothing
        , withCredentials = False
        , body = Http.emptyBody
        }


getAllUsers : Model -> Http.Request (List User)
getAllUsers model =
    Http.request
        { method = "GET"
        , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
        , url = allUsersUrl
        , expect = Http.expectJson (JD.list User.Model.userDecoder)
        , timeout = Nothing
        , withCredentials = False
        , body = Http.emptyBody
        }
