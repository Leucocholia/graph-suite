module Examples.ConnectedGraphs where

import Combinatorial
import Examples.SimpleGraphs (connectedSimpleGraphs)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies connectedSimpleGraphs

main :: IO ()
main = render (graphs (labels defaultVertexCount))
