module Examples.BinomialCoefficients where

import Combinatorial
import Examples.BasicGraphs (discrete, indiscrete)
import GraphRenderer

chosenSize :: Int
chosenSize = 2

graphs :: Int -> [Graph]
graphs n = binomialCoefficient chosenSize (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

binomialCoefficient :: Int -> Species Vertex Graph
binomialCoefficient k =
  productSpeciesWith unionTwoGraphs discrete (onNLabels k indiscrete)
