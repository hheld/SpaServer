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
import Http
import AllUsersTable.Update as AUU
import AllUsersTable.Messages as AUM


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
                            Api.getAllUsers model
                                |> Http.send AUM.OnGetAllUsers
                                |> Cmd.map MsgFoAllUsersTable

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
                    in
                        ( { model
                            | currentUser = emptyUser
                            , loginData = updatedLoginData
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

        MsgFoAllUsersTable allUsersMsg ->
            ( { model
                | allUsersData = AUU.update allUsersMsg model.allUsersData
              }
            , Cmd.none
            )
