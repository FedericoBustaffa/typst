= Convolutional Neural Network
<convolutional-neural-network>
The name #strong[convolutional neural network] takes inspiration from
the #strong[convolution] operation that, conceptually, is a weighted
average of a function $f$, weighted by another function $g$ moved over
time.

$
  (f \* g) (x) = integral_(- oo)^oo f (tau) dot.op g (x - tau) #h(0em) d tau = integral_(- oo)^oo f (x - tau) dot.op g (tau) #h(0em) d tau
$

We can imagine $g$ limited in an interval (window) and we let it
#emph[slide] over $f$; the convolution on a point $x$ is computed as a
sum of products of $f (x)$ for every $g (x)$ in the window.

#figure(
  image("images/function_convolution.png"),
  caption: [ Convolution ],
)

In convolutional neural networks the output of a unit $t$ can be
something like

#figure(
  image("images/sliding_window_nn.png"),
  caption: [ Sliding Window ],
)

== References
<references>
- \[\[neural\_networks\]\]
- \[\[deep\_learning\]\]
