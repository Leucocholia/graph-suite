module Examples.OrderedBinaryTrees where

import Combinatorial
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies orderedBinaryTrees

main :: IO ()
main = render (graphs (labels defaultVertexCount))

orderedBinaryTrees :: Species Vertex Graph
orderedBinaryTrees = orderedBinaryTreeGraphs

binaryTrees :: Species Vertex Tree
binaryTrees = orderedBinaryTreeSpecies
