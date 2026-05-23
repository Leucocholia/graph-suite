module Examples.BinomialCoefficientSums where

import Combinatorial
import Examples.BasicGraphs (complete, empty)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies binomialCoefficientSums

main :: IO ()
main = render (graphs (labels defaultVertexCount))

binomialCoefficientSums :: Species Vertex Graph
binomialCoefficientSums =
  binomialTerm 0 +
    binomialTerm 1 +
    binomialTerm 2 +
    binomialTerm 3

binomialTerm :: Int -> Species Vertex Graph
binomialTerm k = empty * choose k complete
