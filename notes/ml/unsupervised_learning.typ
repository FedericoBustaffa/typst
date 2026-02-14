= Unsupervised Learning
<unsupervised-learning>
The #strong[unsupervised learning] paradigm is quite different from the
#emph[supervised] one; in this approach examples are #strong[not
labeled];, so there is no #emph[error] in the model output.

It’s not even possible to properly talk about #emph[prediction error]
because the aim of unsupervised learning is not to predict but is to
catch underlying structures in the input data. Usually we are talking
about #strong[clusering] and #strong[dimensionality reduction] tasks
(#strong[representation learning];).

== Clustering
<clustering>
A typical task for unsupervised learning is #strong[clustering] where
the model tries to partition data into #strong[clusters];, that are
subsets of similar data.

#figure(image("/files/clustering.png"),
  caption: [
    Clustering|600
  ]
)

Usually the number of cluster must be known before the algorithm runs,
or it must be a grid search hyperparameter, assuming there is a good way
to determine if the algorithm performed good clustering.

The problem with unsupervised learning is that, in absence of a target,
is not possible to determine if the algorithm did well (at least not
easily). Things become more complicated when also the number of clusters
is not known a priori.

Of course if we know the label of each pattern and the model partition
every sample without knowing it, is possible to say if the cluster is
good. Otherwise we have to check metrics like how far each point is from
the center of the cluster (#strong[centroid];). This approach has a big
limitation because if we have as many centroids as points, the final
error will be zero, but the clusters are the points themselves so there
is no information gain.

== Vector Quantization
<vector-quantization>
The #strong[vector quantization] technique aims to #strong[encode] a
data #emph[manifold] using only a finite set of vectors
$w = (w_1 , dots.h , w_K)$ called #strong[references];.

So now a data vector $x$ from the original dataset is encoded and
described by the #strong[best-matching] (or #emph[winner];) reference
vector $w_(i^(\*) (x))$ of $w$ for which the #strong[distortion error];,
defined as some function $d (x , w_(i^(\*) (x)))$ is minimal.

This procedure has the effect of dividing the manifold in a set of
subregions

$ V_i = { x in V divides parallel x - w_i parallel lt.eq parallel x - w_j parallel } $

for all $j$ and where $V$ is the original manifold, defining a
#strong[Voronoi polyhedra];.

The goal in these scenarios is typically to find the best partitioning
of unknown distribution in input space into regions approximated by a
#emph[centroid];. This corresponds to build a set of #strong[vector
quantizers] on which input (continuous) space vectors are mapped.

=== Quantization Error
<quantization-error>
The #strong[quantization error] could be defined based on the task and
type of data but the most common one is the #strong[squared error];:

$ d (x , w_(i^(\*) (x))) = parallel x - w_(i^(\*) (x)) parallel^2 $

that can be seen as a #strong[loss function];. Generally the
#emph[quantization error] is defined as the mean error over the
distribution of data, computed between each point and its centroid.

$ E = integral f (d (x , w_(i^(\*) (x)))) p (x) #h(0em) d x = integral parallel x - w_(i^(\*) (x)) parallel^2 p (x) #h(0em) d x $

where $p (x)$ is the probability distribution of input $x$. In a
discrete version is defined as

$ E = sum_i^l sum_j^K parallel x_i - w_j parallel^2 dot.op delta (i , j) $

where $delta$ is the characteristic function defined as

$ delta (i , j) = cases(delim: "{", 1 & upright("if ") w_j upright(" is the winner"), 0 & upright("otherwise")) $

Of course is possible to minimize $E$ by choosing an optimal set of $w$,
that is the solution of vector quantization problem.

== References
<references>
- \[\[machine\_learning\]\]
- \[\[representation\_learning\]\]
- \[\[autoencoder\]\]
- \[\[k\_means\]\]
- \[\[self\_organizing\_maps\]\]
