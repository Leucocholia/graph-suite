# Basic graphs

There are a few primitive species we're gonna use everywhere. The main two are `complete` and `empty`, both returning a singe-element list consisting of the graph with either all possible or no edges. There are also a few like `linear` and `cyclic` that depend on the order of the list. There's also `clique _` which takes a number and gives a complete graph, but only if it has exactly that many vertices. `hidden`, giving zero graphs on any labels, is also quite important, for exactly one thing soon. `connected` is like `complete`, except it has 0 graphs on 0 objects.

Try changing `output = complete` to `output = empty`.