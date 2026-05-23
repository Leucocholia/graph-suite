# Powers of 2

Order makes a big difference! We define *multiplication* of species as splitting the labels into any pair of lists, and outputting a pair of an \(F\)-graph and a \(G\)-graph. This is exactly the same as composition, except that the blocks don't need to be contiguous; they can just be any sublist. Convolution is usually regarded as ordered multiplication in this sense. Splitting \(n\) into an ordered pair of blocks just gives \(n+1\), but an unordered split gives \(2^n\), since an element can belong to the first block or not, arbitrarily. 

If you replace `complete` with `connected` and force all the blocks to be nonempty, you get the [Stirling numbers of the second kind](https://en.wikipedia.org/wiki/Stirling_numbers_of_the_second_kind) times the factorial of the number of blocks. We have to multiply, because each sublist can be in any of the blocks, which isn't an issue with convolution, because of the order requirement. 

- Code some examples with k blocks to convince yourself that each configuration occurs \(k!\) times (as long as it occurs in the first place).
