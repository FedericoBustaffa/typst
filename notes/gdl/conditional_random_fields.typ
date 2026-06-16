#import "@local/note_template:0.1.0": *
#show: doc => note_template([Conditional Random Fields], doc)

#title()

Random variables that model input data can be assumed to be always observable
and this means that we can directly model the conditional distribution:

$ P(Y | X) = 1 / Z(X) product_k e^(theta_k f_k (X_k, Y_k)) $

where $X$ is the joint input that is always observable and the partition
function is defined as

$ Z(X) = sum_y product_k e^(theta_k f_k (X_k, Y_k = y_k)) $

and where $X_k$ is the observable inputs in factor $k$, $Y_k$ are the hidden
variables in factor $k$ and $f_k (X_k, Y_k)$ is the factor $k$ feature function.

This defines the so called *conditional random fields (CRF)* and a special case
of CRF is the *linear CRF*, that can be seen as an indirected version of hidden
markov model to work with sequences.

#figure(
  image("images/lcrf.png", width: 70%),
  caption: [ Linear-Chain Conditional Random Field ],
) <fig-lcrf>

and are able to model relative influence of suffix and prefix symbols with the
following conditional probability

$
  P(Y | X, theta) = 1 / Z(X) product_t product_k
  exp{theta_k f_k (Y_(t-1), Y_t, X_t)}
$

= Linear-Chain Conditional Random Fields

== Inference

== Learning
