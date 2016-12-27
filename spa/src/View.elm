module View exposing (..)

import Html exposing (Html, div, text, h1, ul, li, a)
import Html.Attributes exposing (class, href)
import Model exposing (Model)
import Messages exposing (Msg)
import Routing exposing (Route(..))
import Home.View exposing (homePage)
import Login.View exposing (loginPage)
import NotFoundPage.View exposing (notFoundPage)
import AllUsersTable.View exposing (allUsersPage)
import Tuple exposing (first, second)


view : Model -> Html Msg
view model =
    div [] [ page model ]


page : Model -> Html Msg
page model =
    let
        content =
            case model.route of
                Just HomeRoute ->
                    homePage model

                Just AllUsersRoute ->
                    allUsersPage model

                Nothing ->
                    notFoundPage model
    in
        outerLayout model content


outerLayout : Model -> Html Msg -> Html Msg
outerLayout model content =
    div [ class "container" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col-xs-8" ]
                [ div
                    [ class "page-header" ]
                    [ h1 []
                        [ text "Page header" ]
                    ]
                , navigation model
                , content
                ]
            , div
                [ class "pull-right col-xs-4" ]
                [ Html.map Messages.MsgForLogin (loginPage model.currentUser model.csrfToken)
                ]
            ]
        ]


type alias TabInfo =
    { route : String
    , tabTitle : String
    , adminOnly : Bool
    }


tabInfos : List TabInfo
tabInfos =
    [ { route = "#", tabTitle = "Home", adminOnly = False }
    , { route = "#users", tabTitle = "Users", adminOnly = True }
    ]


isTabActive : Model -> TabInfo -> Bool
isTabActive model { route, tabTitle, adminOnly } =
    case model.route of
        Just HomeRoute ->
            if route == "#" || route == "" then
                True
            else
                False

        Just AllUsersRoute ->
            if route == "#users" then
                True
            else
                False

        Nothing ->
            False


navigation : Model -> Html Msg
navigation model =
    let
        isAdmin : Bool
        isAdmin =
            List.member "admin" model.currentUser.roles

        tabClass : TabInfo -> String
        tabClass ti =
            if isTabActive model ti then
                "active"
            else
                ""

        filteredTabsInfos : List TabInfo
        filteredTabsInfos =
            List.filter
                (\ti ->
                    isAdmin || not ti.adminOnly
                )
                tabInfos

        tabs : List (Html Msg)
        tabs =
            List.map
                (\ti ->
                    li [ class (tabClass ti) ]
                        [ a [ href ti.route ]
                            [ text ti.tabTitle ]
                        ]
                )
                filteredTabsInfos
    in
        ul [ class "nav nav-tabs" ] tabs
