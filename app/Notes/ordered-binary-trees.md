# Ordered binary trees

An ordered binary tree is recursively either empty, or a root with a left subtree and a right subtree.

Species expression. Recursively, \(B = X \cdot (1 + B) \cdot (1 + B)\). The two copies of \(B\) are distinguished by ordered product position: one is left of the root and one is right of the root.

Visual encoding. The graph is built directly with ordered graph joins. The root is the middle singleton block, with the left and right recursive blocks placed on either side.

Count. The counts are Catalan numbers: \[C_n = \frac{1}{n+1}\binom{2n}{n}.\]

Ordered vs unordered. The ordered tree remembers whether a subtree is on the left or right. Swapping unequal subtrees at a node gives a different ordered tree.

Try this. Compare this preset to unordered binary trees at the same \(n\). The difference is exactly the symmetry that swaps sibling subtrees.
