module Examples.TotalOrders where

import Combinatorial
import Data.List (sort)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies totalOrders

hasseGraphs :: [Vertex] -> [Graph]
hasseGraphs = runSpecies totalOrderHasseDiagrams

main :: IO ()
main = render (graphs (labels defaultVertexCount))

totalOrders :: Species Vertex Graph
totalOrders = permutationSpeciesWith totalOrderGraph

totalOrderHasseDiagrams :: Species Vertex Graph
totalOrderHasseDiagrams = permutationSpeciesWith hasseOrderGraph

totalOrderGraph :: [Vertex] -> Graph
totalOrderGraph order = directedGraph order (orderEdges order)

hasseOrderGraph :: [Vertex] -> Graph
hasseOrderGraph order = directedGraph order (coverEdges order)

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
