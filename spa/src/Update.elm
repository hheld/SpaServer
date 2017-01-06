module Update exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Model exposing (..)
import UrlParser as Url
import Routing exposing (route, Route(..))
import User.Update as UU
import User.Messages as UM
import Login.Update as LU
import Login.Messages as LM
import Login.Rest exposing (logoutCmd)
import User.Model exposing (emptyUser)
import Js exposing (getCookieValue)
import Rest.User as Api
import AllUsersTable.Update as AUU
import AllUsersTable.Messages as AUM
import AddUser.Messages as AddUM
import AddUser.Update as AddUU
import ChangePwd.Messages as CPM
import ChangePwd.Update as CPU
import Task exposing (Task, succeed, perform)
import Time exposing (second)
import NotificationArea.Messages as NM
import NotificationArea.Update as NU
import NotificationArea.Model as NMOD
import Http


httpErrToString : Http.Error -> String
httpErrToString err =
    case err of
        Http.BadStatus resp ->
            resp.body

        _ ->
            ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newRoute =
                    Url.parseHash route location

                cmd =
                    case newRoute of
                        Just AllUsersRoute ->
                            Api.getAllUsersCmd model
                                |> Cmd.map MsgForAllUsersTable

                        Just ChangePwdRoute ->
                            Cmd.map MsgForChangePwd <|
                                perform (\_ -> CPM.ClearModel) (succeed never)

                        _ ->
                            Cmd.none
            in
                ( { model
                    | route = newRoute
                  }
                , cmd
                )

        OnCookieValue ( c, v ) ->
            let
                updatedCsrfToken =
                    if c == "Csrf-token" then
                        v
                    else
                        model.csrfToken
            in
                ( { model | csrfToken = updatedCsrfToken }
                , Cmd.none
                )

        MsgForUser userMsg ->
            case userMsg of
                UM.OnGetUser (Err _) ->
                    ( { model
                        | currentUser = UU.update userMsg model.currentUser
                        , csrfToken = ""
                      }
                    , Cmd.map MsgForLogin logoutCmd
                    )

                _ ->
                    ( { model | currentUser = UU.update userMsg model.currentUser }
                    , Cmd.none
                    )

        MsgForLogin loginMsg ->
            case loginMsg of
                LM.OnGetToken (Ok token) ->
                    let
                        updatedUser =
                            UU.update (UM.UpdateUserFromToken token) model.currentUser

                        ( updatedLoginData, c ) =
                            LU.update loginMsg model.loginData
                    in
                        { model
                            | currentUser = updatedUser
                            , loginData = updatedLoginData
                        }
                            ! [ Cmd.map Messages.MsgForLogin c, getCookieValue "Csrf-token" ]

                LM.OnLogout (Ok _) ->
                    let
                        ( updatedLoginData, c ) =
                            LU.update loginMsg model.loginData

                        clearedModel =
                            clearModel model
                    in
                        ( { clearedModel
                            | loginData = updatedLoginData
                            , csrfToken = ""
                          }
                        , Cmd.map Messages.MsgForLogin c
                        )

                _ ->
                    let
                        ( currentLoginData, c ) =
                            LU.update loginMsg model.loginData
                    in
                        ( { model | loginData = currentLoginData }
                        , Cmd.map Messages.MsgForLogin c
                        )

        MsgForAllUsersTable allUsersMsg ->
            case allUsersMsg of
                AUM.UpdateUser ->
                    let
                        cmd =
                            case model.allUsersData.selectedUser of
                                Nothing ->
                                    Cmd.none

                                Just u ->
                                    case model.allUsersData.originalSelectedUser of
                                        Nothing ->
                                            Cmd.none

                                        Just o ->
                                            Cmd.map MsgForAllUsersTable (Api.updateUserCmd model o u)

                        updatedModel =
                            { model
                                | allUsersData = AUU.update allUsersMsg model.allUsersData
                            }
                    in
                        ( updatedModel, cmd )

                AUM.OnUserUpdated (Ok _) ->
                    model
                        ! [ Cmd.map MsgForAllUsersTable
                                (Api.getAllUsersCmd model)
                          , Cmd.map MsgForUser
                                (Api.getCurrentUserCmd model)
                          ]

                AUM.DeleteUser userName ->
                    ( model
                    , Cmd.map MsgForAllUsersTable <|
                        Api.deleteUserCmd model userName
                    )

                AUM.OnUserDeleted (Ok _) ->
                    { model
                        | allUsersData = AUU.update allUsersMsg model.allUsersData
                    }
                        ! [ Cmd.map MsgForAllUsersTable <|
                                Api.getAllUsersCmd model
                          , Cmd.map MsgForUser <|
                                Api.getCurrentUserCmd model
                          ]

                AUM.ResetPwd userName ->
                    { model
                        | allUsersData = AUU.update allUsersMsg model.allUsersData
                    }
                        ! [ Cmd.map MsgForAllUsersTable <|
                                Api.resetPwdCmd model userName
                          ]

                _ ->
                    ( { model
                        | allUsersData = AUU.update allUsersMsg model.allUsersData
                      }
                    , Cmd.none
                    )

        MsgForAddUser addUserMsg ->
            case addUserMsg of
                AddUM.AddUser ->
                    ( { model
                        | addUserData = AddUU.update addUserMsg model.addUserData
                      }
                    , Cmd.map MsgForAddUser (Api.addUserCmd model)
                    )

                AddUM.OnUserAdded (Ok _) ->
                    { model
                        | addUserData = AddUU.update addUserMsg model.addUserData
                    }
                        ! [ Navigation.newUrl "#users"
                          , perform (\( a, b ) -> NM.AddTemporaryNotification b NMOD.Success a) (succeed ( "User added successfully", 10 * second ))
                                |> Cmd.map MsgForNotifiation
                          ]

                AddUM.OnUserAdded (Err err) ->
                    { model
                        | addUserData = AddUU.update addUserMsg model.addUserData
                    }
                        ! [ perform (\a -> NM.AddDismissableNotification NMOD.Error a) (succeed (httpErrToString err))
                                |> Cmd.map MsgForNotifiation
                          ]

                _ ->
                    { model
                        | addUserData = AddUU.update addUserMsg model.addUserData
                    }
                        ! [ Cmd.none ]

        MsgForChangePwd chgPwdMsg ->
            case chgPwdMsg of
                CPM.ChangePwd ->
                    model
                        ! [ Cmd.map MsgForChangePwd <|
                                Api.changePwdCmd model
                          ]

                CPM.OnPwdChanged (Ok _) ->
                    { model
                        | chgPwdData = CPU.update chgPwdMsg model.chgPwdData
                    }
                        ! [ perform (\( a, b ) -> NM.AddTemporaryNotification b NMOD.Info a) (succeed ( "Password changed successfully", 10 * second ))
                                |> Cmd.map MsgForNotifiation
                          , perform (\_ -> CPM.ClearModel) (succeed never)
                                |> Cmd.map MsgForChangePwd
                          ]

                CPM.OnPwdChanged (Err err) ->
                    { model
                        | chgPwdData = CPU.update chgPwdMsg model.chgPwdData
                    }
                        ! [ perform (\a -> NM.AddDismissableNotification NMOD.Error a) (succeed (httpErrToString err))
                                |> Cmd.map MsgForNotifiation
                          ]

                _ ->
                    { model
                        | chgPwdData = CPU.update chgPwdMsg model.chgPwdData
                    }
                        ! [ Cmd.none ]

        MsgForNotifiation notificationMsg ->
            let
                ( updatedNotificationData, cmd ) =
                    NU.update notificationMsg model.notificationData
            in
                { model
                    | notificationData = updatedNotificationData
                }
                    ! [ Cmd.map MsgForNotifiation cmd ]
