module Sec7 exposing (..)

import Array
import Html as H


type Info
    = Info


type Binding
    = NameBind
    | None


type alias Context =
    List ( String, Binding )


type Term
    = TmVar Info Int Int
    | TmAbs Info String Term
    | TmApp Info Term Term


pickfreshname : Context -> String -> ( Context, String )
pickfreshname ctx x =
    if List.member x (List.map Tuple.first ctx) then
        pickfreshname ctx (x ++ "'")

    else
        ( ( x, NameBind ) :: ctx
        , x
        )


printtm : Context -> Term -> String
printtm ctx t =
    case t of
        TmAbs fi x t1 ->
            let
                ( ctx1, x1 ) =
                    pickfreshname ctx x
            in
            "(lambda " ++ x1 ++ ". " ++ printtm ctx1 t1 ++ ")"

        TmApp fi t1 t2 ->
            "(" ++ printtm ctx t1 ++ " " ++ printtm ctx t2 ++ ")"

        TmVar fi x n ->
            if List.length ctx == n then
                index2name fi ctx x

            else
                "[bad index]"


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



-- Sec.7.2 シフトと代入


termShift : Int -> Term -> Term
termShift d t =
    let
        walk c td =
            case td of
                TmVar fi x n ->
                    if x >= c then
                        TmVar fi (x + d) (n + d)

                    else
                        TmVar fi x (n + d)

                TmAbs fi x t1 ->
                    TmAbs fi x (walk (c + 1) t1)

                TmApp fi t1 t2 ->
                    TmApp fi (walk c t1) (walk c t2)
    in
    walk 0 t


termSubst : Int -> Term -> Term -> Term
termSubst j s t =
    let
        walk c td =
            case td of
                TmVar fi x n ->
                    if x == j + c then
                        termShift c s

                    else
                        TmVar fi x n

                TmAbs fi x t1 ->
                    TmAbs fi x (walk (c + 1) t1)

                TmApp fi t1 t2 ->
                    TmApp fi (walk c t1) (walk c t2)
    in
    walk 0 t



-- c0 = \s. \z. z


source1 : Term
source1 =
    TmAbs Info "s" (TmAbs Info "z" (TmVar Info 0 2))



-- c1 = \s. \z. s (s z)


source2 : Term
source2 =
    TmAbs Info
        "s"
        (TmAbs Info
            "z"
            (TmApp Info
                (TmVar Info 1 2)
                (TmApp Info (TmVar Info 1 2) (TmVar Info 0 2))
            )
        )



-- plus = \m. \n. \s. \z. m s (n s z)


source3 : Term
source3 =
    TmAbs Info
        "m"
        (TmAbs Info
            "n"
            (TmAbs Info
                "s"
                (TmAbs Info
                    "z"
                    (TmApp Info
                        (TmApp Info
                            -- m
                            (TmVar Info 3 4)
                            -- s
                            (TmVar Info 1 4)
                        )
                        (TmApp Info
                            (TmApp Info
                                -- n
                                (TmVar Info 2 4)
                                -- s
                                (TmVar Info 1 4)
                            )
                            -- z
                            (TmVar Info 0 4)
                        )
                    )
                )
            )
        )



-- fix = \f. (\x. f (\y. x x y)) (\x. f (\y. x x y))


source4 : Term
source4 =
    TmAbs Info
        "f"
        (TmApp Info
            (TmAbs Info
                "x"
                (TmApp Info
                    -- f
                    (TmVar Info 1 2)
                    (TmAbs Info
                        "y"
                        (TmApp Info
                            (TmApp Info
                                -- x
                                (TmVar Info 1 3)
                                -- x
                                (TmVar Info 1 3)
                            )
                            -- y
                            (TmVar Info 0 3)
                        )
                    )
                )
            )
            (TmAbs Info
                "x"
                (TmApp Info
                    -- f
                    (TmVar Info 1 2)
                    (TmAbs Info
                        "y"
                        (TmApp Info
                            (TmApp Info
                                -- x
                                (TmVar Info 1 3)
                                -- x
                                (TmVar Info 1 3)
                            )
                            -- y
                            (TmVar Info 0 3)
                        )
                    )
                )
            )
        )



-- foo = (\x. (\x. x)) (\x. x)
-- #> ((lambda x. (lambda x'. x')) (lambda x. x))


source5 : Term
source5 =
    TmApp Info
        (TmAbs Info
            "x"
            (TmAbs Info
                "x"
                (TmVar Info 0 2)
            )
        )
        (TmAbs Info
            "x"
            (TmVar Info 0 1)
        )



-- j = -2 になる理由がわかっていない。 j は N 番目の変数の意味のはず


source11 : Term
source11 =
    termSubst -2 source1 source2


view source =
    H.div []
        [ source |> Debug.toString |> H.text |> List.singleton |> H.p []
        , source
            |> printtm []
            |> Debug.toString
            |> (++) "#=> "
            |> H.text
            |> List.singleton
            |> H.p []
        ]


main =
    H.div []
        [ [ source1, source2, source3, source4, source5, source11 ]
            |> List.map view
            |> H.div []
        ]
