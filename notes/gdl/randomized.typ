#import "@local/note_template:0.1.0": *
#show: doc => note_template([Randomized Architectures], doc)

#title()

An alternative approach to train deep architectures is *reservoir computing*,
that is the base of *randomized architectures*. The idea is to build a deep
neural network, randomly initialize the weights and only train a *readout* layer
that can be task specific.

In this way is still possible to enrich the input space with high-dimension and
nonlinear transformations. The *Cover's theorem* supports these kind of
architectures.

In the case of RNNs this is equivalent to giving up learning recurrent dynamics

$ h_t = tanh(W_in x_t + W_h h_(t-1)) $

and only learn the output weights

$ y_t = W_"out" h_t $

Of course, for non-trivial tasks, a general whatsoever random initialization
could be problematic. We need weights, and more precisely the transformation
they define, to be contractive on average.

The core theoretical condition to make these models work is the *echo state
property (ESP)*:

$ lim_(k->oo) pdv(h_t, h_(t-k)) = lim_(k->oo) product_(i=t-k+1)^t J_i = 0 $

For an RNN this means to have a memory decay that can translate into
independence from initial conditions. In order to not trigger the *catastrophic
forgetting* phenomenon that prevents RNNs to remember long-range dependencies
the memory should be contractive but still with a spectral radius near to 1.

= Echo State Networks

Randomized architectures with echo state property give birth to *echo state
networks (ESN)*, whose usual workflow includes a *washout* of initially
generated hidden states.

More precisely, the readout is not trained on the error due to first states; it
also depends on the task, for example for sequence classification and a long
sequence, the ESP alone does the trick. Instead for sequence labeling or
autoregressive task the washout is needed.

The nice thing about ESNs is that the readout is typically linear and so trained
either by gradient descent or direct methods

$ W_"out" = Y H^TT (H H^TT + lambda I)^(-1) $

making these networks very efficient to train.

