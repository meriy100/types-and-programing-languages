module sample exposing (..)

type A =
     B String
     | D String

f : A -> String
f a =
    case a of
        B s -> s
        C n -> "Int"

main =
    f (B "Hello")