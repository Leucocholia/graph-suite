module Examples.TotalOrdersHasse where

import Combinatorial
import qualified Examples.TotalOrders as TotalOrders
import GraphRenderer

graphs :: Int -> [Graph]
graphs = TotalOrders.hasseGraphs

main :: IO ()
main = render (graphs defaultVertexCount)
