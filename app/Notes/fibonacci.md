# Fibonacci tilings

Evenness \(E[n]\) is determined by \(E[n-2]\), but of course there is a very famous recurrence \(F[n]\) determined by \(F[n-1]\) and \(F[n-2]\). We can take the same approach as in the last module to implement this, by convolving with something that reduces \(n\) by 1 or 2, and starting with \(F[0] = 1\), this gives the Fibonacci numbers. With this encoding, you can see how Fibonacci numbers are connected to exponential growth (the animation looks like a binary counter ticking up) and how they're described concretely as the ways to make \(n\) cents from 1 and 2-cent coins. Also, we only need one base case! That probably doesn't actually matter that much, but it is surprisingly nicer than other encodings.

For this to work, we want to take ordered lists of 1- and 2-tiles and draw them in series. This is what `unionGraphs <|> tile` does: ordered composition builds the list of tiles, and `unionGraphs` draws the finished tiling.

- You can generalize the Fibonacci numbers by adding possible tiles. Implement the Tribonacci numbers, with \({1,2,3}\) as tile sizes. These sequences approach something as you add tile sizes; what is it?
