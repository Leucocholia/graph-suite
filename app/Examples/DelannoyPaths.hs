module Examples.DelannoyPaths where

import Combinatorial
import GraphRenderer

graphs :: [LatticePoint] -> [LatticePath]
graphs = latticeTargets delannoyPaths

main :: IO ()
main = render (graphs [(defaultVertexCount, 2)])

delannoyPaths :: Int -> Int -> [LatticePath]
delannoyPaths = latticePathsUsing [east, north, diagonal]
