module Examples.PowersOfTwo where

import Combinatorial
import Examples.BasicGraphs (discrete, indiscrete)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = powersOfTwo (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

powersOfTwo :: Species Vertex Graph
powersOfTwo = productSpeciesWith unionTwoGraphs indiscrete discrete
