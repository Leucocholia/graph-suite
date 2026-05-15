# Sandbox

This is the first lab because it is better to poke the system before naming all of it. The sandbox is a tiny editable module: change one expression, compile, and watch the frames change.

Construction. The starter program renders `discrete`, which means the labels are present but no edges have been added. That is the cleanest possible structure on a label set.

Visual encoding. A graph frame is just a finite set of labelled vertices plus directed edges. Later labs use cliques as blocks, paths as orders, and bidirected edges as undirected edges.

First experiment. Change `discrete` to `indiscrete`, compile, and turn on clique shading. You have changed from "these labels exist separately" to "these labels belong to one complete block."

Second experiment. Try replacing the body with:


```haskell
sandbox :: Species Vertex Graph
sandbox = productSpeciesWith unionTwoGraphs indiscrete discrete
```

That gives the unordered subset lab in miniature: every label chooses whether it belongs to the clique block or the isolated block.
