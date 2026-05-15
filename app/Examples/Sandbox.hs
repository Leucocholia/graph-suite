module Examples.Sandbox where

import Combinatorial
import Examples.BasicGraphs (discrete)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = sandbox (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

sandbox :: Species Vertex Graph
sandbox = discrete
