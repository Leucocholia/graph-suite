# Fibonacci tilings

These are ordered tilings of a line of \(n\) labelled positions by tiles of size \(1\) and \(2\). This is the first composition lab: instead of making one cut, we cut the whole line into many consecutive blocks.

Species expression. The construction is `composeOrderedSpecies unionGraphs tile`, where `tile` is the sum of an allowed singleton block and an allowed pair block.

Visual encoding. A size \(1\) tile is a single vertex. A size \(2\) tile is drawn as a two-vertex clique, so the larger tiles are easy to see.

Count. The frames satisfy \[F_n = F_{n-1} + F_{n-2}\] with \(F_0 = F_1 = 1\). The first tile either has size \(1\), leaving \(n-1\), or size \(2\), leaving \(n-2\).

Ordered vs unordered. Ordered composition respects the line: tiles cannot interleave. If we replace it with unordered set composition, we are no longer tiling a line; we are partitioning labels into singleton and pair blocks, which is a matching problem.

Try this. Remove the size \(1\) tile or the size \(2\) tile from `sumSpecies` and watch the recurrence collapse.
