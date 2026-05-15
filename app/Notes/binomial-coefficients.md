# Binomial coefficients

This lab keeps the unordered subset idea, but filters it down to one fixed size. The clique is the chosen \(k\)-element subset.

Species expression. The construction is `productSpeciesWith unionTwoGraphs discrete (onNLabels k indiscrete)`. The helper `onTupleN` is an alias for `onNLabels`; both mean "this factor accepts exactly \(k\) labels."

Visual encoding. The chosen \(k\) labels form a directed clique. All other labels are present as isolated vertices.

Count. The frames are the \(k\)-subsets of an \(n\)-set, so the count is \(\binom{n}{k}\).

Ordered vs unordered. If this were an ordered product, there would be at most one frame for a fixed \(k\): the initial segment of length \(k\). The unordered product sees every possible \(k\)-element subset.

Try this. Change the `chosenSize` variable. For \(k=0\) there is one empty choice, for \(k=1\) there are \(n\) choices, and for \(k>n\) there are no frames.
