#import "@local/note_template:0.1.0": *
#show: doc => note_template([Latent Dirichlet Allocation], doc)

#title()

A model whose goal is to encode high-dimensional discrete data in a
lower-dimensional latent space is *latent dirichlet allocation (LDA)*.

#figure(
  image("images/lda.png", width: 25%),
  caption: [ Latent Dirichlet Allocation ],
) <fig-lda>

The motivation for the model is simple: high-dimensional data features, often
relate one another hence, is reasonable to think there is some lower-dimensional
latent structure that can embed the original data. This of course let
dimensionality reduction, making easier to work with these kind of data.

The most intuitive setting to figure out LDA is by thinking it as a *topic
model* that works on documents in a *bag-of-words* representation.

The dataset is composed by $N$ documents composed by words from a vocabulary of
$V$ elements and we want to assign each word in the document to one of the $K$
possible latent *topics*.

The _bag-of-words_ representation does not account for ordering of words hence,
a single document $d$ can be represented either by the word sequence

$ w^((d)) = (w_(d 1), dots, w_(d L_d)) $

but this has the problem that document with different lengths are represented
with vectors of different lengths. An equivalent and size-preserving method is
by *word counts*

$ n_d = (n_(d 1), dots, n_(d V)) quad "with " sum_(v=1)^V n_(d v) = L_d $

where $V$ is the vocabulary size. In this way each document vector has length
$V$ and the whole dataset can be represented as a $N times V$ matrix.

The conceptual shift w.r.t. GMMs is that we don't want to assign a topic to a
document, instead LDA assigns a topic to each word in the document. In this
sense is like a _multinomial mixture model_ that runs inside each document,
clustering words by topic.

In this way is possible to assign to each word a probability distribution,
describing how likely is for that word to belong to each possible topic.

= Generative Process

This models combines three distributions:

- *Dirichlet prior* over document-specific topic proportions.
- *Categorical over topics* for each token.
- *Categorical over words* for each topic.

The most interesting thing is that topic proportions are drawn from another
distribution that is a dirichlet:

$ theta_d tilde "Dirichlet"(alpha) $

that is the natural conjugate prior for categorical distributions, so that the
posterior over $theta_d$ will also remain a Dirichlet.

#note(title: [Effect of Parameter $alpha$])[
  Let's define the effect of the $alpha$ parameter by considering a simple case in
  which $alpha_k = alpha$ for all $k$; there are three main behaviors:

  - $alpha >> 1$: the mass concentrates near uniform topic mixtures, so documents
    tend to use many topics with similar proportions.
  - $alpha approx 1$: fairly diffuse topic mixtures with some variability.
  - $alpha << 1$: mass concentrates near the corners of the simplex so every
    document tend to contain words about few specific topics.
]

For each of the $N$ documents the generative process is

+ Draw topic proportions for document $d$:
  $ theta_d tilde p(theta_d | alpha) = "Dirichlet"(alpha) $
+ For each token position $l_d = 1, dots, L_d$:
  + Draw a topic assignment
    $ z_l_d tilde p(z_l_d | theta_d) = "Categorical"(theta_d) $
  + Draw a word from the vocabulary conditioned by the topic
    $ w_l_d tilde p(w_l_d | z_l_d = k, beta) = "Categorical"(beta_k) $

Therefore, the equivalent joint distribution for one document is

$
  p(theta_d, vb(z)_d, vb(w)_d | alpha, beta) = p(theta_d | alpha)
  product_(l_d=1)^L_d p(z_l_d | theta_d) p(w_l_d | z_l_d, beta)
$

For the whole corpus, assuming documents are conditionally independent given the
global parameters, the joint probability distribution is

$ p(cal(D) | alpha, beta) = product_(d=1)^N p(w_d | alpha, beta) $
