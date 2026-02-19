#import "@preview/cetz:0.4.2"
#import "@local/note_template:0.1.0": *
#show: doc => note_template([Backpropagation], doc)

The *backpropagation* basically the most important algorithm in deep learning,
because let a neural network learn through multiple layers.

The key idea to understand backpropagation is that we want to know how much
every unit contributed to the final output and so to the final error.

= Base Case <base-case>

In order to understand the backpropagation is sufficient to build a very simple
network with one neuron per layer and consider only one training example.
Scaling the computation to general case is pretty straightforward.

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Configurazioni
    let layer-space = 3
    let node-space = 1.2
    let node-radius = 0.5

    // Definizione dei layer (numero di neuroni per layer)
    let layers = (
      (name: "i", count: 1, color: blue.lighten(80%)),
      (name: "j", count: 1, color: green.lighten(80%)),
      (name: "k", count: 1, color: orange.lighten(80%)),
    )

    // 1. Disegno dei nodi
    for (l-idx, l) in layers.enumerate() {
      let x = l-idx * layer-space
      let offset = (l.count - 1) * node-space / 2

      // Etichetta del Layer
      content((x, 1.2), [Layer #l.name])

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

Assuming $y$ is the target value, is possible to compute the error (MSE in this
case) between $y$ and $o_k$, that is the network’s output for input $x$.

$ E (w) = (o_k - y)^2 $

The only contribution to the final error is given by $o_k$ and so it must be
modified to decrease the error. In order to minimize the error it’s necessary to
compute the gradient of the error function with respect to $o_k$.

$ frac(partial E, partial o_k) = 2 dot.op (o_k - y) $

Of course is not possible to modify $o_k$ directly, it’s necessary to unpack it
until we have some free parameters to work on.

$ o_k = sigma (upright("net")_k) $

where $sigma$ is a generic activation function and $upright("net")_k$ is the
input of the node at layer $k$. So now is possible to see how much
$upright("net")_k$ contributes to the error by computing the following partial
derivative

$ frac(partial o_k, partial upright("net")_k) = sigma' (upright("net")_k) $

but again $upright("net")_k$ cannot be modified directly; it’s necessary to
unpack it again

$ upright("net")_k = w_k dot.op o_j + b_k $

where $w_k$ and $b_k$ are respectively weights and bias of layer $k$ and $o_j$
is the output of layer $j$ (the previous). What is important is that $w_k$ and
$b_k$ now are actual scalar we can directly access and optimize. For now we
consider $o_j$ like a constant.

$
  frac(partial upright("net")_k, partial w_k) = o_j quad frac(
    partial
    upright("net")_k, partial b_k
  ) = 1
$

Putting everything together gives us the gradient of $E$ with respect to $w_k$
and $b_k$ that, for the *chain rule* of derivatives are

$
  frac(partial E, partial w_k) = frac(partial E, partial o_k) dot.op
  frac(partial o_k, partial upright("net")_k) dot.op frac(
    partial
    upright("net")_k, partial w_k
  )
$

and

$
  frac(partial E, partial b_k) = frac(partial E, partial o_k) dot.op
  frac(partial o_k, partial upright("net")_k) dot.op frac(
    partial
    upright("net")_k, partial b_k
  )
$

that in more compact way can be written as

$
  delta_k = frac(partial E, partial o_k) dot.op frac(
    partial o_k, partial
    upright("net")_k
  ) #h(2em) o_j = frac(partial upright("net")_k, partial w_k)
$

and so

$ frac(partial E, partial w_k) = delta_k dot.op o_j $

== Hidden Layers <hidden-layers>

The key now is to repeat the same process also for the hidden layer/unit $j$,
updating its free parameters. Starting to the fact that the contribution to
$upright("net")_k$ is given by $w_k$, $b_k$ (already updated) and $o_j$.

$ frac(partial upright("net")_k, partial o_j) = w_k $

and so

$
  frac(partial E, partial o_j) = frac(partial E, partial o_k) dot.op
  frac(partial o_k, partial upright("net")_k) dot.op frac(
    partial
    upright("net")_k, partial o_j
  )
$

Again we have that

$ o_j = sigma (n e t_j) $

and so the contribution of $upright("net")_j$ to $o_j$ is

$ frac(partial o_j, partial upright("net")_j) = sigma' (upright("net")_j) $

As before we have that

$ upright("net")_j = w_j dot.op o_i + b_j $

and so we can again optimize the free parameters

$
  frac(partial upright("net")_j, partial w_j) = o_i #h(2em) frac(
    partial
    upright("net")_j, partial b_j
  ) = 1
$

But now the full formula to update $w_j$ is

$
  frac(partial E, partial w_j) = frac(partial E, partial o_k) dot.op
  frac(partial o_k, partial upright("net")_k) dot.op frac(
    partial
    upright("net")_k, partial o_j
  ) dot.op frac(
    partial o_j, partial
    upright("net")_j
  ) dot.op frac(partial upright("net")_j, partial w_j)
$

But if we take a look we have that

$
  frac(partial E, partial o_k) dot.op frac(
    partial o_k, partial
    upright("net")_k
  ) = delta_k #h(2em) frac(
    partial upright("net")_k, partial
    o_j
  ) = sigma' (upright("net")_j)
$

and so it’s clear that

$ delta_j = delta_k dot.op w_k dot.op sigma' (upright("net")_j) $

This should give a rough idea of _propagating backward_ hence $delta_j$ is
function of $delta_k$, computed in the $k$-th layer. The rest is exactly the
same and of course the algorithm exploit that it’s not necessary to compute
again the entire chain every time.

== General Case <general-case>

In order to apply the backpropagation in a classic multi-layer perceptron
topology not much changes.

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

What in the previous case we considered scalars are now vectors or matrices, for
example weights and biases. So we can think about every operation in a vectorial
form or in an element-wise way.

What can actually change is that to think at the algorithm in terms of
mini-batch or full batch, is necessary to add the formula for the MSE for a
batch of samples.

== References <references>

- Neural Networks
- Neural Networks Training
