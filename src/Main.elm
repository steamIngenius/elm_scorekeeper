module Main exposing (..)

import Html exposing (Html, text, div, h2, ul, li)
import Html.App as App


-- Model


type alias Model =
    { players : List Player
    , playerName : String
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
    { players = []
    , playerName = ""
    , playerId = Nothing
    , plays = []
    }



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
    mainView


mainView : Html Msg
mainView =
    div []
        [ h2 []
            [ text "Score Keeper" ]
        , div [] [ playerSection ]
        ]


playerSection : Html Msg
playerSection =
    div []
        [ playerListHeader
        , playerList
        , pointTotal 100
        ]


playerListHeader : Html Msg
playerListHeader =
    div [] [ text "Player List Header" ]


playerList : Html Msg
playerList =
    div []
        [ ul []
            [ li [] [ text "Player 1" ]
            , li [] [ text "Player 2" ]
            , li [] [ text "Player 3" ]
            ]
        ]


pointTotal : Int -> Html Msg
pointTotal points =
    text (toString points)



-- Main entry point


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
