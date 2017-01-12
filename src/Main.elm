module Main exposing (..)

import Html.App as App
import Html exposing (Html, text, div, h2, ul, li, input, button, span)
import Html.Attributes exposing (value, placeholder, style, class)
import Html.Events exposing (onClick)


-- Model


type alias Model =
    { players : List Player
    , playerName : Maybe String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { players =
        [ Player 1 "Drago Bloodfist" 20
        , Player 2 "Hiccup Stoicson" 7
        , Player 3 "Toothless Nightfury" 5
        ]
    , playerName = Nothing
    , playerId = Nothing
    , plays =
        [ Play 1 1 "Drago Bloodfist" 3
        , Play 2 3 "Toothless Nightfury" 3
        , Play 3 3 "Toothless Nightfury" 2
        , Play 4 1 "Drago Bloodfist" 3
        , Play 5 2 "Hiccup Stoicson" 1
        ]
    }



-- View


view : Model -> Html Msg
view model =
    mainView model


mainView : Model -> Html Msg
mainView model =
    div
        []
        [ h2
            [ style
                [ ( "display", "flex" )
                , ( "justify-content", "center" )
                ]
            ]
            [ text "Score Keeper" ]
        , div []
            [ playerSection model.players
            , playerForm model.playerName
            , playSection model.plays
            ]
        ]


playerSection : List Player -> Html Msg
playerSection players =
    let
        totalPoints =
            List.map (\player -> player.points) players
                |> List.sum
    in
        div []
            [ playerListHeader
            , playerList players
            , pointTotal totalPoints
            ]


playerListHeader : Html Msg
playerListHeader =
    let
        headerStyle =
            style
                [ ( "display", "flex" )
                , ( "justify-content", "space-between" )
                , ( "align-items", "baseline" )
                , ( "background-color", "lightgray" )
                ]
    in
        div
            [ headerStyle ]
            [ span [] [ text "Name" ]
            , span [] [ text "Points" ]
            ]


playerList : List Player -> Html Msg
playerList players =
    div []
        (List.sortBy .id players
            |> List.map player
        )


player : Player -> Html Msg
player player =
    div
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "space-between" )
            ]
        ]
        [ button [ onClick (Edit player) ] [ text "..." ]
        , text player.name
        , span []
            [ button [ onClick (Score player 1) ] [ text "1pt" ]
            , button [ onClick (Score player 2) ] [ text "2pt" ]
            , button [ onClick (Score player 3) ] [ text "3pt" ]
            ]
        , text (toString player.points)
        ]


pointTotal : Int -> Html Msg
pointTotal points =
    div
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "flex-end" )
            ]
        ]
        [ span []
            [ text ("Total: " ++ (toString points)) ]
        ]


playerForm : Maybe String -> Html Msg
playerForm playerName =
    div
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "space-between" )
            ]
        ]
        [ input
            [ placeholder "Add/Edit Player..."
            , value (Maybe.withDefault "" playerName)
            , style
                [ ( "box-shadow", "4px 4px 5px 0px rgba(0,0,0,0.75)" )
                ]
            ]
            []
        , button
            [ style
                [ ( "box-shadow", "4px 4px 5px 0px rgba(0,0,0,0.75)" ) ]
            ]
            [ text "Save" ]
        , button
            [ style
                [ ( "box-shadow", "4px 4px 5px 0px rgba(0,0,0,0.75)" ) ]
            ]
            [ text "Cancel" ]
        ]


playSection : List Play -> Html Msg
playSection plays =
    div []
        [ playListHeader
        , playList plays
        ]


playListHeader : Html Msg
playListHeader =
    let
        headerStyle =
            style
                [ ( "display", "flex" )
                , ( "justify-content", "space-between" )
                , ( "align-items", "baseline" )
                , ( "background-color", "lightgray" )
                ]
    in
        div
            [ headerStyle ]
            [ span [] [ text "Plays" ]
            , span [] [ text "Points" ]
            ]


playList : List Play -> Html Msg
playList plays =
    div
        []
        (List.map (\p -> play p) plays)


play : Play -> Html Msg
play play =
    span
        [ style
            [ ( "display", "flex" )
            , ( "justify-content", "space-between" )
            ]
        ]
        [ button
            [ style
                [ ( "color", "red" )
                ]
            ]
            [ text "x" ]
        , span [] [ text play.name ]
        , span [] [ text (toString play.points) ]
        ]



-- Update


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    let
        _ =
            Debug.log "update fired" msg
    in
        case msg of
            Score player points ->
                { model
                    | players =
                        updatePlayers
                            { player
                                | points = player.points + points
                            }
                            model.players
                }

            _ ->
                model


updatePlayers : Player -> List Player -> List Player
updatePlayers player players =
    let
        newPlayerList =
            List.partition (\p -> p.id == player.id) players
                |> snd
    in
        player :: newPlayerList



-- Main entry point


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
