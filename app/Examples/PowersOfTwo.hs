module Examples.PowersOfTwo where

import Combinatorial
import Examples.BasicGraphs (complete, empty)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies powersOfTwo

main :: IO ()
main = render (graphs (labels defaultVertexCount))

powersOfTwo :: Species Vertex Graph
powersOfTwo = complete * empty
