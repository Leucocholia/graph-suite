import Combinatorial
import qualified Examples.BasicGraphs as BasicGraphs
import qualified Examples.BinomialCoefficients as BinomialCoefficients
import qualified Examples.CatalanTriangulations as CatalanTriangulations
import qualified Examples.ConnectedGraphs as ConnectedGraphs
import qualified Examples.Equivalence as Equivalence
import qualified Examples.Fibonacci as Fibonacci
import qualified Examples.IntegerPartitions as IntegerPartitions
import qualified Examples.MotzkinGraphs as MotzkinGraphs
import qualified Examples.NumbersUpToN as NumbersUpToN
import qualified Examples.OrderedBinaryTrees as OrderedBinaryTrees
import qualified Examples.PowersOfTwo as PowersOfTwo
import qualified Examples.Sandbox as Sandbox
import qualified Examples.SimpleGraphs as SimpleGraphs
import qualified Examples.TotalOrders as TotalOrders
import qualified Examples.TotalOrdersHasse as TotalOrdersHasse
import qualified Examples.UnlabelledConnectedGraphs as UnlabelledConnectedGraphs
import qualified Examples.UnlabelledSimpleGraphs as UnlabelledSimpleGraphs
import qualified Examples.UnorderedBinaryTrees as UnorderedBinaryTrees
import GraphRenderer

programs :: [(String, Int -> [Graph])]
programs =
  [ ("basicGraphs", BasicGraphs.graphs)
  , ("numbersUpToN", NumbersUpToN.graphs)
  , ("powersOfTwo", PowersOfTwo.graphs)
  , ("binomialCoefficients", BinomialCoefficients.graphs)
  , ("fibonacci", Fibonacci.graphs)
  , ("totalOrders", TotalOrders.graphs)
  , ("totalOrdersHasse", TotalOrdersHasse.graphs)
  , ("equivalence", Equivalence.graphs)
  , ("integerPartitions", IntegerPartitions.graphs)
  , ("orderedBinaryTrees", OrderedBinaryTrees.graphs)
  , ("catalanTriangulations", CatalanTriangulations.graphs)
  , ("motzkinGraphs", MotzkinGraphs.graphs)
  , ("unorderedBinaryTrees", UnorderedBinaryTrees.graphs)
  , ("simpleGraphs", SimpleGraphs.graphs)
  , ("connectedGraphs", ConnectedGraphs.graphs)
  , ("unlabelledSimpleGraphs", UnlabelledSimpleGraphs.graphs)
  , ("unlabelledConnectedGraphs", UnlabelledConnectedGraphs.graphs)
  , ("sandbox", Sandbox.graphs)
  ]

selectedProgram :: String
selectedProgram = "sandbox"

main :: IO ()
main =
  case lookup selectedProgram programs of
    Just graphList -> render (graphList defaultVertexCount)
    Nothing -> error ("Unknown selectedProgram: " ++ selectedProgram)
