#import "@local/note_template:0.1.0": *
#show: doc => note_template([Latent Dirichlet Allocation], doc)

#title()

A typical situation for discrete high-dimensional data a strong *latent
structure*. Thinking about text, if we a dataset composed of documents, a
_bag-of-words_ representation is high-dimensional and sparse.

Ideally we want a model able to capture a latent and compressed representation
of those documents by clustering words by *topic*.

In this sense we want to assign to each word a probability distribution that
tells us how likely is for that word to belong to a certain topic. The result is
that we can now have a compressed representation of a document that can
partially belong to different topics, depending on words it contains.

It is worth specify that topics are not directly specified but are latent
variables that the model learns autonomously.

Going deeper, a _bag-of-words_ representation doesn't account for words ordering
and only keeps counts. For each document $d$ we have

$ w^((d)) = (w_(d 1), dots, w_(d L_d)) $

or the equivalent count vector

$ n_d = (n_(d 1), dots, n_(d V)) quad "with " sum_(v=1)^V n_(d v) = L_d $

where $V$ is the vocabulary size. A classical mixture model would assign one
latent topic to each document but topics models assign a latent topic to each
token, so that one documetn may combine multiple topics.

In this context one of the simplest topic model is *latent dirichlet allocation
(LDA)*, that does exactly that.

#figure(
  image("images/lda.png", width: 25%),
  caption: [ Latent Dirichlet Allocation ],
) <fig-lda>

This models combines three distributions:

- *Dirichlet prior* over document-specific topic proportions.
- *Categorical over topics* for each token.
- *Categorical over words* for each topic.

The most interesting thing is that topic proportions are drawn from another
distribution that is dirichlet:

$ theta_d tilde "Dirichlet"(alpha) $

that is the natural conjugate prior for categorical distributions, so that the
posterior over $theta_d$ will also remain a Dirichlet.

Let's define the effect of the $alpha$ parameter by considering a simple case in
which $alpha_k = alpha$ for all $k$; there are three main behaviors:

- $alpha >> 1$: the mass concentrates near uniform topic mixtures, so documents
  tend to use many topics with similar proportions.
- $alpha approx 1$: fairly diffuse topic mixtures with some variability.
- $alpha << 1$: mass concentrates near the corners of the simplex so every
  document tend to contain words about few specific topics.

= Generative Process

The *generative process* of LDA is similar to a GMM but with nested
distributions and for each topic $k$, it assumes a topic-word distribution

$ beta_k = (beta_(1 V), dots, beta_(k V)) $

subject to a sum-to-one constraint $sum_(v=1)^V beta_(k v) = 1$. For each
document $d$, the generative process is

+ Draw topic proportions
  $ theta_d = "Dirichlet"(alpha) $
+ For each token position $n = 1, dots, L_d$:
  + Draw a topic assignment
    $ Z_(d n) | theta_d tilde "Categorical"(theta_d) $
  + Draw a word from the vocabulary
    $ W_(d n) | Z_(d n) = k, beta tilde "Categorical"(beta_k) $

Therefore, the equivalent joint distribution for one document is

$
  p(theta_d, z_d, w_d | alpha, beta) = p(theta_d | alpha) product_(n=1)^L_d
  p(z_(d n) | theta_d) p(w_(d n) | z_(d n), beta)
$

For the whole corpus, assuming documents are conditionally independent given the
global parameters, the joint probability distribution is

$ p(cal(D) | alpha, beta) = product_(d=1)^N p(w_d | alpha, beta) $

