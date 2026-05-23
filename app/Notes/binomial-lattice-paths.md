# Binomial lattice paths

This lab draws monotone paths from \((0,0)\) to \((n,k)\). The vertex-label field supplies one or more targets as pairs, such as `[(3,2)]`.

Species expression. The frame count is \(\binom{n+k}{k}\): each path is a word with \(n\) east steps and \(k\) north steps.

Visual encoding. Frames render on a lattice grid instead of the graph circle layout. Yellow marks the origin, red marks the endpoint, and each frame is one monotone path.

Try this. Change the target pair in the vertex-label field. Increasing either coordinate adds another row or column to the grid and grows the binomial coefficient.
