# Basic graphs

There are a few primitive species we're gonna use everywhere. The main one is `clique k`; if \(n = k\), then it returns one graph: the complete graph on \(k\) vertices, and otherwise it returns zero graphs. `complete` gives the clique on any \(n\) and `connected` gives it for any nonzero \(n\). `hidden` and `empty` are functionally the same as `complete`, but the graph they return is invisible and has no edges, respectively.

`unionTwo` represents the disjoint union of two graphs, the graph which has each argument as a subgraph and adds no edges. `fullJoinTwo` adds all possible edges, and `joinTwo` only adds the ones that actually look good (from maximal elements to minimal elements).

- Try changing `output = complete` to `output = empty`.
