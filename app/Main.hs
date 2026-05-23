import Combinatorial
import qualified Examples.BasicGraphs as BasicGraphs
import qualified Examples.BinomialCoefficients as BinomialCoefficients
import qualified Examples.BinomialCoefficientSums as BinomialCoefficientSums
import qualified Examples.EvenLength as EvenLength
import qualified Examples.Fibonacci as Fibonacci
import qualified Examples.NumbersUpToN as NumbersUpToN
import qualified Examples.PowersOfTwo as PowersOfTwo
import qualified Examples.Factorial as Factorial
import qualified Examples.Sandbox as Sandbox
import qualified Examples.UpToHidden as UpToHidden
import GraphRenderer

programs :: [(String, IO ())]
programs =
  [ ("basicGraphs", render (BasicGraphs.graphs defaultVertices))
  , ("numbersUpToN", render (NumbersUpToN.graphs defaultVertices))
  , ("upToHidden", render (UpToHidden.graphs defaultVertices))
  , ("powersOfTwo", render (PowersOfTwo.graphs defaultVertices))
  , ("binomialCoefficients", render (BinomialCoefficients.graphs defaultVertices))
  , ("binomialCoefficientSums", render (BinomialCoefficientSums.graphs defaultVertices))
  , ("evenLength", render (EvenLength.graphs defaultVertices))
  , ("fibonacci", render (Fibonacci.graphs defaultVertices))
  , ("factorial", render (Factorial.graphs defaultVertices))
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
