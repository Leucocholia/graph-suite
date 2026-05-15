# Catalan triangulations

A triangulation of a convex polygon is a maximal noncrossing set of diagonals. The cyclic order of the vertices is the geometric structure being respected.

Species expression. This is not a plain set species: it depends on cyclic order. Choosing a diagonal through a pivot splits the polygon into smaller polygons, which gives the same Catalan recursion from a geometric direction.

Visual encoding. The module renders the polygon boundary together with the chosen diagonals, with each undirected edge represented by arrows in both directions.

Count. Triangulations of an \((n+2)\)-gon are counted by the Catalan number \[C_n = \frac{1}{n+1}\binom{2n}{n}.\]

Ordered vs unordered. A polygon has less structure than a line and more structure than a set. Rotation around the boundary matters as cyclic adjacency, but there is no arbitrary block order like in a sequence.

Try this. Switch between circle and line layouts. The circle layout preserves the noncrossing geometry; the line layout makes the recursion feel more like interval splitting.
