# Simple graphs

This lab finally treats graphs themselves as the species. On a fixed label set, every possible undirected edge is independently present or absent.

Species expression. The labelled simple graph species is \(\mathrm{SET}(E_2)\), where \(E_2\) is an unordered pair of distinct labels. The implementation enumerates all subsets of the possible pairs.

Visual encoding. The renderer uses directed edges, so each undirected graph edge is drawn as two arrows, one in each direction. There are no loops.

Count. There are \(\binom{n}{2}\) possible edges, so the frame count is \(2^{\binom{n}{2}}\).

Ordered vs unordered. This is unordered in the edge choices: edges form a set. It is still labelled in the vertex choices: swapping labels usually gives a different frame.

Try this. Keep \(n\) small. At \(n=5\) there are already \(2^{10}=1024\) labelled simple graphs.
