module Main exposing (..)

import Html.App as App
import Html exposing (Html, text, div, h2, ul, li, input, button, span)
import Html.Attributes exposing (value, placeholder, style)


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
    div []
        [ h2 []
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
            , div [ style [ ( "clear", "both" ) ] ] []
            ]


playerListHeader : Html Msg
playerListHeader =
    div []
        [ text "Name"
        , span [ style [ ( "float", "right" ) ] ] [ text "Points" ]
        ]


playerList : List Player -> Html Msg
playerList players =
    div []
        [ ul []
            (List.map (\p -> li [] [ player p ]) players)
        ]


player : Player -> Html Msg
player player =
    div []
        [ text player.name
        , button [] [ text "1pt" ]
        , button [] [ text "2pt" ]
        , button [] [ text "3pt" ]
        , text (toString player.points)
        ]


pointTotal : Int -> Html Msg
pointTotal points =
    div []
        [ span
            [ style
                [ ( "float", "right" )
                ]
            ]
            [ text ("Total: " ++ (toString points)) ]
        ]


playerForm : Maybe String -> Html Msg
playerForm playerName =
    div []
        [ input
            [ placeholder "Add/Edit Player..."
            , value (Maybe.withDefault "" playerName)
            ]
            []
        , button [] [ text "Save" ]
        , button [] [ text "Cancel" ]
        ]


playSection : List Play -> Html Msg
playSection plays =
    div []
        [ playListHeader
        , playList plays
        ]


playListHeader : Html Msg
playListHeader =
    div []
        [ text "Plays"
        , span [ style [ ( "float", "right" ) ] ] [ text "Points" ]
        ]


playList : List Play -> Html Msg
playList plays =
    div []
        [ ul [] (List.map (\p -> play p) plays)
        ]


play : Play -> Html Msg
play play =
    li []
        [ button [] [ text "x" ]
        , text play.name
        , text (toString play.points)
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
    model



-- Main entry point


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
