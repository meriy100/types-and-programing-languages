module Sec7 exposing (..)

import Html as H


type Term
    = None


source : Term
source =
    None


main =
    H.div []
        [ H.div []
            [ source |> Debug.toString |> H.text |> List.singleton |> H.p []
            , source
                |> Debug.toString
                |> H.text
                |> List.singleton
                |> H.p []
            ]
        ]
