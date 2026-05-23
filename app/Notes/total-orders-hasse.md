# Total orders, Hasse rendering

A total order is a linear arrangement of the \(n\) labelled vertices.

Species expression. This is the same total-order species as the previous lab. Only the graph encoding changes.

Visual encoding. If an order is

\[
a_1 < a_2 < \cdots < a_n,
\]

then the graph contains only

\[
a_1 \to a_2,\quad a_2 \to a_3,\quad \ldots,\quad a_{n-1} \to a_n.
\]

This is the Hasse diagram of the total order: a directed path instead of the full transitive tournament.

Count. There are still \(n!\) frames.

Ordered vs unordered. The path shape is always the same after labels are forgotten, but the labels can sit on that path in \(n!\) different orders.

Try this. Use the line layout toggle. The Hasse rendering then looks like the permutation itself, while the dense total-order rendering looks like all forward comparisons at once.
