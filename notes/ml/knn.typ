#import "note_template.typ": *
#show: note_template

#title("K-Nearest Neighbor")

A model, mostly used for classification, is the #strong[$k$-nearest neighbors];,
where there is no real #emph[learning phase];; the model is a
#strong[#emph[lazy];] type because it just stores all the data and, when it is
called to classify new data perform a sort #emph[similarty] comparison between
the new data and the stored data.

There are various #strong[distance metrics] and variants but, generally
speaking, the new data will be classified similarly to its neighbors.

= 1-Nearest Neighbor <nearest-neighbor>

The simplest version of the $k$-nn is the #strong[$1$-nn];, where we consider
only #emph[the] nearest neighbor of the new given data, according to some
#strong[distance] metric (lets take for example the #strong[euclidean
  distance];).

So given a dataset composed of $n$-dimensional data and $x$, a new
$n$-dimensional data, the distance between $x$ and $x_i$ can be computed as

$
  d (x , x_p) = sqrt(sum_(i = 1)^n (x_i - x_(p , i))^2) = parallel x - x_p
  parallel_2
$

The $1$-nn take the new data and compute the distance between it and all the
stored data, the classification will be the same as the closest pattern in the
dataset.

In this particular case of the $k$-nn we don’t have any error on the training
set because we simply store the patterns and their #emph[answers] as they are.

In the end we obtain a very #strong[flexible] and #strong[sensible] model that
may have some problems to generalize. That’s because if we an area full of
patterns classified with a certain label and only one classified in another way,
a new data that is closer to it will be classified the same. But maybe that
pattern was an outlier and the actual correct classification was the one of the
other patterns around.

= Mulitple Neighbors <mulitple-neighbors>

So the $1$-nn is kind of a special case of $k$-nn where the model just
#emph[copy] from the nearest neighbor to give an answer. When instead we
consider more than one neighbor, things change a bit.

Now we $k$ nearest neighbors that can have different labels, to choose which
class assign to the new data, we can performa a #strong[majority vote];,
assigning the same class the majority of the neighbors have.

$ h (x) = arg max_v sum_(x_i in N_k (x)) I_(v , y_i) $

where

$
  I_(v , y_i) = cases(
    delim: "{", 1 & upright("if ") v = y_i, 0 &
    upright("otherwise")
  )
$

This can be improved by considering also distance value as a weight: a pattern
that is closer to the new data has more importance.

$
  h (x) = arg max_v sum_(x_i in N_k (x)) I_(v , y_i) dot.op
  frac(1, d (x , x_i)^2)
$

so that the closer ones weight more on the average than the distant ones.

#note(title: "Regression")[
  It’s also possible perform a regression with knn and it’s usually done by
  taking the average (weighted or not) of $y_i$ in the neighborhood.
]

== Limitations <limitations>

This model can be very flexible and we don’t have to train it, on the other hand
we have to store potentially a lot of data that must always be present to
perform a prediction.

This of course does not scale well and also is not well suited for real-time
applications because, also because a large amount of data we need to compute a
lot of distances in an $n$-dimensional space that can be quite costly.

== References <references>

- Supervised Learning
