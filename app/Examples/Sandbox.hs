module Examples.Sandbox where

import Combinatorial
import Examples.BasicGraphs (empty)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies sandbox

main :: IO ()
main = render (graphs (labels defaultVertexCount))

sandbox :: Species Vertex Graph
sandbox = empty
