module Examples.BinomialLatticePaths where

import Combinatorial
import GraphRenderer

graphs :: [LatticePoint] -> [LatticePath]
graphs = latticeTargets binomialLatticePaths

main :: IO ()
main = render (graphs [(defaultVertexCount, 2)])

binomialLatticePaths :: Int -> Int -> [LatticePath]
binomialLatticePaths = latticePathsUsing [east, north]
