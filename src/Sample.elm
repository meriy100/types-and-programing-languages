module Sample exposing (..)

import Html as H


type alias Nat =
    Int


type OptionalNat
    = Some Nat
    | None


type alias Table =
    Nat -> OptionalNat


emptyTable : Table
emptyTable =
    \_ -> None


extendTable : Table -> Nat -> Nat -> Table
extendTable t m v =
    \n ->
        if n == m then
            Some v

        else
            t n


find : Table -> Nat -> Nat
find t n =
    case t n of
        Some v ->
            v

        None ->
            999


table =
    extendTable (extendTable emptyTable 5 42) 6 43


main =
    H.div []
        [ H.div []
            [ find table 5 |> String.fromInt |> H.text
            ]
        ]
