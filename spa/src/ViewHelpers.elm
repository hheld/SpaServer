module ViewHelpers exposing (..)

import Html exposing (Html, text, span, label, div, input)
import Html.Attributes exposing (class, style, defaultValue, placeholder, type_)
import Html.Events exposing (onInput)
import Regex


roleLabels : List String -> List (Html msg)
roleLabels roles =
    let
        classForRole : String -> String
        classForRole r =
            if r == "admin" then
                "label label-danger"
            else
                "label label-primary"

        myStyle : Html.Attribute msg
        myStyle =
            style
                [ ( "display", "inline-block" )
                , ( "margin-left", "1px" )
                ]
    in
        List.map (\r -> span [ class (classForRole r), myStyle ] [ text r ]) roles


inputField : (msg -> msgT) -> (String -> msg) -> String -> String -> String -> String -> Html msgT
inputField msgOnInput inputTransform inputType labelText placeholderVal defaultVal =
    div [ class "form-group" ]
        [ label [ class "col-sm-2 control-label" ]
            [ text labelText ]
        , div [ class "col-sm-10" ]
            [ input
                [ type_ inputType
                , class "form-control"
                , placeholder placeholderVal
                , defaultValue defaultVal
                , onInput (msgOnInput << inputTransform)
                ]
                []
            ]
        ]


cleanRoles : String -> String
cleanRoles roles =
    let
        cleanBeginning : String -> String
        cleanBeginning b =
            Regex.replace
                Regex.All
                (Regex.regex "^(?:\\s*;*\\s*)*")
                (\_ -> "")
                b

        cleanMiddle : String -> String
        cleanMiddle m =
            Regex.replace
                Regex.All
                (Regex.regex "([^\\s;])?(?:\\s*;\\s*)+([^\\s;])?")
                (\{ submatches } ->
                    let
                        front =
                            submatches
                                |> List.head
                                |> Maybe.withDefault (Just "")
                                |> Maybe.withDefault ""

                        back =
                            submatches
                                |> List.tail
                                |> Maybe.withDefault ([ Just "" ])
                                |> List.head
                                |> Maybe.withDefault (Just "")
                                |> Maybe.withDefault ""
                    in
                        if back /= "" then
                            front ++ ";" ++ back
                        else
                            front
                )
                m
    in
        roles
            |> cleanBeginning
            |> cleanMiddle
