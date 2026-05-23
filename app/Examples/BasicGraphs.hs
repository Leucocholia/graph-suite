{-# LANGUAGE FlexibleInstances #-}

module Examples.BasicGraphs where

import Combinatorial
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies complete

main :: IO ()
main = render (graphs (labels defaultVertexCount))

class AsVertices a where
  asVertices :: a -> [Vertex]
  acceptsAtoms :: [a] -> Bool
  acceptsAtoms _ = True

instance AsVertices Vertex where
  asVertices vertex = [vertex]

instance AsVertices [Vertex] where
  asVertices = id
  acceptsAtoms atoms = length atoms == 1

hidden :: AsVertices a => Species a Graph
hidden =
  Species $ \_ -> [directedGraph [] []]

complete :: AsVertices a => Species a Graph
complete = graphWith completeEdges

reflexiveComplete :: AsVertices a => Species a Graph
reflexiveComplete = graphWith reflexiveCompleteEdges

empty :: AsVertices a => Species a Graph
empty = graphWith (const [])

linear :: AsVertices a => Species a Graph
linear = graphWith pathEdges

cyclic :: AsVertices a => Species a Graph
cyclic = graphWith cycleEdges

clique :: AsVertices a => Int -> Species a Graph
clique n =
  speciesWithEmptySupport support $ \atoms ->
    let vertices = concatMap asVertices atoms
    in
      if length vertices == n
      then runSpecies complete atoms
      else []
  where
    support
      | n > 0 = RejectsEmptyLabels
      | otherwise = UnknownEmptyLabels

reflexiveClique :: AsVertices a => Int -> Species a Graph
reflexiveClique n =
  speciesWithEmptySupport support $ \atoms ->
    let vertices = concatMap asVertices atoms
    in
      if length vertices == n
      then runSpecies reflexiveComplete atoms
      else []
  where
    support
      | n > 0 = RejectsEmptyLabels
      | otherwise = UnknownEmptyLabels

graphWith :: AsVertices a => ([Vertex] -> [Edge]) -> Species a Graph
graphWith edgePattern =
  Species $ \atoms ->
    let vertices = concatMap asVertices atoms
    in
      [ directedGraph vertices (edgePattern vertices)
      | acceptsAtoms atoms
      ]

completeEdges :: [Vertex] -> [Edge]
completeEdges vertices =
  [ (a, b)
  | a <- vertices
  , b <- vertices
  , a /= b
  ]

reflexiveCompleteEdges :: [Vertex] -> [Edge]
reflexiveCompleteEdges vertices =
  [ (a, b)
  | a <- vertices
  , b <- vertices
  ]

pathEdges :: [Vertex] -> [Edge]
pathEdges vertices = zip vertices (tail vertices)

cycleEdges :: [Vertex] -> [Edge]
cycleEdges [] = []
cycleEdges vertices = zip vertices (tail vertices ++ [head vertices])
