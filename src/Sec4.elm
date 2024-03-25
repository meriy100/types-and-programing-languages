module Sec4 exposing (Term(..), isnumericval, main)

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
            t2
                |> Result.Ok

        TmIF _ (TmFalse _) t2 t3 ->
            t3
                |> Result.Ok

        TmIF fi t1 t2 t3 ->
            let
                result =
                    eval1 t1
            in
            result
                |> Result.map (\t1a -> TmIF fi t1a t2 t3)

        TmSucc fi t1 ->
            let
                result =
                    eval1 t1
            in
            result
                |> Result.map (\t1a -> TmSucc fi t1a)

        TmPred _ (TmZero _) ->
            TmZero Info
                |> Result.Ok

        TmPred _ (TmSucc _ nv1) ->
            if isnumericval nv1 then
                nv1
                    |> Result.Ok

            else
                NoRuleApplies |> Result.Err

        TmPred fi t1 ->
            let
                result =
                    eval1 t1
            in
            result
                |> Result.map (\t1a -> TmPred fi t1a)

        TmIsZero _ (TmZero _) ->
            TmTrue Info
                |> Result.Ok

        TmIsZero _ (TmSucc _ nv1) ->
            if isnumericval nv1 then
                TmFalse Info
                    |> Result.Ok

            else
                NoRuleApplies
                    |> Result.Err

        TmIsZero fi t1 ->
            let
                result =
                    eval1 t1
            in
            result
                |> Result.map (\t1a -> TmIsZero fi t1a)

        _ ->
            Result.Err NoRuleApplies


source =
    TmIF Info
        (TmIsZero Info (TmSucc Info (TmZero Info)))
        (TmZero Info)
        (TmFalse Info)


main =
    H.div []
        [ H.div []
            [ source |> Debug.toString |> H.text |> List.singleton |> H.p []
            , eval1 source
                |> Result.andThen eval1
                |> Debug.toString
                |> H.text
                |> List.singleton
                |> H.p []
            ]
        ]
