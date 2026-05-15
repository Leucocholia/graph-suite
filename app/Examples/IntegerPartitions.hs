module Examples.IntegerPartitions where

import Combinatorial
import Examples.BasicGraphs (indiscrete)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = integerPartitions (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

integerPartitions :: Species Vertex Graph
integerPartitions = integerPartitionSpeciesWith unionGraphs indiscrete
