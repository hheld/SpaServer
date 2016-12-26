module Update exposing (..)

import Navigation
import Messages exposing (Msg(..))
import Model exposing (..)
import UrlParser as Url
import Routing exposing (route)
import User.Update as UU
import User.Messages as UM
import Login.Update as LU
import Login.Messages as LM


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model
                | route = Url.parseHash route location
              }
            , Cmd.none
            )

        MsgForUser userMsg ->
            ( { model | currentUser = UU.update userMsg model.currentUser }
            , Cmd.none
            )

        MsgForLogin loginMsg ->
            case loginMsg of
                LM.OnGetToken (Ok token) ->
                    let
                        updatedUser =
                            UU.update (UM.UpdateUserFromToken token) model.currentUser

                        dbg =
                            Debug.log "LM.OnGetToken" updatedUser
                    in
                        ( { model | currentUser = updatedUser }
                        , Cmd.none
                        )

                _ ->
                    let
                        ( currentLoginData, c ) =
                            LU.update loginMsg model.loginData
                    in
                        ( { model | loginData = currentLoginData }
                        , Cmd.map Messages.MsgForLogin c
                        )
