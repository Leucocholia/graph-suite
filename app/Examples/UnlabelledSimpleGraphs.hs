module Examples.UnlabelledSimpleGraphs where

import Combinatorial
import Examples.SimpleGraphs (unlabelledSimpleGraphs)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies unlabelledSimpleGraphs

main :: IO ()
main = render (graphs (labels defaultVertexCount))
