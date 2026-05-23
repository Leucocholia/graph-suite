module Examples.BinomialCoefficients where

import Combinatorial
import Examples.BasicGraphs (complete, empty)
import GraphRenderer

chosenSize :: Int
chosenSize = 2

graphs :: [Vertex] -> [Graph]
graphs = runSpecies (binomialCoefficient chosenSize)

main :: IO ()
main = render (graphs (labels defaultVertexCount))

binomialCoefficient :: Int -> Species Vertex Graph
binomialCoefficient k = empty * choose k complete
