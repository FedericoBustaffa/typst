= Cascade Correlation
<cascade-correlation>
In the #strong[cascade correlation] method the model starts with few
units and add them based on the training algorithm, so both weights and
topology are learned. This approach allows to better deal with
hypothesis space of flexible size, also by training a single unit at
each step.

Starting for example from a single unit, the model is trained until
convergence; if the error is still to high an hidden unit is added, in
order to maximize the #strong[correlation] between the output of the
unit and the residual error of the previous network.

After the training, the new unit weights are frozen and the output layer
is retrained. When a unit is added is directly connected with all inputs
and all previously added units.

#figure(image("/files/cascade_correlation.png"),
  caption: [
    Cascade Correlation|500
  ]
)

The intuition behind the algorithm is that new units aim to
#emph[explain] the current error, by maximizing the correlation between
them and the network error. This is done by maximizing a correlation
function, that in most cases is the not normalized covariance between
output and error.

$ S = sum_k lr(|sum_p (o_p - overline(o)) (E_(p , k) - overline(E)_k)|) $

where

- $k$ and $p$ are respectively the number of output and the number of
  training patterns.
- $o_p$ is the candidate hidden unit’s output on pattern $p$.
- $E_(p , k)$ is the error of output unit $k$ for the pattern $p$.
- $overline(o)$ is the mean output of the net.
- $overline(E)_k$ is the mean error over all the patterns for output
  $k$.

In order to optimize the unit we need to maximize the correlation and so
is necessary to compute the derivation of the correlation function:

$ frac(partial S, partial w_j) = sum_k upright("sign") (S_k) sum_p (E_(p , k) - overline(E)_k) dot.op f' (upright("net")_p) dot.op I_(p , j) $

where $I_(p , j)$ is the input.

The idea to keep in mind is that the algorithm performs two
optimizations; the first wants to minimize the loss, once there is the
need to add an hidden unit, this is trained by maximimizing its
correlation with the error.

== References
<references>
- \[\[neural\_networks\_training\]\]
