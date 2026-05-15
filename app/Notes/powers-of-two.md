# Powers of 2

This lab is the unordered twin of "Numbers up to n." We again split the label set into a marked clique and an unmarked discrete part, but now the marked labels can be anywhere.

Species expression. The construction is `productSpeciesWith unionTwoGraphs indiscrete discrete`. This is ordinary labelled product: every label independently goes to the left factor or the right factor.

Visual encoding. The left factor is drawn as a clique. The right factor is drawn as isolated vertices. Each frame is one subset of the \(n\) labels.

Count. Every vertex makes a binary decision, marked or unmarked, so the count is \(2^n\).

Ordered vs unordered. The ordered version remembers only the size of an initial segment, so it gives \(n+1\). The unordered labelled version remembers the actual subset, so two subsets of the same size are different when they use different labels.

Try this. Swap `discrete` for `indiscrete` on the right side too. Then every frame becomes a two-block partition, and the distinction between "which side" and "which labels" becomes especially visible.
