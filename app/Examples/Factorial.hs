module Examples.Factorial where

import Prelude hiding ((*>))
import Combinatorial
import Examples.BasicGraphs (clique)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies output

main :: IO ()
main = render (graphs (labels defaultVertexCount))

output :: Species Vertex Graph
output = clique 1 + ((clique 1 *> joinTwo) output)

factorial :: Species Vertex Graph
factorial = output
