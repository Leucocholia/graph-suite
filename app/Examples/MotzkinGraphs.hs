module Examples.MotzkinGraphs where

import Combinatorial
import Data.List (sort)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies motzkinGraphs

main :: IO ()
main = render (graphs (labels defaultVertexCount))

motzkinGraphs :: CyclicSpecies Vertex Graph
motzkinGraphs = noncrossingMatchingsDrawnWith noncrossingMatchings

noncrossingMatchingsDrawnWith :: ([Vertex] -> [[Edge]]) -> CyclicSpecies Vertex Graph
noncrossingMatchingsDrawnWith matchingsOf =
  Species $ \vertices ->
    [ undirectedGraph vertices matching
    | matching <- matchingsOf vertices
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
