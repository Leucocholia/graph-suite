module GraphRenderer
  ( defaultVertexCount
  , render
  ) where

import Combinatorial
import Control.Exception (IOException, catch)
import Data.List (intercalate)
import System.Environment (lookupEnv)
import System.IO (Handle, IOMode (WriteMode), hPutStrLn, stdout, withFile)

defaultVertexCount :: Int
defaultVertexCount = 6

class Renderable a where
  renderJsonLine :: Int -> a -> String

instance Renderable Graph where
  renderJsonLine = graphJsonLine

instance Renderable LatticePath where
  renderJsonLine = latticePathJsonLine

render :: Renderable a => [a] -> IO ()
render values = do
  destination <- lookupEnv "GRAPH_SUITE_FRAMES_PATH"
  case destination of
    Just "-" -> do
      _ <- writeValuesToHandle stdout values
      pure ()
    _ -> do
      let path = maybe "app/frames.jsonl" id destination
      report <- writeValuesReport path values `catch` fallback values
      putStrLn report
  where
    fallback :: Renderable a => [a] -> IOException -> IO String
    fallback fallbackValues _ = writeValuesReport "frames.jsonl" fallbackValues

writeValuesReport :: Renderable a => FilePath -> [a] -> IO String
writeValuesReport path values = do
  count <- writeValues path values
  pure ("Wrote " ++ show count ++ " frame(s) to " ++ path)

writeValues :: Renderable a => FilePath -> [a] -> IO Int
writeValues path values = withFile path WriteMode $ \handle -> writeValuesToHandle handle values

writeValuesToHandle :: Renderable a => Handle -> [a] -> IO Int
writeValuesToHandle handle values = go 1 values
  where
    go :: Renderable a => Int -> [a] -> IO Int
    go index [] = pure (index - 1)
    go index (value:rest) = do
      hPutStrLn handle (renderJsonLine index value)
      go (index + 1) rest

edgeJson :: Edge -> String
edgeJson (a, b) = "[" ++ show a ++ "," ++ show b ++ "]"

vertexJson :: Vertex -> String
vertexJson vertex = show vertex

latticePointJson :: LatticePoint -> String
latticePointJson (x, y) = "[" ++ show x ++ "," ++ show y ++ "]"

graphJsonLine :: Int -> Graph -> String
graphJsonLine index graphValue =
  "{\"i\":" ++ show index
    ++ ",\"v\":[" ++ intercalate "," (map vertexJson (graphVertices graphValue)) ++ "]"
    ++ ",\"e\":[" ++ intercalate "," (map edgeJson (graphEdges graphValue)) ++ "]}"

latticePathJsonLine :: Int -> LatticePath -> String
latticePathJsonLine index pathValue =
  "{\"i\":" ++ show index
    ++ ",\"kind\":\"latticePath\""
    ++ ",\"p\":[" ++ intercalate "," (map latticePointJson (latticePathPoints pathValue)) ++ "]}"
