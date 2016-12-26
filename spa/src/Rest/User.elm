module Rest.User exposing (..)

import Http
import Model exposing (Model)
import User.Model exposing (User)


userInfoUrl : String
userInfoUrl =
    "/userInfo"


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
