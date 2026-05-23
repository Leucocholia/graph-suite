module Examples.UnlabelledConnectedGraphs where

import Combinatorial
import Examples.SimpleGraphs (unlabelledConnectedSimpleGraphs)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies unlabelledConnectedSimpleGraphs

main :: IO ()
main = render (graphs (labels defaultVertexCount))
