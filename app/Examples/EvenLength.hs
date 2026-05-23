module Examples.EvenLength where

import Combinatorial
import Examples.BasicGraphs (clique)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies evenLength

main :: IO ()
main = render (graphs (labels defaultVertexCount))

evenLength :: Species Vertex Graph
evenLength = unionGraphs <|> clique 2
