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


source1 : Term
source1 =
    TmAbs Info "s" (TmAbs Info "z" (TmVar Info 0 2))


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
        [ [ source1, source2, source3 ]
            |> List.map view
            |> H.div []
        ]
