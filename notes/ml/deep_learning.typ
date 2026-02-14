= Deep Learning
<deep-learning>
It’s possible to start talking about #strong[deep learning] for neural
network with more than three layers. Implications of #emph[deep
learning] are mainly

- #strong[Hierarchical feature learning];: each layer produce the input
  for the next one, that sees the output of the previous as features.
  This relaxes the usually needed preprocessing that developers need to
  do.
- #strong[Distributed representation learning];: the network can learn
  patterns that can be used like #emph[building blocks] in order to
  - #strong[Generate] new data obtained by composition.
  - Learn a #emph[concept] #strong[by exclusion];: the network can learn
    something that is in some sense #emph[complementary] to what is
    present in the training set.
  - Learn a #strong[continuous representation] of a concept
    (particularly useful for categorical data).

The need for #strong[deep learning] is justified by the fact that, yes
we have the #strong[universale approximation theorem];, but it does not
provide informations on the number of units.

For many modern problems, a single layer network would require an
exponential number of units to achieve good performance. In general, a
deep network can achieve same performance as a flat one, but with much
less units.

#quote(block: true)[
\[!NOTE\] No-Flatten Theorem There is also a #emph[pseudo-theorem];,
called #strong[no-flatten] that want to define better where a flat
network requires (in practice) a unfeasible number of units.
]

So the problem of a single layer network can be either the expressity
power or the efficiency issue of having too many units.

== Inductive Bias
<inductive-bias>
Of course this kind of architecture brings a #strong[inductive bias]
assuming that the function the network is trying to learn is a
#emph[composition] of functions (or at least that there is a nested
factor of variation).

If the task match this bias is generally a good idea to have a
#emph[deep] architecture. This is typical with image recognition, where
usually the first layer learns only very specific segments and, going
deeper, it starts to build much more complex structures that in the end
put together to recognize handwritten digits, animals and so on.

Notice also that this bias is quite general, so is no big deal if the
function to learn does not have any compositional hidden structure.

== Curse of Dimensionality
<curse-of-dimensionality>
Many learners rely on #strong[local approximation] by assuming that, for
two different points in a very small region of space, the true function
output should be very similar for both.

The problem is that they lack in generalization of the surroundings for
which they don’t have examples to train on. This problem is also
amplified in highly dimensional spaces, where points are more
#emph[sparse] and the uncertainty is way higher between them.

So make assumptions is needed to have a non local generalization in an
exponential number of regions with respect to the number of examples.
The stronger the assumption, the less is the uncertainty. Of course the
assumption could be completely wrong, leading to bad results.

Deep learning approaches instead rely on a compositional and
hierarchical inductive bias, allowing the model to represent complex
functions through reusable and distributed features.

The hierarchical way of learning, potentially increases the number of
regions that can be distinguished by an exponential factor. In other
words the model has a quite general inductive bias, but can also
generalize well in regions of space far from examples that share
underlying structure.

== Representation Learning
<representation-learning>
#strong[Representation learning] is a concept related to the fact that
deep learning allows a network to automatically discover representations
needed for a specific task.

In general, in computer science is true that a task that involves
information processing of some kind can be very easy or very difficult,
depending on information representation.

A good representation often makes the task easier, but for some problems
a manual design of feature representation is very challenging. A neural
network can automatically find #strong[hidden] representations or
structure in information with training, that is way more difficult for a
human.

== References
<references>
- \[\[neural\_networks\]\]
- \[\[neural\_networks\_training\]\]
- \[\[deep\_learning\_techniques\]\]
