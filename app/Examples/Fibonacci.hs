module Examples.Fibonacci where

import Combinatorial
import Examples.BasicGraphs (complete)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies fibonacciTilings

main :: IO ()
main = render (graphs (labels defaultVertexCount))

fibonacciTilings :: Species Vertex Graph
fibonacciTilings = unionGraphs <|> tile

tile :: Species Vertex Graph
tile =
  onTupleN 1 complete + onTupleN 2 complete
