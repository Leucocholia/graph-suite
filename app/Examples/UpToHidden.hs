module Examples.UpToHidden where

import Combinatorial
import Examples.BasicGraphs (hidden)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies connectedUpTo

main :: IO ()
main = render (graphs (labels defaultVertexCount))

connectedUpTo :: Species Vertex Graph
connectedUpTo = connected *|* hidden
