module AddUser.Update exposing (..)

import AddUser.Model exposing (AddUserData, emptyAddUserData)
import AddUser.Messages exposing (Msg(..))
import User.Model exposing (User)
import Http


update : Msg -> AddUserData -> AddUserData
update msg model =
    case msg of
        SetUserName name ->
            let
                currentNewUser =
                    model.newUser

                updatedNewUser =
                    { currentNewUser | userName = name }
            in
                { model
                    | newUser = updatedNewUser
                }

        SetFirstName name ->
            let
                currentNewUser =
                    model.newUser

                updatedNewUser =
                    { currentNewUser | firstName = name }
            in
                { model
                    | newUser = updatedNewUser
                }

        SetLastName name ->
            let
                currentNewUser =
                    model.newUser

                updatedNewUser =
                    { currentNewUser | lastName = name }
            in
                { model
                    | newUser = updatedNewUser
                }

        SetEmail email ->
            let
                currentNewUser =
                    model.newUser

                updatedNewUser =
                    { currentNewUser | email = email }
            in
                { model
                    | newUser = updatedNewUser
                }

        SetRoles roles ->
            let
                currentNewUser =
                    model.newUser

                updatedNewUser =
                    { currentNewUser | roles = roles }
            in
                { model
                    | newUser = updatedNewUser
                }

        SetPassword pwd ->
            { model
                | password = pwd
            }

        SetPasswordControl pwd ->
            { model
                | passwordControl = pwd
            }

        AddUser ->
            model

        OnUserAdded (Ok _) ->
            emptyAddUserData

        OnUserAdded (Err err) ->
            let
                errMsg : String
                errMsg =
                    case err of
                        Http.BadStatus resp ->
                            resp.body

                        _ ->
                            ""
            in
                { model
                    | httpError = Just errMsg
                }
