# Motzkin graphs

A Motzkin graph is a noncrossing partial matching: each vertex is either isolated or paired with one other vertex, and the paired edges do not cross in the planar cyclic order.

Species expression. Recursively, the first vertex is either isolated, or it is matched to a partner that splits the remaining vertices into an inside interval and an outside interval.

Visual encoding. Matching edges are rendered in both directions. Isolated vertices stay visible, so each frame shows both the chosen pairs and the unused labels.

Count. These objects are counted by the Motzkin numbers \(1,1,2,4,9,21,\ldots\).

Ordered vs unordered. The labels sit in a fixed cyclic order, and the noncrossing rule depends on that order. If we forget the cyclic order, "crossing" is no longer a meaningful constraint.

Try this. Use a circle layout for the natural noncrossing picture, then use a line layout to read each matching as nested arcs.
