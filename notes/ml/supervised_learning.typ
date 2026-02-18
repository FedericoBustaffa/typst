#import "note_template.typ": *
#show: note_template

#title("Supervised Learning")

In the field of Machine Learning, #strong[supervised methods] involve the model
training by examples. In other words there is an initial phase where we feed the
model with examples that basically are couples, containing a problem and its
solution.

$ chevron.l upright("input, output") chevron.r = (x , y) $

This is typically called, #strong[training set];. There are also other useful
sets, for example #strong[validation] and #strong[test] set, that are used to
measure the model performance and make some adjustments if necessary.

The goal is to make the model adapt to the examples, in order to extract the
general pattern so that it will be able to find solutions for unseen problems.

The two main problems that supervised learning models are called to solve are

- #strong[Regression];: the output value is a real number.
- #strong[Classification];: the output value is a categorical value (a class).

Let’s also clarify that $x$ is a vector of #strong[features];, that can have
different meanings. For example we can have #emph[numerical] features like
weight and height, but we can also deal with #emph[categorical] features, like
the eyes color.

Categorical can indeed be useful and be fundamental in the recognition of
patterns, but indeed we cannot put "#emph[blue eyes];" in a function. It’s
necessary to encode it in numbers, but now we have the problem to decide an
order. Maybe there is an order, but maybe they all have the same
"#emph[weight];".

#note(title: "1-of-k Method")[
  A popular equally weight categorical features is by encoding it in a vector of
  $k$ values, where $k$ is number of possible categories the feature can have,
  building a sort of boolean table.
]

= Model Complexity <model-complexity>

The #strong[model complexity] can be seen as an abstract measure on how flexible
it is, but with flexibility come some issues.

For example, a model that is to simple could never catch the underline behavior
of data, resulting in an #strong[underfitting] situation.

#note(title: "Underfitting")[
  The model has bad results on training data.
]

On the other hand, a very complex (and so very flexible) model can have great
results on training data, but poor results on new problems. This is due to the
fact that all the complexity was used to perfectly fit the example data,
resulting in a situation of #strong[overfitting];.

#note(title: "Overfitting")[
  The model has very good results on training data but bad results on new data.
]

Both situations evidence the inability of a model to #emph[generalize];.

= Number of Examples <number-of-examples>

The number of examples also plays a role in the building of a good model and, in
general, the more data (examples) you have, the better the model will learn.

For example, a fairly complex model feeded with few data, can overfit because it
tries to use all its complexity to better solve the few problems it has. Instead
when we give a lot of data, the model has to try a balance to get the best
result for each problem without losing accuracy.

= References <references>

- Machine Learning
- Linear Models
- KNN
- Perceptron
- Neural Networks
- Support Vector Machine
- Decision Tree
- Ensemble
- Random Forest
