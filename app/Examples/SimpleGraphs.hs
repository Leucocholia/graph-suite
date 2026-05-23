module Examples.SimpleGraphs where

import Combinatorial
import Data.List (permutations, sort)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies simpleGraphs

main :: IO ()
main = render (graphs (labels defaultVertexCount))

simpleGraphs :: Species Vertex Graph
simpleGraphs = edgeSet undirectedPairs

connectedSimpleGraphs :: Species Vertex Graph
connectedSimpleGraphs = filterSpecies connectedGraph simpleGraphs

unlabelledSimpleGraphs :: Species Vertex Graph
unlabelledSimpleGraphs = unlabelledSpeciesBy canonicalSimpleGraphKey simpleGraphs

unlabelledConnectedSimpleGraphs :: Species Vertex Graph
unlabelledConnectedSimpleGraphs =
  unlabelledSpeciesBy canonicalSimpleGraphKey connectedSimpleGraphs

edgeSet :: ([Vertex] -> [Edge]) -> Species Vertex Graph
edgeSet candidateEdges =
  Species $ \vertices ->
    [ undirectedGraph vertices chosen
    | chosen <- edgeSubsets (candidateEdges vertices)
    ]

connectedGraph :: Graph -> Bool
connectedGraph graphValue =
  connectedByEdges (graphVertices graphValue) (graphEdges graphValue)

edgeSubsets :: [Edge] -> [[Edge]]
edgeSubsets [] = [[]]
edgeSubsets (edge:rest) = restSubsets ++ map (edge :) restSubsets
  where
    restSubsets = edgeSubsets rest

connectedByEdges :: [Vertex] -> [Edge] -> Bool
connectedByEdges [] _ = False
connectedByEdges vertices@(start:_) edges =
  sort (visit [start] []) == sort vertices
  where
    visit [] seen = seen
    visit (vertex:frontier) seen
      | vertex `elem` seen = visit frontier seen
      | otherwise = visit (neighbors vertex ++ frontier) (vertex : seen)

    neighbors vertex =
      [ b | (a, b) <- edges, a == vertex ]
        ++ [ a | (a, b) <- edges, b == vertex ]

canonicalSimpleGraphKey :: Graph -> String
canonicalSimpleGraphKey graphValue =
  minimum
    [ adjacencyKey order
    | order <- permutations [0 .. vertexCount - 1]
    ]
  where
    vertices = graphVertices graphValue
    vertexCount = length vertices
    indexedVertices = zip vertices [0 ..]
    edgeIndices =
      dedupeOn id
        [ normalize (leftIndex, rightIndex)
        | (a, b) <- graphEdges graphValue
        , a /= b
        , Just leftIndex <- [lookup a indexedVertices]
        , Just rightIndex <- [lookup b indexedVertices]
        ]

    adjacencyKey order =
      [ if normalize (order !! left, order !! right) `elem` edgeIndices
        then '1'
        else '0'
      | left <- [0 .. vertexCount - 1]
      , right <- [left + 1 .. vertexCount - 1]
      ]

normalize :: (Int, Int) -> (Int, Int)
normalize (a, b)
  | a <= b = (a, b)
  | otherwise = (b, a)
