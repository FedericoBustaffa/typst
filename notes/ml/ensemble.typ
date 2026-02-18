#import "note_template.typ": *
#show: note_template

#title("Ensemble")

Training models on different training sets, generally leads to obtain different
models. It is possible to take advantage of this fact by using them together in
a so called #strong[ensemble];, that can be exploited in many different ways.

= Bagging <bagging>

The simplest ensemble is the #strong[bagging];, where every model basically
produce an output and the final output will be:

- The #strong[average] in case of #emph[regression];.
- The #strong[majority vote] in case of #emph[classification];. Or the sign of
  the mean of the continous outputs.

This is generally convenient because high variance models can perform well on
average. Or in other terms, the average of $h$ reduce the variance.

= Boosting <boosting>

The #strong[boosting] consists in differentiate each trainings focusing on
errors by training multiple classifiers one after the other. In each iteration
the new classifier is trained weighting more the examples misclassified before.

The final output will be a combination of weighted votes, where classifiers with
a lower error rate weight more.

This technique improve a lot capabilities of so called #emph[weak learners]
that, eventually could classify correctly every pattern.

= References <references>

- Supervised Learning
- Bias Viariance
- Random Forest

