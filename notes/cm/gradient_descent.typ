#import "@local/note_template:0.1.0": *
#show: doc => note_template([Gradient Descent], doc)

#title()

The *gradient descent* algorithm is a numerical approach to solve optimization
problems like _least squares_ in which we have to minimize a function.

Since direct methods may be costly for high-dimensional data this iterative
method is generally cheaper and in many cases also more numerically stable.

The method assumes that the function to optimize is differentiable and it starts
from an initial guess solution $x_0$ and through a process it produces a
sequence

$ x_0, x_1, dots, x_n $

the should converge towards an optimal solution. The aim of this algorithm is to
have a monotonic sequence in which $x_(i+1)$ is better than $x_i$ and in order
to do that we

