module Main exposing (..)

import Html.App as App
import Html exposing (Html, text, div, h2, input, button, span, hr)
import Html.Attributes exposing (value, placeholder, style, class, id)
import Html.Events exposing (onClick, onInput)


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
        [ Player 1 "Drago Bloodfist" 0
        , Player 2 "Hiccup Stoicson" 0
        , Player 3 "Toothless Nightfury" 0
        ]
    , playerName = Nothing
    , playerId = Nothing
    , plays = []
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
            [ text "SCORE KEEPER" ]
        , div []
            [ playerSection model.players
            , hr [ style [ ( "visibility", "hidden" ) ] ] []
            , playerForm model.playerName
            , hr [ style [ ( "visibility", "hidden" ) ] ] []
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
        , span
            [ style [ ( "flex", "1" ) ] ]
            [ text player.name ]
        , span
            [ style [ ( "flex", "1" ) ] ]
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
            [ onInput Input
            , placeholder "Add/Edit Player..."
            , value (Maybe.withDefault "" playerName)
            , style
                [ ( "box-shadow", "3px 3px 5px 0px rgba(0,0,0,0.75)" ) ]
            ]
            []
        , button
            [ style
                [ ( "box-shadow", "3px 3px 5px 0px rgba(0,0,0,0.75)" ) ]
            , onClick Save
            , id "save-button"
            ]
            [ text "Save" ]
        , button
            [ style
                [ ( "box-shadow", "3px 3px 5px 0px rgba(0,0,0,0.75)" ) ]
            , onClick Cancel
            , id "cancel-button"
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
            , onClick (DeletePlay play)
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
            Debug.log "update fired" ( msg, model )
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
                    , plays =
                        updatePlays
                            (Play 0 player.id player.name points)
                            model.plays
                }

            DeletePlay play ->
                removePlay play.id model

            Input content ->
                { model
                    | playerName = Just content
                }

            Save ->
                { model
                    | players =
                        updatePlayers
                            (Player
                                (Maybe.withDefault 0 model.playerId)
                                (Maybe.withDefault "uknown name" model.playerName)
                                0
                            )
                            model.players
                    , playerId = Nothing
                    , playerName = Nothing
                }

            Edit player ->
                { model
                    | playerId = (Just player.id)
                    , playerName = (Just player.name)
                }

            Cancel ->
                { model
                    | playerName = Nothing
                    , playerId = Nothing
                }


removePlay : Int -> Model -> Model
removePlay id model =
    model


updatePlayers : Player -> List Player -> List Player
updatePlayers player players =
    let
        nextId =
            List.map (\p -> p.id) players
                |> List.maximum
                |> Maybe.withDefault 0
                |> (+) 1

        newPlayerList =
            List.partition (\p -> p.id == player.id) players
                |> snd
    in
        case player.id of
            0 ->
                { player | id = nextId } :: newPlayerList

            _ ->
                player :: newPlayerList


updatePlays : Play -> List Play -> List Play
updatePlays play plays =
    let
        nextId =
            List.map (\p -> p.id) plays
                |> List.maximum
                |> Maybe.withDefault 0
                |> (+) 1

        newPlay =
            { play
                | id = nextId
            }
    in
        newPlay :: plays



-- Main entry point


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
