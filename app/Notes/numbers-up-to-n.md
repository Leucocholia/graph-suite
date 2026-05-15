# Numbers up to n

This is the first product lab. We divide the linearly ordered list of labels into two distinguished blocks: a left block that becomes a clique, and a right block that stays discrete.

Species expression. The construction is `productOrderedSpeciesWith unionTwoGraphs indiscrete discrete`. The word `Ordered` matters: the split must be a contiguous cut in the current label order.

Visual encoding. The first \(k\) labels are gathered into the clique, and the remaining \(n-k\) labels are isolated. As the frames advance, the clique grows from size \(0\) to size \(n\).

Count. There is one cut for each \(k\) with \(0 \le k \le n\), so the count is \(n+1\).

Ordered vs unordered. Ordered product sees only the boundary between "before" and "after." If you remove `Ordered`, the selected labels no longer need to be contiguous; the same idea jumps from \(n+1\) frames to \(2^n\).

Try this. Change `productOrderedSpeciesWith` to `productSpeciesWith`. Then turn on clique coloring or shading and watch the selected block range over every subset.
