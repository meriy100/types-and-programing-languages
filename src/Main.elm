module Main exposing (Term(..), isnumericval, main)

import Html as H


type Term
    = TmTrue
    | TmFalse
    | TmIF Term Term Term
    | TmZero
    | TmSucc Term
    | TmPred Term
    | TmIsZero


isnumericval t =
    case t of
        TmZero ->
            True

        TmSucc t1 ->
            isnumericval t1

        _ ->
            False


boolToString bool =
    if bool then
        "true"

    else
        "false"


main =
    H.div []
        [ H.text "Hello!"
        , H.div []
            [ H.text "isnumericval TmZero ="
            , H.text (isnumericval TmZero |> boolToString)
            ]
        , H.div []
            [ H.text "isnumericval TmSucc TmSucc TmZero ="
            , H.text (isnumericval (TmSucc (TmSucc TmZero)) |> boolToString)
            ]
        ]
