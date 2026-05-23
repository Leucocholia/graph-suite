module Examples.TotalOrdersHasse where

import Combinatorial
import qualified Examples.TotalOrders as TotalOrders
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = TotalOrders.hasseGraphs

main :: IO ()
main = render (graphs (labels defaultVertexCount))
