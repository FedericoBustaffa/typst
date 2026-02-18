#import "@local/note_template:0.1.0": *
#show: note_template

#title("Activation Functions")

Until now we used a #strong[step] activation function that is the sign of
weighted sum of weights and features, but there are many types of activation
function that can lead to differences in training. The three main types of
activation functions are

+ #strong[Linear];: not a real activation function because it produces a real
  value that can’t be used to make classifications.
+ #strong[Threshold];: like the step function used in the perceptron.
+ #strong[Non linear];: generally a non linear #emph[squashing] value function.

This last type has the property to be smoothed differentiable threshold
function.

= Sigmoids <sigmoids>

In the #strong[sigmoidal] type of functions there are two that are often used as
activation functions: #emph[logistic] and #emph[hyperbolic tangent];.

The #strong[logistic] function is defined by the following formula

$ f_sigma (x) = frac(1, 1 + e^(- a x)) $

where $a$ indicates the slope of the function (the higher it is the steeper the
curve will be). It is defined for all $x in bb(R)$ and produces real values in
the range $[0 , 1]$.

The #strong[hyperbolic tangent] is quite similar but produces real values in the
range $[- 1 , + 1]$ and can be defined as

$ f_(upright("symm")) = 2 f_sigma (x) - 1 = tanh (frac(a x, 2)) $

where $a$ has the same meaning of the logistic function. Note also the $a = 0$
lead to a linear function, while $a arrow.r oo$ lead to a step function.

For the logistic function generally an output value greater or equal to $0.5$
(the threshold) correspond to the positive class, while a lower value correspond
to the negative class.

The difference from the LTU is that is possible to change this threshold and
even consider a #emph[rejection zone] around the threshold in order to avoid
fragile decisions.

For the $tanh$ the threshold is in $0$ but is possible to do the same as the
logistic.

== Differentiability <differentiability>

An interesting aspect for activation functions emerges by seeing at their
#strong[derivatives];:

- #strong[Threshold];: not defined, in fact is not used in LMS.
- #strong[Sigmoids];: for $a = 1$ we have
  $
    frac(d f_sigma (x), d x) & = f_sigma (x) (1 - f_sigma (x)) \
     frac(d f_tanh (x), d x) & = 1 - f_tanh (x)^2
  $

The fact that sigmoids are #strong[differentiable] lead to the possibility for a
gradient based algorithm.

= Rectifiers <rectifiers>

Just to list them, there are many other activation functions that behave in many
different ways and used for different purposes, here some of them:

- #strong[Rectifier];: one of the most popular in Deep-Learning is the
  #strong[ReLU] (rectified linear unit) $ f (x) = max (0 , x) $
- #strong[Leaky ReLU];: like ReLU but with learning also on negative
  part:
  $
    f (x) = cases(
      delim: "{", 0.01 x & upright("if ") x < 0, x & upright("if ")
      x gt.eq 0
    )
  $
- #strong[ELU];: exponential function on negative part:
  $
    f (x) = cases(
      delim: "{", alpha (e^x - 1) & upright("if ") x < 0, x &
      upright("if ") x gt.eq 0
    )
  $
- #strong[Softplus];: a smooth approximation of ReLU:
  $ f (x) = ln (1 + e^x) $

Most of them perform comparable but of course there are some that became popular
for different reasons and based on the field of applications.

= Other Activation Functions <other-activation-functions>

- #strong[Radial basis];: used in #emph[RBF] networks; one example is the
  gaussian $ f (x) = e^(- a x^2) $
- #strong[Softmax];: used for multiple output classifications.
- #strong[Stochastic neurons];: output will be $+ 1$ with probability
  $P ("net")$ or $- 1$ with probability $1 - P ("net")$.

= References <references>

- Perceptron
- Neural Networks
- Neural Networks Training
- Deep Learning Techniques
