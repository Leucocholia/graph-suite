# Powers of 2

<!-- This lab is the unordered twin of "Numbers up to n." We again split the label set into a marked clique and an unmarked empty part, but now the marked labels can be anywhere.

Species expression. The construction is `complete * empty`. This is ordinary labelled product: every label independently goes to the left factor or the right factor.

Visual encoding. The left factor is drawn as a clique. The right factor is drawn as isolated vertices. Each frame is one subset of the \(n\) labels.

Count. Every vertex makes a binary decision, marked or unmarked, so the count is \(2^n\).

Ordered vs unordered. The ordered version remembers only the size of an initial segment, so it gives \(n+1\). The unordered labelled version remembers the actual subset, so two subsets of the same size are different when they use different labels.

Try this. Swap `empty` for `complete` on the right side too. Then every frame becomes a two-block partition, and the distinction between "which side" and "which labels" becomes especially visible. -->

Order makes a big difference! We define *multiplication* of species as splitting the labels into any pair of lists, and outputting a pair of an F-graph a G-graph. This is exactly the same as composition, except that the blocks don't need to be cohesive, they can just be any sublist. Convolution is usually regarded as ordered multiplication in this sense. Splitting n into an ordered pair of blocks just gives n+1, but an unordered split gives 2^n, since an element can belong to the first block or not, arbitrarily. 

If you replace `complete` with `connected` and force all the blocks to be nonempty, you get the [Stirling numbers of the second kind](https://en.wikipedia.org/wiki/Stirling_numbers_of_the_second_kind) times the factorial of the number of blocks. We have to multiply, because each sublist can be in any of the blocks, which isn't an issue with convolution, because of the order requirement. 

Code some examples with k blocks to convince yourself that each configuration occurs k! times (as long as it occurs in the first place).
