import Combinatorial
import qualified Examples.BasicGraphs as BasicGraphs
import qualified Examples.BinomialCoefficients as BinomialCoefficients
import qualified Examples.ConnectedGraphs as ConnectedGraphs
import qualified Examples.Equivalence as Equivalence
import qualified Examples.EvenLength as EvenLength
import qualified Examples.Fibonacci as Fibonacci
import qualified Examples.IntegerPartitions as IntegerPartitions
import qualified Examples.MotzkinGraphs as MotzkinGraphs
import qualified Examples.NumbersUpToN as NumbersUpToN
import qualified Examples.OrderedBinaryTrees as OrderedBinaryTrees
import qualified Examples.PowersOfTwo as PowersOfTwo
import qualified Examples.RecursiveTotalOrders as RecursiveTotalOrders
import qualified Examples.Sandbox as Sandbox
import qualified Examples.SimpleGraphs as SimpleGraphs
import qualified Examples.UnlabelledConnectedGraphs as UnlabelledConnectedGraphs
import qualified Examples.UnlabelledSimpleGraphs as UnlabelledSimpleGraphs
import qualified Examples.UpToHidden as UpToHidden
import qualified Examples.UnorderedBinaryTrees as UnorderedBinaryTrees
import GraphRenderer

programs :: [(String, IO ())]
programs =
  [ ("basicGraphs", render (BasicGraphs.graphs defaultVertices))
  , ("numbersUpToN", render (NumbersUpToN.graphs defaultVertices))
  , ("upToHidden", render (UpToHidden.graphs defaultVertices))
  , ("powersOfTwo", render (PowersOfTwo.graphs defaultVertices))
  , ("binomialCoefficients", render (BinomialCoefficients.graphs defaultVertices))
  , ("evenLength", render (EvenLength.graphs defaultVertices))
  , ("fibonacci", render (Fibonacci.graphs defaultVertices))
  , ("recursiveTotalOrders", render (RecursiveTotalOrders.graphs defaultVertices))
  , ("equivalence", render (Equivalence.graphs defaultVertices))
  , ("integerPartitions", render (IntegerPartitions.graphs defaultVertices))
  , ("orderedBinaryTrees", render (OrderedBinaryTrees.graphs defaultVertices))
  , ("motzkinGraphs", render (MotzkinGraphs.graphs defaultVertices))
  , ("unorderedBinaryTrees", render (UnorderedBinaryTrees.graphs defaultVertices))
  , ("simpleGraphs", render (SimpleGraphs.graphs defaultVertices))
  , ("connectedGraphs", render (ConnectedGraphs.graphs defaultVertices))
  , ("unlabelledSimpleGraphs", render (UnlabelledSimpleGraphs.graphs defaultVertices))
  , ("unlabelledConnectedGraphs", render (UnlabelledConnectedGraphs.graphs defaultVertices))
  , ("sandbox", render (Sandbox.graphs defaultVertices))
  ]

defaultVertices :: [Vertex]
defaultVertices = labels defaultVertexCount

selectedProgram :: String
selectedProgram = "sandbox"

main :: IO ()
main =
  case lookup selectedProgram programs of
    Just renderProgram -> renderProgram
    Nothing -> error ("Unknown selectedProgram: " ++ selectedProgram)
