module Examples.Fibonacci where

import Combinatorial
import Examples.BasicGraphs (indiscrete)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = fibonacciTilings (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

fibonacciTilings :: OrderedSpecies Vertex Graph
fibonacciTilings = composeOrderedSpecies unionGraphs tile

tile :: OrderedSpecies Vertex Graph
tile =
  sumSpecies
    (onTupleN 1 indiscrete)
    (onTupleN 2 indiscrete)
