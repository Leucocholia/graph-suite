{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PatternSynonyms #-}

module Combinatorial where

import Prelude hiding (product, (*>))
import Data.List (permutations, sort)

type Vertex = Int
type Edge = (Vertex, Vertex)
data Graph = Graph
  { graphVertices :: [Vertex]
  , graphEdges :: [Edge]
  }
  deriving (Eq, Ord, Show)
type Block = [Vertex]
type Partition = [Block]
data EmptyLabelSupport
  = AcceptsEmptyLabels
  | RejectsEmptyLabels
  | UnknownEmptyLabels
  | FilteredEmptySupport EmptyLabelSupport
  | SumEmptySupport EmptyLabelSupport EmptyLabelSupport
  | ProductEmptySupport EmptyLabelSupport EmptyLabelSupport

data Species a b = SpeciesWithSupport
  { runSpecies :: [a] -> [b]
  , runSpeciesWithFuel :: Int -> [a] -> [b]
  , emptyLabelSupport :: EmptyLabelSupport
  }

pattern Species :: ([a] -> [b]) -> Species a b
pattern Species run <- SpeciesWithSupport run _ UnknownEmptyLabels
  where
    Species run = SpeciesWithSupport run (\_ -> run) UnknownEmptyLabels

{-# COMPLETE Species #-}

type CyclicSpecies a b = Species a b
type Shape a = Int -> [a]
type LatticePoint = (Int, Int)
data LatticePath = LatticePath
  { latticePathPoints :: [LatticePoint]
  }
  deriving (Eq, Ord, Show)
data LatticeStep
  = East
  | North
  | Diagonal
  deriving (Eq, Ord, Show)

data Tree
  = Empty
  | Node Vertex Tree Tree
  deriving (Eq, Ord, Show)

speciesWithEmptySupport :: EmptyLabelSupport -> ([a] -> [b]) -> Species a b
speciesWithEmptySupport support run = SpeciesWithSupport run (\_ -> run) support

speciesWithFuelAndEmptySupport :: EmptyLabelSupport -> (Int -> [a] -> [b]) -> Species a b
speciesWithFuelAndEmptySupport support run =
  SpeciesWithSupport (\xs -> run (speciesFuel xs) xs) run support

speciesFuel :: [a] -> Int
speciesFuel xs = length xs + 2

rejectsEmptyLabels :: Species a b -> Bool
rejectsEmptyLabels species =
  emptySupportRejects 12 (emptyLabelSupport species) == Just True

emptySupportRejects :: Int -> EmptyLabelSupport -> Maybe Bool
emptySupportRejects fuel support
  | fuel <= 0 = Nothing
  | otherwise =
      case support of
        AcceptsEmptyLabels -> Just False
        RejectsEmptyLabels -> Just True
        UnknownEmptyLabels -> Nothing
        FilteredEmptySupport inner ->
          case emptySupportRejects (fuel - 1) inner of
            Just True -> Just True
            _ -> Nothing
        SumEmptySupport left right ->
          case (emptySupportRejects (fuel - 1) left, emptySupportRejects (fuel - 1) right) of
            (Just False, _) -> Just False
            (_, Just False) -> Just False
            (Just True, Just True) -> Just True
            _ -> Nothing
        ProductEmptySupport left right ->
          case (emptySupportRejects (fuel - 1) left, emptySupportRejects (fuel - 1) right) of
            (Just True, _) -> Just True
            (_, Just True) -> Just True
            (Just False, Just False) -> Just False
            _ -> Nothing

filteredEmptySupport :: EmptyLabelSupport -> EmptyLabelSupport
filteredEmptySupport = FilteredEmptySupport

sumEmptySupport :: EmptyLabelSupport -> EmptyLabelSupport -> EmptyLabelSupport
sumEmptySupport = SumEmptySupport

productEmptySupport :: EmptyLabelSupport -> EmptyLabelSupport -> EmptyLabelSupport
productEmptySupport = ProductEmptySupport

labels :: Int -> [Vertex]
labels n = [0 .. n - 1]

latticePath :: [LatticePoint] -> LatticePath
latticePath = LatticePath

east :: LatticeStep
east = East

north :: LatticeStep
north = North

diagonal :: LatticeStep
diagonal = Diagonal

latticeTargets :: (Int -> Int -> [b]) -> [LatticePoint] -> [b]
latticeTargets pathFamily = concatMap (uncurry pathFamily)

latticePathsUsing :: [LatticeStep] -> Int -> Int -> [LatticePath]
latticePathsUsing steps width pathHeight =
  map latticePath (latticePointPathsUsing steps width pathHeight)

latticePointPathsUsing :: [LatticeStep] -> Int -> Int -> [[LatticePoint]]
latticePointPathsUsing _ 0 0 = [[(0, 0)]]
latticePointPathsUsing steps x y =
  [ path ++ [(x, y)]
  | step <- steps
  , Just (previousX, previousY) <- [latticePredecessor step x y]
  , path <- latticePointPathsUsing steps previousX previousY
  ]

latticePredecessor :: LatticeStep -> Int -> Int -> Maybe LatticePoint
latticePredecessor step x y =
  case step of
    East
      | x > 0 -> Just (x - 1, y)
    North
      | y > 0 -> Just (x, y - 1)
    Diagonal
      | x > 0 && y > 0 -> Just (x - 1, y - 1)
    _ -> Nothing

class RunnableSpecies program a b | program -> a b where
  runProgram :: program -> [a] -> [b]

instance RunnableSpecies (Species a b) a b where
  runProgram = runSpecies

instance RunnableSpecies ([a] -> [b]) a b where
  runProgram = id

directedGraph :: [Vertex] -> [Edge] -> Graph
directedGraph vertices edges = Graph (sort vertices) (sort edges)

undirectedGraph :: [Vertex] -> [Edge] -> Graph
undirectedGraph vertices edges = directedGraph vertices (bidirectedEdges edges)

bidirectedEdges :: [Edge] -> [Edge]
bidirectedEdges edges =
  sort
    [ directed
    | edge <- edges
    , directed <- edgeDirections edge
    ]

edgeDirections :: Edge -> [Edge]
edgeDirections edge =
  case undirectedEdge edge of
    (a, b)
      | a == b -> [(a, b)]
      | otherwise -> [(a, b), (b, a)]

undirectedEdge :: Edge -> Edge
undirectedEdge (a, b)
  | a <= b = (a, b)
  | otherwise = (b, a)

undirectedPairs :: [Vertex] -> [Edge]
undirectedPairs = pairs . sort
  where
    pairs [] = []
    pairs (vertex:after) = [(vertex, other) | other <- after] ++ pairs after

unionGraphList :: [Graph] -> Graph
unionGraphList graphs = directedGraph vertices edges
  where
    vertices = concatMap graphVertices graphs
    edges = concatMap graphEdges graphs

unionGraphs :: Species Graph Graph
unionGraphs = Species $ \graphs -> [unionGraphList graphs]

unionTwoGraphs :: Graph -> Graph -> Graph
unionTwoGraphs left right = unionGraphList [left, right]

instance Semigroup Graph where
  (<>) = unionTwoGraphs

instance Monoid Graph where
  mempty = directedGraph [] []

instance Num Graph where
  (+) = unionTwoGraphs
  (*) = joinTwoGraphs
  negate _ = mempty
  abs = id
  signum _ = mempty
  fromInteger n
    | n < 0 = mempty
    | otherwise = completeGraphOn (fromInteger n)

completeGraphOn :: Int -> Graph
completeGraphOn n =
  directedGraph vertices edges
  where
    vertices = labels n
    edges =
      [ (a, b)
      | a <- vertices
      , b <- vertices
      , a /= b
      ]

connected :: Species Vertex Graph
connected =
  speciesWithEmptySupport RejectsEmptyLabels $ \vertices ->
    case vertices of
      [] -> []
      _ -> [directedGraph vertices (completeEdgesOn vertices)]

completeEdgesOn :: [Vertex] -> [Edge]
completeEdgesOn vertices =
  [ (a, b)
  | a <- vertices
  , b <- vertices
  , a /= b
  ]

joinTwoGraphs :: Graph -> Graph -> Graph
joinTwoGraphs left right =
  directedGraph vertices edges
  where
    vertices = graphVertices left ++ graphVertices right
    edges = 
      graphEdges left ++ 
      graphEdges right ++ 
      [ (a, b)
      | a <- graphVertices left
      , b <- graphVertices right
      ]

hasseJoinTwoGraphs :: Graph -> Graph -> Graph
hasseJoinTwoGraphs left right =
  directedGraph vertices edges
  where
    vertices = graphVertices left ++ graphVertices right
    edges =
      graphEdges left ++
      graphEdges right ++
      [ (a, b)
      | a <- maximalVertices left
      , b <- minimalVertices right
      ]

hasseJoinOpTwoGraphs :: Graph -> Graph -> Graph
hasseJoinOpTwoGraphs left right =
  directedGraph vertices edges
  where
    vertices = graphVertices left ++ graphVertices right
    edges =
      graphEdges left ++
      graphEdges right ++
      [ (b, a)
      | a <- maximalVertices left
      , b <- minimalVertices right
      ]

minimalVertices :: Graph -> [Vertex]
minimalVertices graph =
  [ vertex
  | vertex <- graphVertices graph
  , not (hasIncomingEdge vertex)
  ]
  where
    hasIncomingEdge vertex =
      any (\(source, target) -> source /= vertex && target == vertex) (graphEdges graph)

maximalVertices :: Graph -> [Vertex]
maximalVertices graph =
  [ vertex
  | vertex <- graphVertices graph
  , not (hasOutgoingEdge vertex)
  ]
  where
    hasOutgoingEdge vertex =
      any (\(source, target) -> source == vertex && target /= vertex) (graphEdges graph)

joinGraphList :: [Graph] -> Graph
joinGraphList [] = directedGraph [] []
joinGraphList (graph:graphs) = foldr joinTwoGraphs graph graphs

joinGraphs :: Species Graph Graph
joinGraphs = Species $ \graphs -> [joinGraphList graphs]

hasseJoinGraphList :: [Graph] -> Graph
hasseJoinGraphList [] = directedGraph [] []
hasseJoinGraphList (graph:graphs) = foldr hasseJoinTwoGraphs graph graphs

hasseJoinGraphs :: Species Graph Graph
hasseJoinGraphs = Species $ \graphs -> [hasseJoinGraphList graphs]

infixl 6 <+>
(<+>) :: Graph -> Graph -> Graph
(<+>) = joinTwoGraphs

infixl 6 <++>
(<++>) :: Graph -> Graph -> Graph
(<++>) = hasseJoinTwoGraphs

idSpecies :: Species a a
idSpecies = Species id

tupleN :: Int -> Species a [a]
tupleN n =
  speciesWithEmptySupport support $ \xs ->
    if length xs == n
    then [xs]
    else []
  where
    support
      | n == 0 = AcceptsEmptyLabels
      | otherwise = RejectsEmptyLabels

onNLabels :: Int -> Species a b -> Species a b
onNLabels n species =
  speciesWithFuelAndEmptySupport support $ \fuel l ->
    if length l == n
    then runSpeciesWithFuel species fuel l
    else []
  where
    support
      | n == 0 = UnknownEmptyLabels
      | otherwise = RejectsEmptyLabels

onTupleN :: Int -> Species a b -> Species a b
onTupleN = onNLabels

choose :: Int -> Species a b -> Species a b
choose = onNLabels

onNonemptyLabels :: Species a b -> Species a b
onNonemptyLabels species =
  speciesWithFuelAndEmptySupport RejectsEmptyLabels $ \fuel l ->
    if length l > 0
    then runSpeciesWithFuel species fuel l
    else []

wholeTupleWith :: Species [a] b -> Species a b
wholeTupleWith species =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    runSpeciesWithFuel species fuel [xs]

exactTupleNWith :: Int -> Species [a] b -> Species a b
exactTupleNWith n species =
  speciesWithFuelAndEmptySupport (emptyLabelSupport (tupleN n)) $ \fuel xs ->
    concatMap (runSpeciesWithFuel (wholeTupleWith species) fuel) (runSpecies (tupleN n) xs)

mapSpecies :: (b -> c) -> Species a b -> Species a c
mapSpecies f species =
  speciesWithFuelAndEmptySupport (emptyLabelSupport species) $ \fuel xs ->
    map f (runSpeciesWithFuel species fuel xs)

filterSpecies :: (b -> Bool) -> Species a b -> Species a b
filterSpecies predicate species =
  speciesWithFuelAndEmptySupport (filteredEmptySupport (emptyLabelSupport species)) $ \fuel xs ->
    filter predicate (runSpeciesWithFuel species fuel xs)

permutationSpeciesWith :: ([a] -> b) -> Species a b
permutationSpeciesWith structure =
  speciesWithEmptySupport AcceptsEmptyLabels $ \xs ->
    map structure (permutations xs)

dedupeOn :: Eq k => (a -> k) -> [a] -> [a]
dedupeOn key = go []
  where
    go _ [] = []
    go seen (value:rest)
      | key value `elem` seen = go seen rest
      | otherwise = value : go (key value : seen) rest

unlabelledSpeciesBy :: Eq k => (b -> k) -> Species a b -> Species a b
unlabelledSpeciesBy key species =
  speciesWithFuelAndEmptySupport (emptyLabelSupport species) $ \fuel xs ->
    dedupeOn key (runSpeciesWithFuel species fuel xs)

sumSpecies :: Species a b -> Species a b -> Species a b
sumSpecies left right =
  speciesWithFuelAndEmptySupport support $ \fuel xs ->
    runSpeciesWithFuel left fuel xs ++ runSpeciesWithFuel right fuel xs
  where
    support = sumEmptySupport (emptyLabelSupport left) (emptyLabelSupport right)

zeroSpecies :: Species a b
zeroSpecies = speciesWithEmptySupport RejectsEmptyLabels $ \_ -> []

oneSpecies :: Monoid b => Species a b
oneSpecies =
  speciesWithEmptySupport AcceptsEmptyLabels $ \xs ->
    if null xs
    then [mempty]
    else []

instance Monoid b => Num (Species a b) where
  (+) = sumSpecies
  (*) = productWith (<>)
  negate _ = error "Species do not support additive inverses."
  abs = id
  signum _ = oneSpecies
  fromInteger n
    | n < 0 = error "Species numeric literals must be non-negative."
    | n == 0 = zeroSpecies
    | otherwise = foldr sumSpecies zeroSpecies (replicate (fromInteger n) oneSpecies)

product :: Species a b -> Species a c -> Species a (b, c)
product = productWith (,)

productWith :: 
  (b -> c -> d) -> Species a b -> Species a c -> Species a d
productWith join left right =
  speciesWithFuelAndEmptySupport support $ \fuel xs ->
    concatMap (productForSplitWith fuel join left right) (runSpecies subsets xs)
  where
    support = productEmptySupport (emptyLabelSupport left) (emptyLabelSupport right)

infixl 7 *>
(*>) :: Species a b -> (b -> c -> d) -> Species a c -> Species a d
left *> join = productWith join left

-- Check known empty-side rejections before evaluating the opposite factor.
-- This keeps recursive products such as T = X + T * X from calling T on the
-- same label set when X cannot contribute an empty structure.
productForSplitWith ::
  Int -> (b -> c -> d) -> Species a b -> Species a c -> ([a], [a]) -> [d]
productForSplitWith fuel join left right (leftLabels, rightLabels)
  | null leftLabels && rejectsEmptyLabels left = []
  | null rightLabels && rejectsEmptyLabels right = []
  | null rightLabels =
      [ join a b
      | b <- runSpeciesWithFuel right fuel rightLabels
      , a <- runSpeciesWithFuel left fuel leftLabels
      ]
  | otherwise =
      [ join a b
      | a <- runSpeciesWithFuel left fuel leftLabels
      , b <- runSpeciesWithFuel right fuel rightLabels
      ]

listSpecies :: Species a b -> Species a [b]
listSpecies component =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    [ structures
    | blocks <- runSpecies partitions xs
    , structures <- mapM (runSpeciesWithFuel component fuel) blocks
    ]

listSpeciesWith :: Species b c -> Species a b -> Species a c
listSpeciesWith outer component =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    concatMap (runSpeciesWithFuel outer fuel) (runSpeciesWithFuel (listSpecies component) fuel xs)

integerPartitionSpecies :: Species a b -> Species a [b]
integerPartitionSpecies component =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    [ structures
    | sizes <- integerPartitionSizes (length xs)
    , structures <- mapM (runSpeciesWithFuel component fuel) (blocksOf sizes xs)
    ]

integerPartitionSpeciesWith :: Species b c -> Species a b -> Species a c
integerPartitionSpeciesWith outer component =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    concatMap (runSpeciesWithFuel outer fuel) (runSpeciesWithFuel (integerPartitionSpecies component) fuel xs)

integerPartsOf :: Species a Graph -> Species a Graph
integerPartsOf = integerPartitionSpeciesWith unionGraphs

composeSpecies :: Species b c -> Species a b -> Species a c
composeSpecies outer inner =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    concatMap (composeForPartition fuel xs) (runSpecies partitions xs)
  where
    composeForPartition fuel wholeLabels partition
      | isWholePartition wholeLabels partition && fuel <= 0 = []
      | otherwise =
          [ final
          | inners <- mapM (runInnerForBlock fuel wholeLabels partition) partition
          , final <- runSpeciesWithFuel outer fuel inners
          ]

    runInnerForBlock fuel wholeLabels partition block =
      runSpeciesWithFuel inner nextFuel block
      where
        nextFuel
          | isWholePartition wholeLabels partition = fuel - 1
          | otherwise = fuel

    isWholePartition wholeLabels partition =
      case partition of
        [block] -> length block == length wholeLabels
        _ -> False

infixr 9 <@>
(<@>) :: Species b c -> Species a b -> Species a c
(<@>) = composeSpecies

convolve :: Species a b -> Species a c -> Species a (b,c)
convolve = convolveWith (,)

convolveWith :: (b -> c -> d) -> Species a b -> Species a c -> Species a d
convolveWith join left right =
  speciesWithFuelAndEmptySupport support $ \fuel xs ->
    concatMap (productForSplitWith fuel join left right) (orderedCuts xs)
  where
    support = productEmptySupport (emptyLabelSupport left) (emptyLabelSupport right)

infixl 7 *|*>
(*|*>) :: Species a b -> (b -> c -> d) -> Species a c -> Species a d
left *|*> join = convolveWith join left

infixl 7 *|*
(*|*) :: Species a Graph -> Species a Graph -> Species a Graph
(*|*) = convolveWith unionTwoGraphs

orderedGraphProduct :: Species a Graph -> Species a Graph -> Species a Graph
orderedGraphProduct = convolveWith joinTwoGraphs

singletonGraph :: Species Vertex Graph
singletonGraph =
  mapSpecies graphFromSingleton (tupleN 1)
  where
    graphFromSingleton vertices = directedGraph vertices []

optionalGraph :: Species a Graph -> Species a Graph
optionalGraph species = oneSpecies + species

drawTreesWith :: (Tree -> [Edge]) -> Species Vertex Tree -> Species Vertex Graph
drawTreesWith edgesOf treeSpecies =
  mapSpecies treeGraph treeSpecies
  where
    treeGraph tree = directedGraph (treeVertices tree) (edgesOf tree)

orderedBinaryTreeGraphs :: Species Vertex Graph
orderedBinaryTreeGraphs = orderedTreeNodeGraphs orderedBinaryTreeGraphs

fullOrderedBinaryTreeGraphs :: Species Vertex Graph
fullOrderedBinaryTreeGraphs =
  singletonGraph +
    orderedFullTreeNodeGraphs fullOrderedBinaryTreeGraphs

orderedTreeNodeGraphs :: Species Vertex Graph -> Species Vertex Graph
orderedTreeNodeGraphs child =
  convolveWith
    orderedTreeNodeGraph
    singletonGraph
    (convolve (optionalGraph child) (optionalGraph child))

orderedFullTreeNodeGraphs :: Species Vertex Graph -> Species Vertex Graph
orderedFullTreeNodeGraphs child =
  convolveWith
    orderedTreeNodeGraph
    singletonGraph
    (convolve child child)

orderedTreeNodeGraph :: Graph -> (Graph, Graph) -> Graph
orderedTreeNodeGraph rootGraph (leftGraph, rightGraph) =
  directedGraph vertices edges
  where
    vertices =
      graphVertices rootGraph ++
      graphVertices leftGraph ++
      graphVertices rightGraph
    edges =
      graphEdges rootGraph ++
      graphEdges leftGraph ++
      graphEdges rightGraph ++
      childRootEdges
    childRootEdges =
      case rootVertexOf rootGraph of
        Nothing -> []
        Just root ->
          leftChildRootEdges root leftGraph ++ rightChildRootEdges root rightGraph

rootVertexOf :: Graph -> Maybe Vertex
rootVertexOf graph =
  case graphVertices graph of
    [] -> Nothing
    root:_ -> Just root

leftChildRootEdges :: Vertex -> Graph -> [Edge]
leftChildRootEdges parent child =
  case rootVertexOf child of
    Nothing -> []
    Just childRoot -> [(parent, childRoot)]

rightChildRootEdges :: Vertex -> Graph -> [Edge]
rightChildRootEdges parent child =
  case rootVertexOf child of
    Nothing -> []
    Just childRoot -> [(childRoot, parent)]

unorderedBinaryTreeGraphs :: Species Vertex Graph
unorderedBinaryTreeGraphs = drawTreesWith treeEdges unorderedBinaryTreeSpecies

orderedBinaryTreeSpecies :: Species Vertex Tree
orderedBinaryTreeSpecies =
  binaryTreeSpeciesWith (orderedChildPairsOf orderedBinaryTreeSpecies)

unorderedBinaryTreeSpecies :: Species Vertex Tree
unorderedBinaryTreeSpecies =
  binaryTreeSpeciesWith (unorderedChildPairsOf unorderedBinaryTreeSpecies)

binaryTreeSpeciesWith :: Species Vertex (Tree, Tree) -> Species Vertex Tree
binaryTreeSpeciesWith childPairs =
  sumSpecies emptyTree (convolveWith node rootVertex childPairs)
  where
    node root (left, right) = Node root left right

orderedChildPairsOf :: Species Vertex Tree -> Species Vertex (Tree, Tree)
orderedChildPairsOf treeSpecies =
  convolve treeSpecies treeSpecies

unorderedChildPairsOf :: Species Vertex Tree -> Species Vertex (Tree, Tree)
unorderedChildPairsOf treeSpecies =
  filterSpecies canonicalTreePair (orderedChildPairsOf treeSpecies)

emptyTree :: Species Vertex Tree
emptyTree = mapSpecies (const Empty) (tupleN 0)

rootVertex :: Species Vertex Vertex
rootVertex = mapSpecies only (tupleN 1)
  where
    only [vertex] = vertex
    only _ = error "tupleN 1 produced a non-singleton tuple."

canonicalTreePair :: (Tree, Tree) -> Bool
canonicalTreePair (left, right) =
  treeSize left < treeSize right ||
    (treeSize left == treeSize right && treeShapeKey left <= treeShapeKey right)

treeVertices :: Tree -> [Vertex]
treeVertices Empty = []
treeVertices (Node root left right) =
  root : treeVertices left ++ treeVertices right

treeSize :: Tree -> Int
treeSize Empty = 0
treeSize (Node _ left right) = 1 + treeSize left + treeSize right

treeShapeKey :: Tree -> String
treeShapeKey Empty = "."
treeShapeKey (Node _ left right) =
  "(" ++ treeShapeKey left ++ treeShapeKey right ++ ")"

orderedTreeEdges :: Tree -> [Edge]
orderedTreeEdges Empty = []
orderedTreeEdges (Node root left right) =
  leftChildEdges root left ++
  rightChildEdges root right ++
  orderedTreeEdges left ++
  orderedTreeEdges right

leftChildEdges :: Vertex -> Tree -> [Edge]
leftChildEdges _ Empty = []
leftChildEdges parent (Node child _ _) = [(parent, child)]

rightChildEdges :: Vertex -> Tree -> [Edge]
rightChildEdges _ Empty = []
rightChildEdges parent (Node child _ _) = [(child, parent)]

treeEdges :: Tree -> [Edge]
treeEdges Empty = []
treeEdges (Node root left right) =
  childEdges root left ++ childEdges root right ++ treeEdges left ++ treeEdges right

childEdges :: Vertex -> Tree -> [Edge]
childEdges _ Empty = []
childEdges parent (Node child _ _) = [(parent, child)]

-- listOrderedSpecies :: Species a b -> Species a [b]
-- listOrderedSpecies component xs =
--   [ structures
--   | blocks <- orderedPartitions xs
--   , structures <- mapM component blocks
--   ]

-- listOrderedSpeciesWith :: Species b c -> Species a b -> Species a c
-- listOrderedSpeciesWith outer component = concatMap outer . listOrderedSpecies component

composeOrderedSpecies :: Species b c -> Species a b -> Species a c
composeOrderedSpecies outer inner =
  speciesWithFuelAndEmptySupport UnknownEmptyLabels $ \fuel xs ->
    concatMap (composeForPartition fuel xs) (orderedPartitions xs)
  where
    composeForPartition fuel wholeLabels partition
      | isWholePartition wholeLabels partition && fuel <= 0 = []
      | otherwise =
          [ final
          | inners <- mapM (runInnerForBlock fuel wholeLabels partition) partition
          , final <- runSpeciesWithFuel outer fuel inners
          ]

    runInnerForBlock fuel wholeLabels partition block =
      runSpeciesWithFuel inner nextFuel block
      where
        nextFuel
          | isWholePartition wholeLabels partition = fuel - 1
          | otherwise = fuel

    isWholePartition wholeLabels partition =
      case partition of
        [block] -> length block == length wholeLabels
        _ -> False

infixr 9 <|>
(<|>) :: Species b c -> Species a b -> Species a c
(<|>) = composeOrderedSpecies

-- listCyclicSpecies :: CyclicSpecies a -> CyclicSpecies [a]
-- listCyclicSpecies component xs =
--   [ structures
--   | blocks <- cyclicPartitions xs
--   , structures <- mapM component blocks
--   ]

-- listCyclicSpeciesWith :: ([a] -> b) -> CyclicSpecies a -> CyclicSpecies b
-- listCyclicSpeciesWith join component = mapSpecies join (listCyclicSpecies component)

orderedCuts :: [a] -> [([a], [a])]
orderedCuts xs = [splitAt size xs | size <- [0 .. length xs]]

orderedPartitions :: [a] -> [[[a]]]
orderedPartitions [] = [[]]
orderedPartitions xs =
  [ before ++ [block]
  | size <- [1 .. length xs]
  , let (beforeLabels, block) = splitAt (length xs - size) xs
  , before <- orderedPartitions beforeLabels
  ]

-- cyclicPartitions :: [Vertex] -> [Partition]
-- cyclicPartitions [] = [[]]
-- cyclicPartitions vertices =
--   nub (map canonicalPartition (allInOne : cutPartitions))
--   where
--     n = length vertices
--     allInOne = [vertices]
--     cutPartitions =
--       [ cyclicBlocks vertices cuts
--       | cuts <- subsets [0 .. n - 1]
--       , length cuts >= 2
--       ]

-- canonicalPartition :: Partition -> Partition
-- canonicalPartition = sort . map sort

-- cyclicBlocks :: [Vertex] -> [Int] -> Partition
-- cyclicBlocks vertices cuts =
--   [ map (vertices !!) (cyclicRange (previous + 1) current n)
--   | (previous, current) <- zip sortedCuts (tail sortedCuts ++ [head sortedCuts])
--   ]
--   where
--     n = length vertices
--     sortedCuts = sort cuts

-- cyclicRange :: Int -> Int -> Int -> [Int]
-- cyclicRange start end n
--   | n <= 0 = []
--   | normalizedStart <= end = [normalizedStart .. end]
--   | otherwise = [normalizedStart .. n - 1] ++ [0 .. end]
--   where
--     normalizedStart = start `mod` n

integerPartitionSizes :: Int -> [[Int]]
integerPartitionSizes n = go n n
  where
    go 0 _ = [[]]
    go total maximumPart =
      [ size : rest
      | size <- [min total maximumPart, min total maximumPart - 1 .. 1]
      , rest <- go (total - size) size
      ]

blocksOf :: [Int] -> [a] -> [[a]]
blocksOf [] _ = []
blocksOf (size:sizes) xs = block : blocksOf sizes after
  where
    (block, after) = splitAt size xs

partitions :: Species a [[a]]
partitions = speciesWithEmptySupport AcceptsEmptyLabels go
  where
    go [] = [[]]
    go (x:xs) = concatMap (insertBlock x) (go xs)

    insertBlock x blocks = [[x] : blocks] ++ grow x [] blocks

    grow _ _ [] = []
    grow x before (block:after) =
      (before ++ [(x : block)] ++ after) : grow x (before ++ [block]) after

subsets :: Species a ([a],[a])
subsets = speciesWithEmptySupport AcceptsEmptyLabels go
  where
    go [] = [([],[])]
    go (x:xs) = chooseLeft ++ chooseRight
      where
        rest = go xs
        chooseLeft = [(x : left, right) | (left, right) <- rest]
        chooseRight = [(left, x : right) | (left, right) <- rest]

-- idShapeSpecies :: ShapeSpecies Vertex
-- idShapeSpecies n = [0 .. n - 1]

-- mapShapeSpecies :: (a -> b) -> ShapeSpecies a -> ShapeSpecies b
-- mapShapeSpecies f species n = map f (species n)

-- sumShapeSpecies :: ShapeSpecies a -> ShapeSpecies a -> ShapeSpecies a
-- sumShapeSpecies left right n = left n ++ right n

-- productShapeSpecies :: ShapeSpecies a -> ShapeSpecies b -> ShapeSpecies (a, b)
-- productShapeSpecies left right n =
--   [ (a, b)
--   | size <- [0..n]
--   , a <- left size
--   , b <- right (n-size)
--   ]

-- productShapeSpeciesWith :: (a -> b -> c) -> ShapeSpecies a -> ShapeSpecies b -> ShapeSpecies c
-- productShapeSpeciesWith join left right n =
--   [ join a b
--   | size <- [0..n]
--   , a <- left size
--   , b <- right (n-size)
--   ]

-- listShapeSpecies :: ShapeSpecies a -> ShapeSpecies [a]
-- listShapeSpecies f =
--   productShapeSpeciesWith (:) f (listShapeSpecies f)
