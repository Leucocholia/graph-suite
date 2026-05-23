# Unlabelled connected graphs

This is the connected graph species after forgetting vertex names. Each frame is one connected graph shape.

Species expression. The implementation filters to connected labelled simple graphs, computes the same canonical adjacency key as the unlabelled simple graph lab, and keeps one representative per key.

Visual encoding. Edges are undirected edges rendered as two arrows. Labels are representative names, not counted data.

Count. The unlabelled connected graph counts begin \(1,1,2,6,21\) for \(n=1,2,3,4,5\).

Ordered vs unordered. In the labelled connected lab, moving labels around a path or cycle usually gives new frames. Here all those relabellings collapse to a single connected shape.

Unlabelled species. Canonical representatives are a generator-friendly way to meet unlabelled species. Cycle indices are the formula-friendly way: they track how permutations of labels act on structures, then use that action to count fixed structures and quotient by symmetry. For this course, the important first idea is the quotient: labels help us draw, but shapes are counted up to relabelling.

Try this. At \(n=4\), compare the six unlabelled connected shapes with the \(38\) labelled connected graphs. The gap is pure symmetry.
