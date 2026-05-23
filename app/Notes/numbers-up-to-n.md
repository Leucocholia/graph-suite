# Numbers up to n

<!-- This is the first product lab. We divide the linearly ordered list of labels into two distinguished blocks: a left block that becomes a clique, and a right block that stays empty.

Species expression. The construction is `complete *|* empty`. The ordered product matters: the split must be a contiguous cut in the current label order.

Visual encoding. The first \(k\) labels are gathered into the clique, and the remaining \(n-k\) labels are isolated. As the frames advance, the clique grows from size \(0\) to size \(n\).

Count. There is one cut for each \(k\) with \(0 \le k \le n\), so the count is \(n+1\).

Ordered vs unordered. Ordered product sees only the boundary between "before" and "after." If you remove `Ordered`, the selected labels no longer need to be contiguous; the same idea jumps from \(n+1\) frames to \(2^n\).

Try this. Change `*|*` to `*`. Then turn on clique coloring or shading and watch the selected block range over every subset. -->

There are a bunch of ways to combine species, but one with the best interesing:simple ratio is *comvolution*, written with `*|*`. The convolution of species F and G takes the list of labels, splits it into two cohesive blocks, and returns a pair consisting of F on the first block and G on the second block. By default, these two blocks are combined with the disjoint union, but we'll see some examples where they're joined in different ways. 

If we do something simple like `output = complete *|* empty`, this counts all the numbers less than or equal to the length of the labelling list, of which there are n+1. `complete *|* complete` is the same (just rendered differently), and you can add as many `*|* complete`s as you want to get [integer compositions](https://oeis.org/wiki/Integer_compositions) on up to that many blocks.

Write code showing all compositions of 12 into 3 nonemtpy blocks.
