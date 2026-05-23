# Total orders by recursion

This version builds total orders recursively:

```haskell
output = clique 1 + (clique 1) * output
```

The first term handles the one-label order. The recursive term chooses one label for the first singleton block, then recursively orders all remaining labels. This gives \(n!\) structures on \(n\) nonempty labels.

In this exact expression, `*` is species product and combines graph payloads by disjoint union. So the frames count total orders, but different orders with the same labels draw the same isolated vertices. To draw the order relation itself, use a graph join in the recursive product:

```haskell
output = clique 1 + ((clique 1 *> joinTwoGraphs) output)
```

There is an ordered version too:

```haskell
left *|*> joiner
```

so `(left *|*> joiner) right` is `convolveWith joiner left right`.
