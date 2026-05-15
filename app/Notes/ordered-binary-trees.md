# Ordered binary trees

An ordered binary tree is recursively either empty, or a root with a left subtree and a right subtree.

Species expression. Recursively, \(B = 1 + X \cdot B \cdot B\). The two copies of \(B\) are distinguished: one is left and one is right.

Visual encoding. Edge direction marks left and right. A left-child edge points away from the parent; a right-child edge points back toward the parent. That keeps a lone left child and a lone right child from collapsing into the same frame.

Count. The counts are Catalan numbers: \[C_n = \frac{1}{n+1}\binom{2n}{n}.\]

Ordered vs unordered. The ordered tree remembers whether a subtree is on the left or right. Swapping unequal subtrees at a node gives a different ordered tree.

Try this. Compare this preset to unordered binary trees at the same \(n\). The difference is exactly the symmetry that swaps sibling subtrees.
