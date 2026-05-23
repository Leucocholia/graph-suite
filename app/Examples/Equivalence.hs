module Examples.Equivalence where

import Combinatorial
import Examples.BasicGraphs (complete)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies equivalenceRelations

main :: IO ()
main = render (graphs (labels defaultVertexCount))

equivalenceRelations :: Species Vertex Graph
equivalenceRelations = unionGraphs <@> complete
