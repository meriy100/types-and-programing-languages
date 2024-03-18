module Main exposing (Term(..), isnumericval, main)

import Html as H


type Info
    = Info


type Term
    = TmTrue Info
    | TmFalse Info
    | TmIF Info Term Term Term
    | TmZero Info
    | TmSucc Info Term
    | TmPred Info Term
    | TmIsZero Info Term


type Error
    = NoRuleApplies


isnumericval t =
    case t of
        TmZero _ ->
            True

        TmSucc _ t1 ->
            isnumericval t1

        _ ->
            False


isval t =
    case t of
        TmTrue _ ->
            True

        TmFalse _ ->
            True

        t1 ->
            isnumericval t1


eval1 : Term -> Result Error Term
eval1 t =
    case t of
        TmIF _ (TmTrue _) t2 t3 ->
            Result.Ok t2

        TmIF _ (TmFalse _) t2 t3 ->
            Result.Ok t3

        TmIF fi t1 t2 t3 ->
            let
                result =
                    eval1 t1
            in
            Result.andThen (\t1a -> Result.Ok (TmIF fi t1a t2 t3)) result

        TmSucc fi t1 ->
            let
                result =
                    eval1 t1
            in
            Result.andThen (\t1a -> Result.Ok (TmSucc fi t1a)) result

        TmPred _ (TmZero _) ->
            TmZero Info |> Result.Ok

        TmPred _ (TmSucc _ nv1) ->
            if isnumericval nv1 then
                nv1 |> Result.Ok

            else
                NoRuleApplies |> Result.Err

        TmPred fi t1 ->
            let
                result =
                    eval1 t1
            in
            Result.andThen (\t1a -> Result.Ok (TmPred fi t1a)) result

        TmIsZero _ (TmZero _) ->
            TmTrue Info |> Result.Ok

        TmIsZero _ (TmSucc _ nv1) ->
            if isnumericval nv1 then
                TmFalse Info |> Result.Ok

            else
                NoRuleApplies |> Result.Err

        TmIsZero fi t1 ->
            let
                result =
                    eval1 t1
            in
            Result.andThen (\t1a -> Result.Ok (TmIsZero fi t1a)) result

        _ ->
            Result.Err NoRuleApplies


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
            , H.text (isnumericval (TmZero Info) |> boolToString)
            ]
        , H.div []
            [ H.text "isnumericval TmSucc TmSucc TmZero ="
            , H.text (isnumericval (TmSucc Info (TmSucc Info (TmZero Info))) |> boolToString)
            ]
        , H.div []
            [ H.text "isval ="
            , H.text (isval (TmIF Info (TmTrue Info) (TmZero Info) (TmSucc Info (TmZero Info))) |> boolToString)
            ]
        , H.div []
            [ H.text "eval1 ="
            , H.text (eval1 (TmIF Info (TmIsZero Info (TmTrue Info)) (TmZero Info) (TmSucc Info (TmZero Info))) |> Debug.toString)
            ]
        ]
