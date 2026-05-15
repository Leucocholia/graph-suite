module Examples.CatalanTriangulations where

import Combinatorial
import Data.List (sort)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = catalanTriangulations (labels (n + 2))

main :: IO ()
main = render (graphs defaultVertexCount)

catalanTriangulations :: CyclicSpecies Vertex Graph
catalanTriangulations vertices =
  [ undirectedGraph vertices (boundaryEdges vertices ++ diagonals)
  | diagonals <- triangulationDiagonals vertices
  ]

triangulationDiagonals :: [Vertex] -> [[Edge]]
triangulationDiagonals vertices
  | length vertices <= 3 = [[]]
  | otherwise =
      [ sort (newDiagonals pivot vertices ++ leftDiagonals ++ rightDiagonals)
      | pivot <- middleVertices vertices
      , leftDiagonals <- triangulationDiagonals (leftPolygon pivot vertices)
      , rightDiagonals <- triangulationDiagonals (rightPolygon pivot vertices)
      ]

middleVertices :: [Vertex] -> [Vertex]
middleVertices vertices = init (tail vertices)

leftPolygon :: Vertex -> [Vertex] -> [Vertex]
leftPolygon pivot vertices = takeThrough pivot vertices

rightPolygon :: Vertex -> [Vertex] -> [Vertex]
rightPolygon pivot vertices = dropUntil pivot vertices

newDiagonals :: Vertex -> [Vertex] -> [Edge]
newDiagonals pivot vertices =
  filter (not . boundaryEdge vertices)
    [ undirectedEdge (head vertices, pivot)
    , undirectedEdge (pivot, last vertices)
    ]

boundaryEdges :: [Vertex] -> [Edge]
boundaryEdges [] = []
boundaryEdges [_] = []
boundaryEdges vertices = map undirectedEdge (zip vertices (tail vertices ++ [head vertices]))

boundaryEdge :: [Vertex] -> Edge -> Bool
boundaryEdge vertices edge = edge `elem` boundaryEdges vertices

takeThrough :: Eq a => a -> [a] -> [a]
takeThrough target = go
  where
    go [] = []
    go (x:xs)
      | x == target = [x]
      | otherwise = x : go xs

dropUntil :: Eq a => a -> [a] -> [a]
dropUntil _ [] = []
dropUntil target xs@(x:rest)
  | x == target = xs
  | otherwise = dropUntil target rest
