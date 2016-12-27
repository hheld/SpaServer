module ViewHelpers exposing (..)

import Html exposing (Html, text, span)
import Html.Attributes exposing (class, style)


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
