# Integer partitions

An integer partition remembers only the block sizes of a set partition. It is the unlabelled shadow of the equivalence-relation construction.

Species expression. The code uses `integerPartsOf complete`. Instead of enumerating every labelled set partition, it enumerates the weakly decreasing list of block sizes and then uses the current label order to draw one representative.

Visual encoding. The graphs use the same clique encoding as equivalence relations, but only one representative is drawn for each partition of \(n\).

Count. The number of frames is \(p(n)\), the integer partition number.

Ordered vs unordered. Equivalence relations distinguish which labels are in each block. Integer partitions forget that information and remember only the multiset of block sizes.

Unlabelled species. This is the first deliberately unlabelled lab. We are not saying the labels vanished from the drawing; the renderer still needs names for vertices. We are saying the enumeration keeps one canonical representative for each shape after relabelling is ignored.

Try this. Compare \(n=6\) here with \(n=6\) in equivalence relations. The same block-size patterns are present, but all labelled rearrangements have collapsed to one frame each.
