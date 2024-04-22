module Sec11 exposing (..)

import Array
import Html as H


type Info
    = Info


type Ty
    = TyArr Ty Ty
    | TyBool
    | TyNat
    | TyUnit


type Binding
    = NameBind
    | VarBind Ty
    | None


type Error
    = Error Info String


type alias Context =
    List ( String, Binding )


addbinding : Context -> String -> Binding -> Context
addbinding ctx x bind =
    ( x, bind ) :: ctx


getBinding : Info -> Context -> Int -> Maybe Binding
getBinding fi ctx i =
    Array.fromList ctx
        |> Array.get i
        |> Maybe.map Tuple.second


getTypeFromContext : Info -> Context -> Int -> Result Error Ty
getTypeFromContext fi ctx i =
    case getBinding fi ctx i of
        Just (VarBind ty) ->
            Result.Ok ty

        _ ->
            Error fi ("getTypeFromContext: No binding for variable in context" ++ index2name fi ctx i)
                |> Result.Err


getAt : Int -> Context -> Maybe ( String, Binding )
getAt n ctx =
    Array.fromList ctx
        |> Array.get n


index2name : Info -> Context -> Int -> String
index2name fi ctx x =
    let
        ( _, b ) =
            getAt x ctx
                |> Maybe.withDefault ( "[index2name error1]", None )
    in
    case b of
        NameBind ->
            let
                ( n, _ ) =
                    getAt x ctx
                        |> Maybe.withDefault ( "[index2name error2]", None )
            in
            n

        _ ->
            "[index2name error3]"


type alias CtxIdx =
    Int


type alias CtxLng =
    Int


type Term
    = TmVar Info CtxIdx CtxLng
    | TmAbs Info String Ty Term
    | TmApp Info Term Term
    | TmTrue Info
    | TmFalse Info
    | TmIf Info Term Term Term
    | TmZero Info
    | TmSucc Info Term
    | TmPred Info Term
    | TmIsZero Info Term
    | TmUnit Info
    | TmSeq Info Term Term


typeof : Context -> Term -> Result Error Ty
typeof ctx t =
    case t of
        TmVar fi x _ ->
            getTypeFromContext fi ctx x

        TmAbs fi x tyT1 t2 ->
            let
                ctx_ =
                    addbinding ctx x (VarBind tyT1)
            in
            let
                tyT2 =
                    typeof ctx_ t2
            in
            case tyT2 of
                Result.Ok tyT2_ ->
                    Result.Ok (TyArr tyT1 tyT2_)

                Result.Err e ->
                    Result.Err e

        TmApp fi t1 t2 ->
            let
                resultTyT1 =
                    typeof ctx t1
            in
            let
                resultTyT2 =
                    typeof ctx t2
            in
            case resultTyT1 of
                Result.Ok (TyArr tyT11 tyT12) ->
                    if resultTyT2 == Result.Ok tyT11 then
                        Result.Ok tyT12

                    else
                        Error fi "parameter type mismatch"
                            |> Result.Err

                _ ->
                    Error fi "arrow type expected"
                        |> Result.Err

        TmTrue _ ->
            Result.Ok TyBool

        TmFalse _ ->
            Result.Ok TyBool

        TmIf fi t1 t2 t3 ->
            let
                resultTyT1 =
                    typeof ctx t1
            in
            let
                resultTyT2 =
                    typeof ctx t2
            in
            let
                resultTyT3 =
                    typeof ctx t3
            in
            if resultTyT1 == Result.Ok TyBool then
                if resultTyT2 == resultTyT3 then
                    resultTyT2

                else
                    Error fi "arms of conditional have different types"
                        |> Result.Err

            else
                Error fi "guard of conditional not a boolean"
                    |> Result.Err

        TmZero _ ->
            Result.Ok TyNat

        TmSucc fi t1 ->
            let
                resultTyT1 =
                    typeof ctx t1
            in
            if resultTyT1 == Result.Ok TyNat then
                Result.Ok TyNat

            else
                Error fi "argument of succ is not a number"
                    |> Result.Err

        TmPred fi t1 ->
            let
                resultTyT1 =
                    typeof ctx t1
            in
            if resultTyT1 == Result.Ok TyNat then
                Result.Ok TyNat

            else
                Error fi "argument of pred is not a number"
                    |> Result.Err

        TmIsZero fi t1 ->
            let
                resultTyT1 =
                    typeof ctx t1
            in
            if resultTyT1 == Result.Ok TyNat then
                Result.Ok TyBool

            else
                Error fi "argument of iszero is not a number"
                    |> Result.Err

        TmUnit fi ->
            Result.Ok TyUnit

        TmSeq fi t1 t2 ->
            typeof ctx t2



-- c0 = \s:Bool. \z:Bool. z


source1 : Term
source1 =
    TmAbs Info "s" TyBool (TmAbs Info "z" TyBool (TmVar Info 0 2))



-- if 1 then 1 else 0


one fi =
    TmSucc fi (TmZero fi)


source2 : Term
source2 =
    TmIf Info (one Info) (one Info) (TmZero Info)


seq : Term
seq =
    TmSeq Info source1 source2


view source =
    H.div []
        [ source |> Debug.toString |> H.text |> List.singleton |> H.p []
        , source
            |> typeof []
            |> Debug.toString
            |> (++) "#=> "
            |> H.text
            |> List.singleton
            |> H.p []
        ]


main =
    H.div []
        [ [ source1, source2 ]
            |> List.map view
            |> H.div []
        ]
