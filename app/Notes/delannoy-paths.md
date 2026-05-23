# Delannoy paths

This lab draws paths from \((0,0)\) to \((n,k)\) using east, north, and diagonal northeast steps. The vertex-label field supplies one or more targets as pairs, such as `[(3,2)]`.

Count. These are the Delannoy numbers \(D(n,k)\). The diagonal step is the only difference from the binomial lattice path lab, but it creates many more frames.

Visual encoding. Each frame is drawn on the lattice grid. Diagonal steps move one column and one row at the same time.

Try this. Compare this lab with the binomial lattice path lab at the same target pair; every binomial path is still present, and the extra frames are exactly the paths that use at least one diagonal step.
