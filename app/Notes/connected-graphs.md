# Connected graphs

This lab filters the simple graph species to the connected part: every vertex must be reachable from every other vertex by a path.

Species expression. In species language, all simple graphs decompose as sets of connected components: \(\mathrm{Graph} = \mathrm{SET}(\mathrm{ConnectedGraph})\). This lab enumerates the connected summand directly by filtering simple graphs.

Visual encoding. Edges are still undirected edges rendered as two arrows. Connectivity is a global property of the whole drawing, not a local edge decoration.

Count. The labelled connected graph counts begin \(1,1,4,38,728\) for \(n=1,2,3,4,5\).

Ordered vs unordered. The graph itself is an unordered set of edges, but the vertices are labelled. The same shape with labels permuted still appears many times.

Try this. Compare this preset to simple graphs at the same \(n\). The missing frames are exactly the disconnected graphs.
