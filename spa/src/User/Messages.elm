module User.Messages exposing (..)

import User.Model exposing (User)
import Http


type Msg
    = OnGetUser (Result Http.Error User)
