module Examples.UnlabelledSimpleGraphs where

import Combinatorial
import Examples.SimpleGraphs (unlabelledSimpleGraphs)
import GraphRenderer

graphs :: Int -> [Graph]
graphs n = unlabelledSimpleGraphs (labels n)

main :: IO ()
main = render (graphs defaultVertexCount)
