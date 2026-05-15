module Examples.NumbersUpToN where

import Combinatorial
import Examples.BasicGraphs (discrete, indiscrete)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = numbersUpTo (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

numbersUpTo :: Species Vertex Graph
numbersUpTo = productOrderedSpeciesWith unionTwoGraphs indiscrete discrete
