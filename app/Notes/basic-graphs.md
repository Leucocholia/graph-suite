# Basic graphs

This first lab is the visual alphabet for the course. A discrete graph means "these labels are present, but this construction adds no internal relation." An indiscrete graph means "these labels have been gathered into one block."

Species expression. The two starter species are both one-structure-on-any-label-set species: `discrete` and `indiscrete`. The difference is not the count, but the drawing.

Visual encoding. `discrete` draws isolated vertices. `indiscrete` draws a directed clique: every pair of distinct vertices has both arrows. Later labs use that clique as a visual block, tile, equivalence class, or chosen subset.

Count. Each of these species has exactly one structure on a fixed set of \(n\) labels.

Try this. Change `graphs n = indiscrete (labels n)` to `graphs n = discrete (labels n)`. Nothing about the labels changes; only the internal structure disappears. This is the smallest possible example of how the same label set can carry different structures.
