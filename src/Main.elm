module Main exposing (..)

import Html.App as App
import Html exposing (Html, text, div, h2, ul, li, input, button)
import Html.Attributes exposing (value, placeholder)


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
    , plays =
        [ Play 1 1 "Drago Bloodfist" 3
        , Play 2 3 "Toothless Nightfury" 3
        , Play 3 3 "Toothless Nightfury" 2
        , Play 4 1 "Drago Bloodfist" 3
        , Play 5 2 "Hiccup Stoicson" 1
        ]
    }


someSpaces : String
someSpaces =
    "    "



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
    div []
        [ playerListHeader
        , playerList players
        , pointTotal 100
        ]


playerListHeader : Html Msg
playerListHeader =
    div []
        [ text "Name"
        , text someSpaces
        , text "Points"
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
        , text "  "
        , text (toString player.points)
        ]


pointTotal : Int -> Html Msg
pointTotal points =
    text (toString points)


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
        , text someSpaces
        , text "Points"
        ]


playList : List Play -> Html Msg
playList plays =
    div []
        [ ul [] (List.map (\p -> play p) plays)
        ]


play : Play -> Html Msg
play play =
    li []
        [ button [] [ text "X" ]
        , text play.name
        , text someSpaces
        , text (toString play.points)
        ]



-- Main entry point


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
