# Sums of binomial coefficients

If we have multiplication, do we have addition? Yes! A graph from \(F + G\) is a graph from \(F\) or a graph from \(G\), ignoring any overlap. That is to say, the list \((F + G)[n]\) is just given by appending the lists \(F[n]\) and \(G[n]\). This follows all the properties you'd expect of addition: it's associative, commutative, unital, and it's distributed over by both forms of multiplication. You can use negatives and subtraction perfectly well theoretically, but it means we can't actually have a nice video of graphs (it would have to take a negative amount of time), so we won't use that here.

- What's the unit (the equivalent of 0)?
- Implement an example exhibiting the identity `(n choose k) + (n choose k+1) = (n+1 choose k+1)`
- Choose any 3 species and look at at least one side of the distributive identity `a * (b + c) = a * b + a * c` to see they're the same
