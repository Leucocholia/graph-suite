module Examples.ConnectedGraphs where

import Combinatorial
import Examples.SimpleGraphs (connectedSimpleGraphs)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = connectedSimpleGraphs (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)
