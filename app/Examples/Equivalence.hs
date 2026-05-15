module Examples.Equivalence where

import Combinatorial
import Examples.BasicGraphs (indiscrete)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = equivalenceRelations (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

equivalenceRelations :: Species Vertex Graph
equivalenceRelations = composeSpecies unionGraphs indiscrete
