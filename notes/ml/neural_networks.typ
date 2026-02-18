#import "@preview/cetz:0.4.2"

#import "@local/note_template:0.1.0": *
#show: note_template

#title("Neural Networks")

When we talk about #strong[neural networks] we are entering in the world of
#strong[deep learning];, and the most simple neural network is the so called
#strong[multi-layer perceptron] (#strong[MLP];), that can be seen as

- A #strong[network] of interconnected units.
- A flexible #strong[function] $h (x)$.

In a MLP architecture

- the units are connected by #strong[weighted links] and they are organized in
  the form of #strong[layers];.
- the #strong[input layer] is simply the source of the input $x$ that projects
  onto the hidden layer of units.
- the #strong[hidden layer] projects onto the #strong[output layer] or to
  another hidden layer.

Let’s take for example this single layer perceptron

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Configurazioni
    let layer-space = 3
    let node-space = 1.2
    let node-radius = 0.4

    // Definizione dei layer (numero di neuroni per layer)
    let layers = (
      (name: "i", count: 2, color: blue.lighten(80%)),
      (name: "j", count: 4, color: green.lighten(80%)),
      (name: "k", count: 1, color: orange.lighten(80%)),
    )

    // 1. Disegno dei nodi
    for (l-idx, l) in layers.enumerate() {
      let x = l-idx * layer-space
      let offset = (l.count - 1) * node-space / 2

      // Etichetta del Layer
      content((x, 2.5), [Layer #l.name])

      for n-idx in range(l.count) {
        let y = n-idx * node-space - offset
        let node-id = l.name + str(n-idx)

        circle((x, y), radius: node-radius, fill: l.color, name: node-id)
        content(node-id, $#l.name _#n-idx$)
      }
    }

    // 2. Disegno delle connessioni (automatico tra layer adiacenti)
    for l-idx in range(layers.len() - 1) {
      let curr-l = layers.at(l-idx)
      let next-l = layers.at(l-idx + 1)

      for i in range(curr-l.count) {
        for j in range(next-l.count) {
          let start = curr-l.name + str(i)
          let end = next-l.name + str(j)

          line(start, end, stroke: 0.5pt + gray)
        }
      }
    }
  }),
  caption: "Multi-Layer Perceptron",
)

As we can see is a composition of units where the notation $w_(j i)$ describes
the weights belonging to the $j$-th unit that connect the $i$-th (in this case
input) unit.

From the functional perspective we have that

$ h (x) = f_k (sum_j w_(k j) f_j (sum_i w_(j i) x_i)) $

represents our network as a composition of non linear functions.

= Notation <notation>

Let’s now introduce some notation that is commonly used, also to move in better
in the backpropagation algorithm.

- #strong[Weight/Connections];: a generic weight is denoted with $w_(j i)$ to
  indicate that a unit $i$ (that can be an input unit or a hidden unit) produces
  an output towards the a unit $j$ (that can be an hidden unit or an output unit).
  In this sense the first index tells the membership of the weight to some unit,
  while the second index tells from which unit the data comes from.
- #strong[Generic unit];: denoted by $t$ and can be hidden or output.
- #strong[Input unit];: denoted by $u$ and can be input or hidden.
- #strong[Input];: inside a specific unit $x$ is a generic input from an
  external source that can be an input unit or an hidden unit.
- #strong[Output];: if we load $x$ in the input layer we can use the notation
  $o$ to denote the output of an input or hidden unit. Inside the network, the
  output from a generic unit $u$ that travels through the connection $w_(t u)$ is
  denoted with $o_u$.

And so for each unit $t$ we have that

$
  cases(
    delim: "{", upright("net")_t (x) & = sum_u w_(t u) x_u, o_t (x) & = f_t
    (upright("net")_t (x))
  )
$

where $upright("net")_t (x)$ is basically the input of node $t$ from the
previous layer and $o_t (x)$ is the output of the unit $t$, so the input passed
through the activation function $f_t$.

#figure(
  image("images/nn_notation.png", width: 30%),
  caption: [ NN representation ],
)

taking also into account that the bias has a $1$ input on the connection denoted
as $w_(t 0)$.

= Architecture <architecture>

The #strong[architecture] of a neural network defines the topology of the
connections among the units. The classic implementation of an MLP is the well
know #strong[feedforward] neural network where each unit is connected to all the
units of adjacent next layer and so on (fully connected topology).

There are also other topologies where we have connections that bypass some layer
or that can form #strong[loops] in the network, used in the *recurrent neural
networks*.

For the feedforward architecture the processing of an input pattern proceeds
from the input layer to the output layer, through hidden layers, following these
steps:

+ Load the input pattern in the input layer.
+ Compute the output of all the units of the first hidden layer.
+ Compute the output of all the units of the second hidden layer and so on for
  all hidden layers.
+ Compute the output of all the units of the output layer ($h (x)$).
+ Compute the error at the output level.

For the recurrent architecture we have feedback loops that provides the network
with dynamical properties, letting a memory of the past computations.

#figure(
  image("images/recurrent_nn.png", width: 40%),
  caption: [ Recurrent Neural Network Sketch ],
)

This allows to extend the representation capability of the model to the
processing of sequences and structured data.

= Flexibility <flexibility>

The hypothesis space of a neural network the continuous space of all the
functions that can be represented by assigning the weight values of the given
architecture.

Depending on the class of values produced by the network output units (discrete
or continuous), the model can deal, respectively, with classification (sigmoidal
output) or regression (linear output) tasks.

$ h (x) = f_k (sum_j w_(k j) f_j (sum_i w_(j i) x_i)) $

It depends on what that $f_k$ function is. Anyway this is the function computed
by a two layer feedforward neural network, where each $f_j (sum_i w_(j i) x_i)$
can be seen as computed by an independent processing element or a special kind
of $phi.alt$ for the LBE. Let’s notice also that neural networks function is
#strong[non linear in the weights] $w$.

Compared to a linear model with LBE that computes its output as

$ h (x) = f (sum_j w_j phi.alt_j (x)) $

with $f$ that for regression is the identity function and for classification is
some threshold function, but most important $phi.alt$ is fixed before the
computation. A neural network computes something slightly different

$ h (x) = f (sum_j w_j phi.alt_j (x , w)) $

using

$ phi.alt_j (x , w) = f_j (sum_i w_(j i) x_i) $

because now $phi.alt$ depends also on $w$. So now we an #strong[adaptive] basis
functions approach where the basis functions themselves are adapted to data by
fitting the $w$ in $phi.alt$. In this sense $h (x)$ can be seen as a sum of non
linearly transformed linear model with the enhancement of adaptivity.

== Hidden Layers <hidden-layers>

Adding #strong[hidden layers] add complexity to the network because each hidden
unit computes a new non linear function adaptively, this means that the weights
of the basis function are learned from data by learning

$ phi.alt_j (x , w) = f_j (sum_i w_(j i) x_i) $

In other words the representational capacity of the model is related to the
presence if a hidden layer of units, with the use of non linear activation
function, that transforms the input pattern into the *internal representation*
of the network.

The learning process can define a suitable internal representation, also visible
as new hidden features of data, allowing the model to #emph[extract from data]
the higher-order statistic that are relevant to approximate the target function.

Let’s also add that non linear units are essential because an MLP with linear
units is equivalent to a single layer neural network.

Anyway all this flexibility introduces the issue that the model is non linear in
the weights and so we have to solve a non linear optimization problem, that is
in general not trivial.

From the theory we also a very important result that is the *universal
approximation theorem* that states that a single layer network with logistic
activation functions can approximate arbitrarily well every continuous function,
provided enough units.

#important(title: "Universal Approximation Theorem")[
  Given $epsilon$ small, exists $h$ such that $lr(|(f (x) - h (x))|) < epsilon$.
]

This theorem anyway does not provide a number of units or an algorithm for
learning.

This theorem is important because it states that neural networks are very
powerful but in practice using only one layer can be unfeasible, because the
number of units needed can be very high, or even exponential.

Having many layers instead let us reduce the number of units, while enhancing
the approximation capability of the net. Intuitively a nested composition of
smooth non linear functions makes the model less _stiff_, allowing an
easier adaptation.

= Learning <learning>

The last main brick for the network to work is a learning algorithm, but this
time is not so easy as for other models. This is because, for example in a
linear model, the weights are all on the same level and are in sense
#emph[globally] visible.

In neural networks we have hidden layers, each with units that have their
weights. If we notice there is also a sort of temporal relation between the
computation of each layer: of course we can see the network as a big function
composed by many nested function, but it’s clear that there is a forward
propagation of the input and so, the error correction must have a
#strong[backpropagation];. Here the #strong[backpropagation algorithm] becomes
crucial in order to make the network #emph[learn];.

= References <references>

- Supervised Learning
- Perceptron
- Activation Functions
- Gradient Descent
- Backpropagation
- Neural Networks Training
- Deep Learning
- Randomized
- Autoencoder
- Convolutional
- Recurrent
