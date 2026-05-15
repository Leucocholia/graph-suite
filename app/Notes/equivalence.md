# Equivalence relations

An equivalence relation on a finite set is the same thing as a partition into blocks. In species notation this is \(\mathrm{SET}(\mathrm{SET}_{\ge 1}(X))\).

Species expression. The code writes this as `composeSpecies unionGraphs indiscrete`. First partition the labels into nonempty blocks, then put one clique structure on each block, then union the block drawings.

Visual encoding. Each block is rendered as a directed clique, so two vertices are mutually adjacent exactly when they lie in the same equivalence class.

Count. The number of frames is the Bell number \(B_n\).

Ordered vs unordered. This is unordered composition: the blocks do not have a first, second, or third position. Reordering the same blocks is not a new equivalence relation, but moving a label from one block to another is.

Try this. Turn on clique coloring or clique shading. The visual equivalence classes become explicit, and the Bell-number growth starts to feel less mysterious.
