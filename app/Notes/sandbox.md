# Sandbox

Good morning! This is my own attempt to teach the theory of combinatorial species by getting you to use it to make a bunch of cool graphs and see all the Shapes. This is done with a small Haskell interface, but you don't really need to know any Haskell or special math to use this.

A combinatorial species is (for our purposes) just a function that takes in lists and spits out other kinds of lists. We're especially interested in functions which take in lists of labels and output lists of graphs on those vertices. On the left, you'll see one field for entering a list of vertices, and another for code, which always contains `output :: Species Vertex Graph`. You'll be writing code snippets that use this output function to make various kinds of graphs on the given list of vertices.

The variable \(n\) will always refer to the number of vertices, and \(k\) will always be the second parameter.

This module is a sandbox, feel free to try out ideas here.

- Bulleted sentences are exercises.
