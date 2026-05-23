# Unlabelled simple graphs

This lab keeps one representative for each simple graph shape. Two labelled graphs are identified when a relabelling of vertices turns one into the other.

Species expression. The implementation enumerates labelled simple graphs, computes a canonical adjacency key over all vertex permutations, and deduplicates by that key.

Visual encoding. The drawn vertices still have labels because the renderer needs stable names. Those labels are only representatives; they are not part of the counted structure.

Count. The unlabelled simple graph counts begin \(1,1,2,4,11,34\) for \(n=0,1,2,3,4,5\).

Ordered vs unordered. Labelled simple graphs count every labelling. Unlabelled simple graphs count each isomorphism class once.

Unlabelled species. This is the practical version of unlabelled enumeration: canonical representatives first. The theoretical version uses cycle indices and Polya counting to count or generate shapes without first listing every labelling. We are not building that full algebra here, but this lab shows the same quotient idea visually.

Try this. Compare \(n=5\) here with labelled simple graphs at \(n=5\). The labelled lab has \(1024\) frames; this lab has \(34\).
