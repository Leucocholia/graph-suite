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

render :: [Graph] -> IO ()
render graphs = do
  destination <- lookupEnv "GRAPH_SUITE_FRAMES_PATH"
  case destination of
    Just "-" -> do
      _ <- writeGraphsToHandle stdout graphs
      pure ()
    _ -> do
      let path = maybe "app/frames.jsonl" id destination
      report <- writeGraphsReport path graphs `catch` fallback graphs
      putStrLn report
  where
    fallback :: [Graph] -> IOException -> IO String
    fallback fallbackGraphs _ = writeGraphsReport "frames.jsonl" fallbackGraphs

writeGraphsReport :: FilePath -> [Graph] -> IO String
writeGraphsReport path graphs = do
  count <- writeGraphs path graphs
  pure ("Wrote " ++ show count ++ " graph frame(s) to " ++ path)

writeGraphs :: FilePath -> [Graph] -> IO Int
writeGraphs path graphs = withFile path WriteMode $ \handle -> writeGraphsToHandle handle graphs

writeGraphsToHandle :: Handle -> [Graph] -> IO Int
writeGraphsToHandle handle graphs = go 1 graphs
  where
    go :: Int -> [Graph] -> IO Int
    go index [] = pure (index - 1)
    go index (graphValue:rest) = do
      hPutStrLn handle (graphJsonLine index graphValue)
      go (index + 1) rest

edgeJson :: Edge -> String
edgeJson (a, b) = "[" ++ show a ++ "," ++ show b ++ "]"

vertexJson :: Vertex -> String
vertexJson vertex = show vertex

graphJsonLine :: Int -> Graph -> String
graphJsonLine index graphValue =
  "{\"i\":" ++ show index
    ++ ",\"v\":[" ++ intercalate "," (map vertexJson (graphVertices graphValue)) ++ "]"
    ++ ",\"e\":[" ++ intercalate "," (map edgeJson (graphEdges graphValue)) ++ "]}"
