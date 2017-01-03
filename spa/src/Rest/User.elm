module Rest.User exposing (..)

import Http
import Model exposing (Model)
import User.Model exposing (User)
import User.Messages as UM
import Json.Decode as JD
import Json.Encode as JE
import AllUsersTable.Messages as AM
import AddUser.Messages as AddUM
import ChangePwd.Messages as CPM


userInfoUrl : String
userInfoUrl =
    "/userInfo"


allUsersUrl : String
allUsersUrl =
    "/allUsers"


updateUserUrl : String
updateUserUrl =
    "/updateUser"


addUserUrl : String
addUserUrl =
    "/addUser"


deleteUserUrl : String
deleteUserUrl =
    "/deleteUser"


changePwdUrl : String
changePwdUrl =
    "/changePwd"


getCurrentUserCmd : Model -> Cmd UM.Msg
getCurrentUserCmd model =
    let
        request : Http.Request User
        request =
            Http.request
                { method = "GET"
                , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
                , url = userInfoUrl
                , expect = Http.expectJson User.Model.userDecoder
                , timeout = Nothing
                , withCredentials = False
                , body = Http.emptyBody
                }
    in
        Http.send UM.OnGetUser request


getAllUsersCmd : Model -> Cmd AM.Msg
getAllUsersCmd model =
    let
        request : Http.Request (List User)
        request =
            Http.request
                { method = "GET"
                , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
                , url = allUsersUrl
                , expect = Http.expectJson (JD.list User.Model.userDecoder)
                , timeout = Nothing
                , withCredentials = False
                , body = Http.emptyBody
                }
    in
        Http.send AM.OnGetAllUsers request


updateUserCmd : Model -> User -> User -> Cmd AM.Msg
updateUserCmd model oldUser newUser =
    let
        encoder : JE.Value
        encoder =
            JE.object
                [ ( "OldData", User.Model.userEncoder oldUser )
                , ( "NewData", User.Model.userEncoder newUser )
                ]

        request =
            Http.request
                { method = "POST"
                , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
                , url = updateUserUrl
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False
                , body = Http.jsonBody encoder
                }
    in
        Http.send AM.OnUserUpdated request


addUserCmd : Model -> Cmd AddUM.Msg
addUserCmd model =
    let
        encoder : JE.Value
        encoder =
            JE.object
                [ ( "User", User.Model.userEncoder model.addUserData.newUser )
                , ( "Password", JE.string model.addUserData.password )
                ]

        request =
            Http.request
                { method = "POST"
                , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
                , url = addUserUrl
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False
                , body = Http.jsonBody encoder
                }
    in
        Http.send AddUM.OnUserAdded request


deleteUserCmd : Model -> String -> Cmd AM.Msg
deleteUserCmd model userName =
    let
        encoder : JE.Value
        encoder =
            JE.object
                [ ( "UserName", JE.string userName )
                ]

        request =
            Http.request
                { method = "POST"
                , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
                , url = deleteUserUrl
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False
                , body = Http.jsonBody encoder
                }
    in
        Http.send AM.OnUserDeleted request


changePwdCmd : Model -> Cmd CPM.Msg
changePwdCmd model =
    let
        encoder : JE.Value
        encoder =
            JE.object
                [ ( "UserName", JE.string model.chgPwdData.userName )
                , ( "NewPwd", JE.string model.chgPwdData.newPwd )
                , ( "CurrentPwd", JE.string model.chgPwdData.oldPwd )
                ]

        request =
            Http.request
                { method = "POST"
                , headers = [ Http.header "X-Csrf-Token" model.csrfToken ]
                , url = changePwdUrl
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False
                , body = Http.jsonBody encoder
                }
    in
        Http.send CPM.OnPwdChanged request
