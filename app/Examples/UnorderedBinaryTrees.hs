module Examples.UnorderedBinaryTrees where

import Combinatorial
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies unorderedBinaryTrees

main :: IO ()
main = render (graphs (labels defaultVertexCount))

unorderedBinaryTrees :: Species Vertex Graph
unorderedBinaryTrees = unorderedBinaryTreeGraphs

binaryTrees :: Species Vertex Tree
binaryTrees = unorderedBinaryTreeSpecies
