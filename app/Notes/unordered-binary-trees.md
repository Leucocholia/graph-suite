# Unordered binary trees

An unordered binary tree uses the same recursive shape, but the two children of a node are not distinguished as left and right.

Species expression. Recursively, the root has a two-element multiset of subtrees rather than an ordered pair of subtrees. The implementation uses canonical split sizes and a `shapeKey` to avoid drawing both sibling orders.

Visual encoding. The drawing still orients edges away from the root. What changes is the enumeration: left-right mirror choices are identified.

Count. These are the Wedderburn-Etherington tree shapes with labelled vertices attached in the canonical order used by the module.

Ordered vs unordered. Ordered binary trees remember left and right children. Unordered binary trees remember only the two child subtrees as an unordered pair.

Unlabelled species. This is a recursive unlabelled idea hiding inside a labelled renderer. The labels are still printed on vertices, but the course is now tracking shapes modulo sibling swaps.

Try this. At a small \(n\), look for frames in the ordered tree lab that are mirror versions of each other. This lab keeps only one representative of each such local symmetry.
