#import "note_template.typ": *
#show: note_template

#title("Gradient Descent")

The #strong[gradient descent algorithm] is one of the fundamental pieces of
machine learning and optimization.

In order to perform this algorithm it’s necessary to compute the
#strong[gradient] of a function at a given point.

#note(title: "Gradient")[
  The gradient is a vector such that each of its components is the partial
  derivative of that function with respect to a different variable.

  $
    mat(
      delim: "[", frac(partial f (x), partial x_1); dots.v; frac(
        partial f
        (x), partial x_n
      )
    )
  $

  where $f$ is a function that takes in a vector $x$ of $n$ components and $x_i$
  is one of them.
]

The #strong[gradient at a point] is a vector pointing in the direction of the
steepest slope at that point.

#note(title: "Partial Derivative")[
  The #strong[partial derivative]
  $ frac(partial f (x), partial x_i) $
  of a function $f$ with respect to a variable $x_i$ is the derivative of the
  function $f$ considering every term different from $x_i$ as a constant.
]

So the gradient shows where the function grows, on the other hand, its negative
shows where the function #emph[decreases];.

= Algorithm <algorithm>

In machine learning we want to #strong[minimize an error] that is often a
#strong[quadratic] (#emph[mean square error];), so we deal with a differentiable
function that is well suited for the gradient descent approach.

The basic idea is to build an iterative algorithm that, step by step, get closer
to the minimum of error function, using the gradient to compute the direction.

A more compact notation uses $Delta w$ to indicate the *negative gradient* of
the error function $E (w)$. This lead to the definition of the an iterative
formula describing the new vector $w$ of weights

$ w_(upright("new")) = w + eta dot.op Delta w $

This is called #strong[learning rule] and the parameter $eta$ is the #emph[step
  size];, often called #strong[learning rate] in a machine learning field, and
rule the speed of the gradient descent.

+ Typically the algorithm starts with a weight vector $w_(upright("initial"))$
  that is #emph[small] and a fixed learning rate $0 < eta < 1$.
+ Then there is the computation of the negative gradient $Delta w$.
+ In the end the new weights vector is computed with the learning rule defined
  before.

The second and third steps are repeated until convergence or until the error is
small enough.

This algorithm has three versions, in order to optimize speed and stability

- #strong[Batch];: compute the total error of all the $l$ patterns in the
  dataset at each step. It’s typically slower but more stable. It works well
  also with medium or higher values of $eta$ due to the fact that the error is
  very precise.
- #strong[Stochastic];: the error (and so the gradient) is computed on only one
  pattern and the weights are updated immediately. The computed error has of
  course lot of noise, due to the fact that is computed on only one pattern, but
  on the other let the algorithm move fast towards the minimum. To be stable
  enough is needed a low $eta$ and once all patterns are finished the algorithm
  restart from the first unitl convergence.
- #strong[Mini-Batch];: hybrid version between the other two that partionate the
  dataset, comnpute the error only on that partition and then update weights. If
  correctly setted up can be a good trade off between speed and stability.

The gradient descent can be seen as an error correction rule that typically
tries to change a weight $w_j$ proportionally to the error $y_i - h_w (x_i)$.

= References <references>

- Least Squares
- Linear Models
- Neural Networks
