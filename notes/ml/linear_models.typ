= Linear Models
<linear-models>
#strong[Linear models] are in a sense the baseline for many other
machine learning models, cause it introduces many recurring aspects and
most important is quite simple.

Generally speaking is better suited for regression but can be used for
classification as well, but for this specific task there are other
models with different approaches able to provide better results.

In both cases the model have a #emph[inductive bias] that is a
#emph[guess] on which the objective function would be. In other words,
by observing data or by observing model results, we need to choose an
#strong[hypothesis function] in advance.

Once chosen an hypothesis function, the model will try to fit the data
with that function. In theory, the more complex is the function, the
better the model will fit the data.

== Regression
<regression>
Let’s start from the #strong[regression] task, where the model,
basically receives $l$ patterns and tries to minimize the error between
the hypothesis function and the input patterns.

=== Univariate Linear Regression
<univariate-linear-regression>
The simplest case of linear regression is #strong[univariate];, in other
words we have a training set composed by $l$ patterns that are couples
of real numbers

$ (x , y) $

The simplest function we can think of is of course a straight line, that
will be out hypothesis function

$ h_w (x) = w_0 + w_1 x $

where $w$ is the vector of coefficients of the function to approximate,
usually called #strong[weights];.

We are moving in an infinite hypothesis space, because we have to find
the best $w$ to fit the data, but all elements of $w$ are real numbers.

To move towards the best solution by minimizing the #strong[loss
function];, and the most popular is the #strong[mean square error]
(#strong[MSE];).

$ upright("Loss") (h_(upright(bold(w)))) = E (upright(bold(w))) = 1 / l sum_(p = 1)^l (y_p - h_w (x_p))^2 $

that in the case of a linear regression is

$ 1 / l sum_(p = 1)^l (y_p - (w_1 x_p + w_0))^2 $

where $x_p$ is the $p$-th input (or pattern), $y_p$ is the $p$-th output
for $x_p$ and $l$ is the number of examples.

#quote(block: true)[
\[!HINT\] Why the mean? Minimize the #strong[total] error or the
#strong[mean] gives the exact same line, but usually the mean error is
useful for two reasons:

- #strong[Comparison];: it’s simpler to compare with the error on a
  different dataset or different model (or both) whose data are in the
  "same domain". For example if we consider a dataset of $100$ patterns
  and another one of $100.000$ patterns, the total error in the second
  case will be higher but not because of a bad fitting.
- #strong[Scaling];: as anticipated before, the mean brings the total
  error back to the problem scale. This is useful for comparison but
  also because is more understandable from a human perspective. The
  total error is not directly #emph[usable] to have an idea on the model
  performance.
]

So we need to solve a #strong[least (mean) square] (#strong[LMS];)
problem, that is usually the standard to solve overdetermined systems.
To do that we basically need to compute the #strong[gradient] of the
loss function, in order to find its minimum

$ frac(partial E (upright(bold(w))), partial w_i) = 0 $

For the simple linear regression we have only two free parameters and so
we can find the $upright(bold(w))$ such that

$ frac(partial E (upright(bold(w))), partial w_0) & = - 2 dot.op (y - (w_1 x + w_0)) & = 0\
frac(partial E (upright(bold(w))), partial w_1) & = - 2 dot.op (y - (w_1 x + w_0)) dot.op x & = 0 $

Of course we can then perform a sum over all patterns, obtaining

$ frac(partial E (upright(bold(w))), partial w_0) & = - 2 sum_(p = 1)^l (y_p - (w_1 x_p + w_0))\
frac(partial E (w), partial w_1) & = - 2 sum_(p = 1)^l (y_p - (w_1 x_p + w_0)) dot.op x_p $

because the derivative of a sum is the sum of derivatives.

=== Multivariate Linear Regression
<multivariate-linear-regression>
For the #strong[multivariate] case there isn’t much more to say except
that we need a more general notation, in order to be able work with
$n$-dimensional inputs.

So from now on $x$ is a vector $upright(bold(x))$ and we want to
multiply each feature for one of the weights in order to build the
hypothesis function

$ h_(upright(bold(w))) (upright(bold(x))) = w_0 + w_1 x_1 + w_2 x_2 + dots.h.c + w_n x_n $

as we can see the only weight without a feature is $w_0$, but if we add
a $1$ to every $x$ vector in order to pair it with $w_0$, we can now use
the more compact form

$ h_(upright(bold(w))) (upright(bold(x))) = upright(bold(w))^tack.b upright(bold(x)) = upright(bold(x))^tack.b upright(bold(w)) = angle.l upright(bold(w)) , upright(bold(x)) angle.r = sum_(i = 1)^n w_i x_i $

with $w^tack.b = mat(delim: "[", w_0 , w_1 , dots.h , w_n)$ and
$x^tack.b = mat(delim: "[", 1 , x_1 , dots.h , x_n)$. And of course the
the result given from out model for a given input $x_p$ is

$ h_(upright(bold(w))) (upright(bold(x))_p) = upright(bold(w))^tack.b upright(bold(x))_p = sum_(i = 1)^n w_i x_(p , i) $

What remains is to compute a general gradient with respect to a generic
$w_i$:

$ frac(partial E (upright(bold(w))), partial w_i) = - 2 dot.op (y - h_w (x)) dot.op x_i = - 2 dot.op (y - sum_(i = 1)^n w_i x_i) dot.op x_i $

because for every $j eq.not i$ the partial derivative considers every
term different from $w_i x_i$ a constant.

== Classification
<classification>
Linear model can also be used for classification tasks but we this time
the label is something numerical; for a binary classification problem we
can use $- 1 \/ + 1$.

The problem is still solved by computing a regression line, but this
time the output can only be $- 1 \/ + 1$ (or any other encoding of the
two labels) and so we will obtain a line that cut the $x$ axes in a
certain point.

Of course if we give an $x$ value to this line it will return a real
value and so we simply take the sign (in this specific case), in order
to obtain the label.

So in this case our #emph[loss] function (the one we want to minimize)
remains the same, while the hypothesis function become something like

$ h (x) = upright("sign") (upright(bold(w))^tack.b upright(bold(x))) quad upright("output: -1/+1") $

And the point where our line changes sign define the so called
#strong[linear threshold unit] (#strong[LTU];), that in general is an
hyperplane orthogonal to the #strong[decision hyperplane];.

#figure(image("/files/linear_model_binary_classification_with_boundary.png"),
  caption: [
    Linear model binary classification
  ]
)

This model can make mistakes because it doesn’t aim to find the best way
to separate the different labeled data; from the model point of view it
tries to fit data, and so if there is a correlation between
$upright(bold(x))_p$ and the corresponding $y_p$, data with same label
should be in some way #emph[clustered];. In this sense the model
describes #emph[gradually] how the classification changes.

In this case is also possible to compute the error as the number of
misclassified patterns, but this is not a differentiable function, so it
can’t be used to train the model (only after training to measure
performance).

== Learning Algorithms
<learning-algorithms>
In order to solve this two tasks we need a way to minimize the error on
the training set, and this can be done in two main ways:

- #strong[Direct];: analytical method that consists in computing the
  gradient, that, as a derivative for a univariate function, is zero
  where error function has a maxima. Setting the negative gradient to
  zero and solving the system gives us instead a minima.
- #strong[Numerical];: iterative method the uses the negative gradient
  in order to gradually move towards a minimum.

In practice the numerical method is often used because is numerically
more stable, instead the direct method can propagate a big approximation
error, resulting in bad fitting, even though the math is correct.

=== Direct Method
<direct-method>
The direct method differentiates $E (upright(bold(w)))$, obtaining

$ frac(partial E (w), partial w_j) - 2 sum_(p = 1)^l (y_p - x_p^tack.b w) x_(p , j) $

and the try to solve the #emph[normal equations] given by the system

$ (X^tack.b X) w = X^tack.b y $

but if the matrix $X^tack.b X$ is not singular the unique solution is
given by

$ w = (X^tack.b X)^(- 1) X^tack.b y = x^(+) y $

where $X^(+)$ is the pseudoinverse if $X$, that can be computed using
the singular value decomposition

$ X = U Sigma V^tack.b arrow.r.double.long X^(+) = V Sigma^(+) U^tack.b $

in this way we can directly apply the SVD to compute

$ w = X^(+) y $

obtaining the minimal norm solution of least squares problem, that in
this case is

$ min 1 / 2 parallel X w - y parallel^2 $

This is the so called #emph[closed form] and of course this steps form a
learning algorithm, but to solve the system the are many efficient
numerical methods that can be used.

=== Numerical Method
<numerical-method>
The most common way to solve the least (mean) squares problem is
#emph[iterative];, and the algorithm used is named #strong[gradient
descent algorithm];. This is usually preferred to the direct method
because

- Is more efficient (the direct method has cubic complexity with the
  matrix $X$ dimension).
- Is better for approximation with noisy data by stopping before the
  minimum.
- Numerically is more stable.

The key idea is to compute the gradient of the #emph[loss] function with
respect to the weights. The gradient is basically a vector pointing in
the direction of steepest slope. So basically, a negative gradient shows
the direction where the function decreases. At each step the weights are
updated by this formula

$ w_(upright("new")) = w + eta dot.op Delta w $

where $eta$ is the #strong[learning rate] and $Delta w$ is the negative
gradient.

This algorithm let us move towards the minimum of our #emph[loss]
function by #emph[small] steps, proportional to how far we are from the
minimum and the learning rate.

== Linear Basis Expansion
<linear-basis-expansion>
Of course the model as it is right now is very limited both for
regression and classification. In the first case, the distribution of
data can follow more complex functions; in the second case all we can do
with a line is try to solve #strong[linearly separable] problems.

In order to add some complexity we can use a technique called
#strong[linear basis expansion] (#strong[LBE];), that now let us work
with #emph[non linear] functions. The model is still linear with respect
to the weights, but now we accept that input and output data can have
some non linear relationship.

So what we do is basically is augment the input vector with additional
variables which are transformations of $x$ according to some function

$ phi.alt_k : bb(R)^n arrow.r bb(R) $

So, in general we have that the new hypthesis function becomes

$ h_w (x) = sum_(k = 0)^K w_k phi.alt_k (x) $

Where $K$ can be larger than the number $n$ of dimensions of a single
input vector.

Since the model is still linear in the parameters $w$ (not in the input
$x$), we can use the same algorithm as before.

The main advantage in using this technique is more flexibility of the
model, that of course can become also the disadvantage, because an
overcomplicated model risk overfitting. Other two cons are #emph[curse
of dimensionality] and the fact that $phi.alt$ is fixed, and not
automatically deduce based in data.

=== Tikhonov Regularization
<tikhonov-regularization>
In order to control the complexity of the model, a technique called
#strong[Tikhonov regularization] can be used. The application of this
method in the case of regression lead to the so called #strong[Ridge
regression];, where the model is limited by the values of $w$.

In general high value of $w$ are penalized, in order to make some $w_j$
tend to zero, so that less terms are used.

$ upright("Loss") (w) = sum_(p = 1)^l (y_p - x_p^T w)^2 + lambda parallel w parallel^2 $

#quote(block: true)[
\[!TIP\] Why the square of $parallel w parallel$? Let’s notice that the
$parallel w parallel$ term is already positive, so one can think that
there is no need to square it. In reality this is done because,
otherwise it is #strong[not differentiable] and so it cannot be used in
the gradient descent algorithm.
]

And so the new formula for updating weights now becomes

$ w_(upright("new")) = w + eta dot.op Delta w - 2 lambda w $

As we can see we extended the #emph[loss] function with a new term in
which $lambda$ is a new #emph[small] positive hyperparameter chosen in
model selection phase.

Of course we need to find a trade off between these two terms because

- with a #strong[small] $lambda$ the focus is on obtaining a small
  error, but with a too complex model the risk is overfitting
  ($lambda = 0$) is previous #emph[unregolarized] model).
- with a #strong[high] $lambda$ the second term can become dominant,
  increasing error on data and moving towards simpler models with the of
  risk underfit.

The penalty term penalizes high values of the weights and tends to drive
all the weights to smaller values. Some weight can also become $0$,
reducing the model complexity.

==== Direct Approach
<direct-approach>
As the previous case is possible to solve the problem with a direct
approach given the following closed formula

$ w = (X^T X + lambda I)^(- 1) X^T y $

where the $(X^T X + lambda I)$ matrix #strong[is always invertible];.

== References
<references>
- \[\[supervised\_learning\]\]
- \[\[gradient\_descent\]\]
- \[\[least\_squares\]\]
- \[\[singular\_value\_decomposition\]\]
