module Combinatorial where

import Data.List (sort)

type Vertex = Int
type Edge = (Vertex, Vertex)
data Graph = Graph
  { graphVertices :: [Vertex]
  , graphEdges :: [Edge]
  }
  deriving (Eq, Ord, Show)
type Block = [Vertex]
type Partition = [Block]
type Species a b = [a] -> [b]
type OrderedSpecies a b = Species a b
type CyclicSpecies a b = Species a b
type Shape a = Int -> [a]

labels :: Int -> [Vertex]
labels n = [0 .. n - 1]

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
      | a == b -> []
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
    edges = sort (concatMap graphEdges graphs)

unionGraphs :: Species Graph Graph
unionGraphs graphs = [unionGraphList graphs]

unionTwoGraphs :: Graph -> Graph -> Graph
unionTwoGraphs left right = unionGraphList [left, right]

idSpecies :: Species a a
idSpecies l = l

tupleN :: Int -> Species a [a]
tupleN n xs =
  if length xs == n
  then [xs]
  else []

onNLabels :: Int -> Species a b -> Species a b
onNLabels n species l =
  if length l == n
  then species l
  else []

onTupleN :: Int -> Species a b -> Species a b
onTupleN = onNLabels

onNonemptyLabels :: Species a b -> Species a b
onNonemptyLabels species l =
  if length l > 0
  then species l
  else []

wholeTupleWith :: Species [a] b -> Species a b
wholeTupleWith species xs = species [xs]

exactTupleNWith :: Int -> Species [a] b -> Species a b
exactTupleNWith n species xs = concatMap (wholeTupleWith species) (tupleN n xs)

mapSpecies :: (b -> c) -> Species a b -> Species a c
mapSpecies f species = \xs -> map f (species xs)

dedupeOn :: Eq k => (a -> k) -> [a] -> [a]
dedupeOn key = go []
  where
    go _ [] = []
    go seen (value:rest)
      | key value `elem` seen = go seen rest
      | otherwise = value : go (key value : seen) rest

unlabelledSpeciesBy :: Eq k => (b -> k) -> Species a b -> Species a b
unlabelledSpeciesBy key species xs = dedupeOn key (species xs)

sumSpecies :: Species a b -> Species a b -> Species a b
sumSpecies left right xs = left xs ++ right xs

productSpecies :: Species a b -> Species a c -> Species a (b, c)
productSpecies left right xs =
  [ (f, g)
  | (leftLabels, rightLabels) <- subsets xs
  , f <- left leftLabels
  , g <- right rightLabels
  ]

productSpeciesWith :: 
  (b -> c -> d) -> Species a b -> Species a c -> Species a d
productSpeciesWith join left right xs =
  [ join a b
  | (leftLabels, rightLabels) <- subsets xs
  , a <- left leftLabels
  , b <- right rightLabels
  ]

listSpecies :: Species a b -> Species a [b]
listSpecies component xs =
  [ structures
  | blocks <- partitions xs
  , structures <- mapM component blocks
  ]

listSpeciesWith :: Species b c -> Species a b -> Species a c
listSpeciesWith outer component = concatMap outer . listSpecies component

integerPartitionSpecies :: Species a b -> Species a [b]
integerPartitionSpecies component xs =
  [ structures
  | sizes <- integerPartitionSizes (length xs)
  , structures <- mapM component (blocksOf sizes xs)
  ]

integerPartitionSpeciesWith :: Species b c -> Species a b -> Species a c
integerPartitionSpeciesWith outer component = concatMap outer . integerPartitionSpecies component

composeSpecies :: Species b c -> Species a b -> Species a c
composeSpecies outer inner xs =
  [ final
  | partition <- partitions xs
  , inners <- mapM inner partition
  , final <- outer inners
  ]

-- idOrderedSpecies :: OrderedSpecies Vertex
-- idOrderedSpecies = idSpecies

-- mapOrderedSpecies :: (a -> b) -> OrderedSpecies a -> OrderedSpecies b
-- mapOrderedSpecies = mapSpecies

-- sumOrderedSpecies :: OrderedSpecies a -> OrderedSpecies a -> OrderedSpecies a
-- sumOrderedSpecies = sumSpecies

productOrderedSpecies :: Species a b -> Species a c -> Species a (b,c)
productOrderedSpecies left right xs =
  [ (f, g)
  | (leftLabels, rightLabels) <- orderedCuts xs
  , f <- left leftLabels
  , g <- right rightLabels
  ]

productOrderedSpeciesWith :: (b -> c -> d) -> Species a b -> Species a c -> Species a d
productOrderedSpeciesWith join left right xs =
  [ join a b
  | (leftLabels, rightLabels) <- orderedCuts xs
  , a <- left leftLabels
  , b <- right rightLabels
  ]

-- listOrderedSpecies :: OrderedSpecies a -> OrderedSpecies [a]
-- listOrderedSpecies component xs =
--   [ structures
--   | blocks <- orderedPartitions xs
--   , structures <- mapM component blocks
--   ]

-- listOrderedSpeciesWith :: ([a] -> b) -> OrderedSpecies a -> OrderedSpecies b
-- listOrderedSpeciesWith join component = mapOrderedSpecies join (listOrderedSpecies component)

composeOrderedSpecies :: Species b c -> Species a b -> Species a c
composeOrderedSpecies outer inner xs =
  [ final
  | partition <- orderedPartitions xs
  , inners <- mapM inner partition
  , final <- outer inners
  ]

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
partitions [] = [[]]
partitions (x:xs) = concatMap insertBlock (partitions xs)
  where
    insertBlock blocks = [[x] : blocks] ++ grow [] blocks
    grow _ [] = []
    grow before (block:after) =
      (before ++ [(x : block)] ++ after) : grow (before ++ [block]) after

subsets :: Species a ([a],[a])
subsets [] = [([],[])]
subsets (x:xs) = chooseLeft ++ chooseRight
  where
    rest = subsets xs
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
