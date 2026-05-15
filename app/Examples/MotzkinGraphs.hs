module Examples.MotzkinGraphs where

import Combinatorial
import Data.List (sort)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = motzkinGraphs (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

motzkinGraphs :: CyclicSpecies Vertex Graph
motzkinGraphs vertices =
  [ undirectedGraph vertices matching
  | matching <- noncrossingMatchings vertices
  ]

noncrossingMatchings :: [Vertex] -> [[Edge]]
noncrossingMatchings [] = [[]]
noncrossingMatchings [_] = [[]]
noncrossingMatchings (first:rest) =
  isolatedFirst ++ matchedFirst
  where
    isolatedFirst = noncrossingMatchings rest
    matchedFirst =
      [ sort (undirectedEdge (first, partner) : insideEdges ++ outsideEdges)
      | (inside, partner, outside) <- choices rest
      , insideEdges <- noncrossingMatchings inside
      , outsideEdges <- noncrossingMatchings outside
      ]

choices :: [Vertex] -> [([Vertex], Vertex, [Vertex])]
choices [] = []
choices (partner:outside) = ([], partner, outside) : extend [] partner outside
  where
    extend _ _ [] = []
    extend inside current (next:after) =
      (inside ++ [current], next, after) : extend (inside ++ [current]) next after
