module Examples.OrderedBinaryTrees where

import Combinatorial
import Data.List (sort)
import GraphRenderer

data Tree
  = Empty
  | Node Vertex Tree Tree
  deriving (Eq, Ord, Show)

data Branch = LeftChild | RightChild

graphs :: Int -> [Graph]
graphs n = orderedBinaryTrees (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

orderedBinaryTrees :: OrderedSpecies Vertex Graph
orderedBinaryTrees vertices =
  [ directedGraph vertices (treeEdges tree)
  | tree <- binaryTrees vertices
  ]

binaryTrees :: OrderedSpecies Vertex Tree
binaryTrees [] = [Empty]
binaryTrees (root:children) =
  [ Node root left right
  | (leftVertices, rightVertices) <- orderedCuts children
  , left <- binaryTrees leftVertices
  , right <- binaryTrees rightVertices
  ]

treeEdges :: Tree -> [Edge]
treeEdges = sort . go
  where
    go Empty = []
    go (Node root left right) =
      childEdges LeftChild root left ++ childEdges RightChild root right ++ go left ++ go right

childEdges :: Branch -> Vertex -> Tree -> [Edge]
childEdges _ _ Empty = []
childEdges branch parent (Node child _ _) =
  case branch of
    LeftChild -> [(parent, child)]
    RightChild -> [(child, parent)]
