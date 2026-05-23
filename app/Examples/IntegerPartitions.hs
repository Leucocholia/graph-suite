module Examples.IntegerPartitions where

import Combinatorial
import Examples.BasicGraphs (complete)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies integerPartitions

main :: IO ()
main = render (graphs (labels defaultVertexCount))

integerPartitions :: Species Vertex Graph
integerPartitions = integerPartsOf complete
