#import "@local/note_template:0.1.0": *
#show: note_template

#title("Decision Tree")

The #strong[decision tree] model (#strong[DT];) can be used for both
classification and regression tasks; however its structure suggests a propensity
for classification.

Their intrinsic tree representation also makes them easily interpretable,
providing critical points where their classification changes; that’s why they
are also widely used in Explainable AI.

More formally we can see decision trees as a disjunction of conjunctions, or a
chain of #emph[if-then-else] rules. This is because the decision tree
#emph[splits] the feature space at each iteration, considering one
feature/dimension at a time.

#figure(
  image("images/decision_tree_regions.png", width: 70%),
  caption: [ Decision Tree Regions ],
)

A general decision tree algorithm is the following

+ Select the #strong[best feature] to perform a split.
+ Split the dataset in as many subsets as the number of possible values for the
  selected feature.
+ Repeat until all the examples are correctly classified or there are no
  examples left.

In this algorithm is mentioned #emph[the best feature];, but the way to choose
the best feature can discriminate between different possible DT algorithms.

= Entropy <entropy>

The first type of DT algorithm (like ID3) uses #strong[entropy] to measure the
#strong[impurity] of a subset of examples. This is a measure, going from $0$ to
$1$, of how much the set is #emph[bad] classified.

In other words a set of patterns with half of the patterns classified as $-1$
and the other hald as $+ 1$ has maximum entropy (high impurity), while a set
with all the examples classified as $+ 1$ has $0$ entropy (low impurity).

In order to compute the entropy of a set of examples $S$ we can use this
formula:

$ upright("Entropy") (S) = - p_(+) log_2 (p_(+)) - p_(-) log_2 (p_(-)) $

where $p_(+)$ and $p_(-)$ are respectively the proportions of positive and
negative patterns ($0 lt.eq p_(-) , thin p_(+) lt.eq 1$).

So for two classes we have that the entropy has a maximum where the proportion
is $0.5$ and minimum when all the patterns are classified the same.

#figure(
  image("images/entropy.png", width: 70%),
  caption: [ Entropy ],
)

The entropy alone cannot be used to select the best feature for the split
because it doesn’t consider any feature in the formula, it’s just a measure of
the impurity of the subset.

= Information Gain <information-gain>

In order to select the best feature for the split we need a measure of how much
splitting the dataset with respect to every feature lowers the entropy. This
measure is called #strong[information gain] and measures the expected reduction
in entropy caused by partitioning the examples on a feature:

$
  upright("Gain") (S , A) = upright("Entropy") (S) - sum_(v in upright("Values")
  (A)) frac(\# (S v), \# (S)) dot.op upright("Entropy") (S v)
$

where

- $upright("Values") (A)$ are all the possible values for the feature $A$
  present in the subset $S$.
- $\# (S)$ is the cardinality of the set $S$.
- $S v$ is a subset of $S$ for which the feature $A$ has value $v$.

The higher the information gain the more effective the feature in classifying
training data will be.

#figure(
  image("images/dt_gain.png", width: 70%),
  caption: [ Gain Split ],
)

The information gain is computed for all the features and the one the highest
gain is selected as the first decision node. When we reach a point where the
entropy is zero for all the branches, it means that the
DT classified correctly every instance.

== Gain Ratio <gain-ratio>

The problem with information gain is that features with many possible values
will be selected more often.

Let’s say for example that in the given dataset, we have $l$ patterns, each with
a different values for $A$. For that features the DT will create $l$ possible
branches, each with one pattern; meaning in a $0$ entropy subset.

This of course perfectly fits the data but does not generalize at all, leading
to overfitting.

In order to generate more informative and general subsets the *gain ratio* is
typically implemented as follows

$
  upright("GainRatio") (S , A) = frac(
    upright("Gain") (S , A),
    upright("SplitInformation") (S , A)
  )
$

where $upright("SplitInformation") (S , A)$ is a measure of entropy $S$ with
respect to the values of $A$ and it is defined as

$
  upright("SplitInformation") (S , A) = - sum_(i = 1)^C frac(\# (S_i), \# (S))
  dot.op log_2 (frac(\# (S_i), \# (S)))
$

where $S_i$ are the sets obtained by partitioning on value $v_i$ of $A$, up to
$C$ values.

The gain ratio penalizes features that split examples in many small classes.

However there are cases were the $upright("SplitInformation")$ can be zero or
very small when $\# (S_i) approx \# (S)$ for some value $i$. An extreme case is
when there is a feature with the same value for all the examples.

To mitigate this is possible to apply some heuristics, for example a very simple
one consists in compute the gain for each feature and then apply the gain ratio
only for features with gain above average.

= Continuous Features <continuous-features>

Let’s say we have a feature that is continuous and so, it most likely be
different for every example. We want to define a threshold on which perform the
split, also trying to maximize the gain.

A possible solution is to:

+ Sort the examples by that feature
+ Determine candidate thresholds by averaging consecutives values where there is
  a change in classification.
+ Evaluate candidate thresholds according to information gain.

For large dataset this is still too expensive and so there are more coarse
grained techniques, like grouping similar values of the feature in bins so that
the bins are representative of a part of the features.

= Overfitting <overfitting>

If we keep the tree train, soon or later it will classify correctly all the
examples, but it will fall inevitably in overfitting. In order to mitigate that,
what we can do is

- Set a #strong[max depth] beyond the tree stops grows. The remaining nodes that
  are still not #emph[pure] will be assigned with the most common
  classification.
- #strong[Pruning] after the tree completed the training and overfit the data.

For the first can be difficult to know which depth is good but can be done via
model selection.

The second consists in prune sub-trees and let the node be a leaf assigned with
the most common classification. Nodes (and their sub-trees) are removed
iteratively only if the resulting pruned tree performs no worse on the
validation set. To be precise, the nodes that are pruned first are the one whose
removal most increase accuracy on the validation set.

The pruning process stops when there are no more gains in accuracy for every
possible pruning.

== References <references>

- Supervised Learning
- Random Forest
