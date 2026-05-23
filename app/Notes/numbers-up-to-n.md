# Numbers up to n

There are a bunch of ways to combine species, but the one with the best interesting-to-simple ratio is *convolution*, written with `*|*`. The convolution of species \(F\) and \(G\) takes the list of labels, splits it into two contiguous blocks, and returns a pair consisting of \(F\) on the first block and \(G\) on the second block. By default, these two blocks are combined with the disjoint union, but we'll see some examples where they're joined in different ways. 

If we do something simple like `output = complete *|* empty`, this counts all the numbers less than or equal to the length of the labelling list, of which there are \(n+1\). `complete *|* complete` is the same (just rendered differently), and you can add as many `*|* complete`s as you want to get [integer compositions](https://oeis.org/wiki/Integer_compositions) on up to that many blocks.

- Write code showing all compositions of 12 into 3 nonempty blocks.
