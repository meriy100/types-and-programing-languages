module Sec10 exposing (..)

import Array
import Html as H


type Term
    = None


view source =
    H.div []
        [ source |> Debug.toString |> H.text |> List.singleton |> H.p []
        , source
            |> Debug.toString
            |> (++) "#=> "
            |> H.text
            |> List.singleton
            |> H.p []
        ]


main =
    H.div []
        [ []
            |> List.map view
            |> H.div []
        ]
