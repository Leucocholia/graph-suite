module Examples.UnorderedBinaryTrees where

import Combinatorial
import Data.List (sort)
import GraphRenderer

data Tree
  = Empty
  | Node Vertex Tree Tree
  deriving (Eq, Ord, Show)

graphs :: Int -> [Graph]
graphs n = unorderedBinaryTrees (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

unorderedBinaryTrees :: Species Vertex Graph
unorderedBinaryTrees vertices =
  [ directedGraph vertices (treeEdges tree)
  | tree <- binaryTrees vertices
  ]

binaryTrees :: Species Vertex Tree
binaryTrees [] = [Empty]
binaryTrees (root:children) =
  [ Node root left right
  | (leftVertices, rightVertices) <- canonicalSplits children
  , left <- binaryTrees leftVertices
  , right <- binaryTrees rightVertices
  , length leftVertices < length rightVertices || shapeKey left <= shapeKey right
  ]

canonicalSplits :: [Vertex] -> [([Vertex], [Vertex])]
canonicalSplits vertices =
  [ splitAt leftSize vertices
  | leftSize <- [0 .. length vertices `div` 2]
  ]

shapeKey :: Tree -> String
shapeKey Empty = "."
shapeKey (Node _ left right) = "(" ++ shapeKey left ++ shapeKey right ++ ")"

treeEdges :: Tree -> [Edge]
treeEdges = sort . go
  where
    go Empty = []
    go (Node root left right) =
      childEdges root left ++ childEdges root right ++ go left ++ go right

childEdges :: Vertex -> Tree -> [Edge]
childEdges _ Empty = []
childEdges parent (Node child _ _) = [(parent, child)]
