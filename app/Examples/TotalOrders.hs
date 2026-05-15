module Examples.TotalOrders where

import Combinatorial
import Data.List (permutations, sort)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = totalOrders (labels n)

hasseGraphs :: Int -> [Graph]
hasseGraphs n = totalOrderHasseDiagrams (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

totalOrders :: Species Vertex Graph
totalOrders vertices =
  [ directedGraph vertices (orderEdges order)
  | order <- permutations vertices
  ]

totalOrderHasseDiagrams :: Species Vertex Graph
totalOrderHasseDiagrams vertices =
  [ directedGraph vertices (coverEdges order)
  | order <- permutations vertices
  ]

orderEdges :: [Vertex] -> [Edge]
orderEdges order =
  sort
    [ (a, b)
    | (a:after) <- suffixes order
    , b <- after
    ]

coverEdges :: [Vertex] -> [Edge]
coverEdges order = zip order (drop 1 order)

suffixes :: [a] -> [[a]]
suffixes [] = []
suffixes xs@(_:rest) = xs : suffixes rest
