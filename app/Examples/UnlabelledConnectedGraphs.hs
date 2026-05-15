module Examples.UnlabelledConnectedGraphs where

import Combinatorial
import Examples.SimpleGraphs (unlabelledConnectedSimpleGraphs)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = unlabelledConnectedSimpleGraphs (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)
