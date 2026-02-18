#import "@local/note_template:0.1.0": *
#show: note_template

#title("Randomized Neural Networks")

A modern constructive approach for neural networks is the so called
#strong[randomized] approach, that adds a degree of randomness. In particular
#strong[randomized neural networks] can achieve good results with relatively
small computational effort.

A randomized neural network is a normal network that leaves hidden layer weights
frozen after initialization; only the output layer is trained, mitigating the
common problems of training a deep neural network. Advantages of this approach
are that the training is not deep and so the model doesn’t suffer all gradient
issues of a DNN and it also reduces the overall computation time.

For a classification problem we can think for example at a single hidden layer
that is wider than the input. This is like mapping the input in an higher
dimensional space, where could be linearly separable.

This is the same idea of SVMs kernel trick, except that SVMs kernels have to be
#emph[valid];, here we are exposing #strong[random relationships] between data.
It seems strange that such a thing even work but there is theorem that ensures
it.

#important(title: "Cover's Theorem")[
  A complex patter-classification problem, cast in a high-dimensional space
  #strong[non-linearly];, is more likely to be #strong[linearly separable] than
  in a low-dimensional space, provided that the space is not densely populated.
]


For a feed forward neural network this has the effect of #strong[randomized
  basis expansion] that, using many units, results in a sufficient space mapping
to solve the problem also due to non-linearity added by activation functions.

Of course in this way all the advantages of the hierarchical way of learning,
typical of deep learning, are lost but it worth mention. There are also finer
ways of tuning these models like

- Pruning units to reduce model complexity.
- Add hidden units to increase model complexity and flexibility during training
  or model selection.

= References <references>

- Neural Networks
- Deep Learning
