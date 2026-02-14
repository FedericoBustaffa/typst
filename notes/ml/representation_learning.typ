= Representation Learning
<representation-learning>
#strong[Representation learning] is a concept related to the fact that
deep learning allows a network to automatically discover representations
needed for a specific task.

In general, in computer science is true that a task that involves
information processing of some kind can be very easy or very difficult,
depending on information representation.

A good representation often makes the task easier, but for some problems
a manual design of feature representation is very challenging. In ML
words, engineering the $phi.alt (x)$ function of LBE is often very
difficult. Neural networks, and in particular deep ones, can learn the
$phi.alt$ function. This is because for them $phi.alt$ is also a
function of the weights: $phi.alt (x , w)$, and so can be learned.

A deeper aspect is the fact that neural networks, automatically find
#strong[hidden] representations or structure in information, that is way
more difficult for a human.

== Pre-Training
<pre-training>
In order to obtain #emph[hidden representations];, one historical case
is #strong[pre-training];, that exploit the concept of
#strong[semi-supervised learning];.

To perform #emph[pre-training] is necessary to build an
#strong[autoencoder];, that at its core, is a network that tries to
reproduce its input.

One of the first methods to train a deep neural network without
backpropagation is proposed by the #strong[Bengio algorithm];, that
performs a so called #strong[greedy layer-wise unsupervised
pre-training] by training a multi-layer network one layer at a time.

+ Start with a single layer network that tries to reproduce its input.
+ Remove the output layer and add a new hidden layer. This hidden layer
  is trained to reproduce the output of the previous layer.
+ Repeat until the desired number of layers is reached. At each step
  weights of already trained layers are freezed; only one layer at a
  time is trained.
+ In the end add a #emph[task layer] for supervised task, that will be
  trained on actual targets.

In the end the effect is that hidden layers contains hierarchical
representations of the world, but not a specialized way for the task,
like for a modern MLP, trained end-to-end with backpropagation.

This might not work as well as a network fully specialized for a
specific task, but has some interesting implications.

First of all, all layers but the last, contains good representations and
so good starting weights for a generic supervised task. It also works as
a regularization technique because it smooths the noise, and reduce
probability of overfitting.

On the other hand a too extreme compression may end up flattening
crucial differences in input data; while a mapping to higher
dimensionality can cause loss of relationships.

== Transfer Learning
<transfer-learning>
Once hidden representations are available, with #strong[transfer
learning] is possible to use them for supervised tasks like
classification and regression.

This is done under the assumption that some features discovered in the
pre-training phase are useful for different tasks.

So now is also possible to use a pre-trained model for different tasks
without the need to retrain it entirely; the only thing needed to be
retrained is the output layer to make predictions.

Is also possible to change the input domain under the assumption that
some learned features between different domains are shared.

== Distributed Representation
<distributed-representation>
Deep learning also brings to the table the concept of
#strong[distributed representation] of data, that tries to improve to
the #strong[symbolic] one.

There are fields, like in NLP, where data has no mathematical meaning
(or at least it’s not clear to define o recognize it); in fact words
cannot be easily mapped in a vectorial space because their meaning,
context and semantics are something too abstract.

Intuitively we can say that "cat" is more similar to "dog" than "train",
but how to map this to math is not trivial at all. The simplest way is
for example by doing a one-hot encoding of every word in a vocabulary,
but this results in a vector space with $N$ dimension where $N$ is the
number of words in the vocabulary. Let’s also notice that every word is
distant $sqrt(2)$ from every other, so is pratically impossible to catch
any relation between couples of words.

But here is the deep learning trick that let a model learn a meaningful
representation automatically. Starting from a #emph[one-hot] encoded
dataset, is possible to train an autoencoder with text so that it learns
how much words are related just by looking at things like occurences in
similar sentences.

In this way is possible to go from a one-hot representation to a
vectorial representation with each entry being a continuous value. We
can imagine that the net learns the concept of animal in some sense and
so now "cat" and "dog" are closer in the new space with respect to
"train".

This new representation also #strong[quantify] how much of a feature is
present in a certain word. For example let’s assume we want to represent
4 concepts: #emph[blue car];, #emph[red car];, #emph[blue bike] and
#emph[red bike];.

First of all 4 neurons are not necessary, 2 are sufficient because we
can reason in a complementary way. One neuron take care of the color and
the other of the object.

So the first learns something like the #emph[redness] regardless the
context; it does not learn what is a red car specifically, but it only
learns how to recognize #emph[red];.

This implies that a network can learn the concept of red bike without
ever seen it during the training: it’s sufficient that it knows what is
a #emph[bike] and what is #emph[red];.

More in general we can say that, for a discrete case scenario, a
distributed representation, can use $n$ features with $k$ values to
describe $k^n$ different concepts.

Is also possible to encode binary features of dimension $N$ with
distributed representation by assigning a unique code to an exponential
number of regions: $O (2^n)$.

In general, models based on distributed representation are able to
distinguish exponentially many more regions than others like #emph[K-nn]
or #emph[SVMs];.

=== Shared Attributes
<shared-attributes>
Having data sharing some feature let the model disentagle a concept from
the example given in training, and so is possible to generalize well on
unseen configurations by reasoning in mutually exclusive way.

This is widely used in NLP fields and its interesting how a neural
network is able to catch hidden relationships between words in
mathematical and statistical way, while humans don’t think like that at
all. A famouse example of this is given by #strong[word embeddings]
(like #strong[word2vec];) that is a proof of how a neural network is
able to catch semantics of a language just by looking at texts. This can
imply that language has the compositionality inductive bias that let a
neural network learn it.

== References
<references>
- \[\[deep\_learning\]\]
