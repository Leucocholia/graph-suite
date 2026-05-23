module Examples.NumbersUpToN where

import Combinatorial
import Examples.BasicGraphs (complete, empty)
import GraphRenderer

graphs :: [Vertex] -> [Graph]
graphs = runSpecies numbersUpTo

main :: IO ()
main = render (graphs (labels defaultVertexCount))

numbersUpTo :: Species Vertex Graph
numbersUpTo = complete *|* empty
