{-# LANGUAGE FlexibleInstances #-}

module Examples.BasicGraphs where

import Combinatorial
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = indiscrete (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)

class AsVertices a where
  asVertices :: a -> [Vertex]
  acceptsAtoms :: [a] -> Bool
  acceptsAtoms _ = True

instance AsVertices Vertex where
  asVertices vertex = [vertex]

instance AsVertices [Vertex] where
  asVertices = id
  acceptsAtoms atoms = length atoms == 1

indiscrete :: AsVertices a => Species a Graph
indiscrete atoms =
  [ directedGraph vertices edges
  | acceptsAtoms atoms
  ]
  where
    vertices = concatMap asVertices atoms
    edges =
      [ (a, b)
      | a <- vertices
      , b <- vertices
      , a /= b
      ]

discrete :: AsVertices a => Species a Graph
discrete atoms =
  [ directedGraph vertices []
  | acceptsAtoms atoms
  ]
  where
    vertices = concatMap asVertices atoms

-- hasse :: Graph -> Graph
-- hasse vertices =
--   [ directedGraph vertices edges ]
--   where
--     edges =
--       [ (a, b)
--       | a <- vertices
--       , b <- vertices
--       , a /= b
--       ]
