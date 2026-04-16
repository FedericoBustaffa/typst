#import "@local/note_template:0.1.0": *
#show: doc => note_template([Eigen Decomposition], doc)

#title()

One of the most important matrix decomposition in linear algebra that has many
useful applications and implications is the *eigen decomposition*, that let us
decompose a matrix in three different matrices, containing the so called
*eigenvalues* and *eigenvectors*.

#important(title: [ Eigenvalues and Eigenvectors ])[
  Given a matrix $A in RR^(n times n)$, a scalar $lambda$ and a vector $v$ such
  that

  $ A v = lambda v $

  $lambda$ is an *eigenvalue* and $v$ the corresponding *eigenvector* of $A$.
]

From this we can immediately notice that we are looking for directions in which
the transformation $A$ has the only effect of scaling a vector from a factor
equal to the corresponding eigenvalue.

The way to obtain eigenvalues and eigenvectors is called *diagonalization*, that
is exactly the process that let us obtain the eigen decomposition.

Since we want to find $lambda$ values and $v$ vectors that satisfy the equation
above

$ A v = lambda v quad <==> quad A v - lambda v = 0 $

and since $A$ is a matrix and $lambda$ is a scalar we actually use this form

$ A v - (lambda I) v = 0 quad <==> quad (A - lambda I) v = 0 $

since the matrix $A$ represents an $n$-dimensional transformation, there are $n$
possible directions in which the condition holds (hence $n$ possible eigenvalues
and eigenvectors). So now $lambda$ becomes a vector

$ vb(lambda) = vec(lambda_1, dots.v, lambda_n) $

To be diagonalized the matrix has to be *diagonalizable* in the first place and
as we can see later this is something we actually discover trying to diagonalize
the matrix.

#important(title: "Diagonalizable Matrix")[
  A matrix $A in bb(R)^(n times n)$ is *diagonalizable* if exists a matrix $V in
  bb(R)^(n times n)$ that is invertible and a *diagonal* matrix $D$, such that

  $
    A = V D V^(- 1) =
    mat(
      |, , |;
      vb(v)_1, dots.h.c, vb(v)_n;
      |, , |
    )
    mat(
      lambda_1, , ;
      , dots.down, ;
      , , lambda_n
    )
    mat(
      -, vb(w)_1^T, -;
      , dots.v, ;
      -, vb(w)_n^T, -
    )
  $
]

This is in fact called *eigen decomposition* and if it exists then the matrix is
diagonalizable. In order to obtain it we have to set

$ det(A - lambda I) = 0 $

obtaining the *characteristic polynomial*, whose roots are the eigenvalues of
$A$. If we think about it we are looking for directions (eigenvectors) in which
the condition

$ (A - lambda I) v = 0 $

is true. So we want a transformation $(A - lambda I)$ that only scales vectors
of some factor on the same direction they're already pointing. This
transformation matrix has of course determinant equal to zero because it
collapses vectors on a lower dimensional space.

Once solved the characteristic polynomial, we have eigenvalues that we can plug
into the diagonal matrix $D$ (in fact it only scales vectors) and by solving the
linear system we obtain the corresponding eigenvectors.

#note[
  Let's notice that $V$ is a basis of eigenvectors, that in fact spans the so
  called *eigenspace*.
]

If the diagonalization process does not return a basis of eigenvectors then the
matrix is not diagonalizable. The idea behind this decomposition is that we want
to

+ Find a basis of eigenvectors such that we can map every vector in a
  coordinates system with nice properties.
+ Apply a transformation $D$ that is equivalent to $A$ but in the new reference
  system that now only scales vectors of some factor.
+ Bring the resulting vector back to the original reference system.

Some interesting property of eigenvectors are

- If $v$ is an eigenvector of $A$, then also $alpha v$ is an eigenvector of $A$
  $ A (alpha v) = alpha (A v) = alpha lambda v $
- If $v$ and $w$ are eigenvectors of $A$ with the same corresponding eigenvalue
  $lambda$, then $v + w$ is also an eigenvector of $A$
  $ A (v + w) = A v + A w = lambda v + lambda w = lambda (v + w) $

Also, the number of times an eigenvalue is root of the characteristic polynomial
is called *algebraic multiplicity*, while the number of linearly independent
vectors associated with a specific eigenvalue is called *geometric
multiplicity*.

To obtain a basis of the vector space we are working in we need a maximal
geometric multiplicity.

= Spectral Theorem <spectral-theorem>

One of the most important theorems for diagonalization is the *spectral
theorem*.

#important(title: "Spectral Theorem")[
  If $A in bb(R)^(n times n)$ and is symmetric, then exists a matrix $U in
  bb(R)^(n times n)$ that is orthogonal and there exists a diagonal matrix $D in
  bb(R)^(n times n)$ with the eigenvalues of $A$ on its diagonal such that
  $ A = U D U^T $
  and this is called *spectral decomposition* of $A$.
]

This theorem implies a lot of interesting properties like the fact that if a
matrix is symmetric then is *always diagonalizable*.

Another interesting fact is that the matrix $U$, containing the eigenvectors, is
orthogonal and so the diagonalization is simplified due to the fact that we
don't need to compute its inverse but its transpose.

Two interesting properties, derived by the fact that $U$ is orthogonal are that

- All the eigenvalues are real.
- We have $n$ eigenvectors that are an orthonormal basis of $bb(R)^n$.

which can result useful in many cases.

#important(title: "Theorem")[
  If $A in bb(R)^(n times n)$ is symmetric, then

  $
    lambda_"min" norm(x)^2 <= x^T A x <=
    lambda_"max" norm(x)^2
  $

  for any $x$. Of course the formula can be changed in

  $
    lambda_"min" <= frac(x^T A x, norm(x)^2)
    <= lambda_"max"
  $

  *Proof*

  First let's consider a *simple case* where $A$ is a diagonal matrix with its
  eigenvalues on the diagonal

  $
    A = mat(
      lambda_1, #none, #none ;
      #none, dots.down, #none ;
      #none, #none, lambda_n;
    )
  $

  and let's also assume that

  $ lambda_1 = lambda_"max" >= dots.c >= lambda_n = lambda_"min" $

  In this case we have that

  $ x^T A x = lambda_1 x_1^2 + dots.c + lambda_n x_n^2 $

  that of course satisfies the inequality because $lambda_"max" norm(x)^2$ is
  essentially the same thing but with the maximum eigenvalue (same reasoning for
  $lambda_"min"$).

  For the *general case*, things do not change that much we just have to use the
  _spectral theorem_, since $A$ is symmetric

  $ x^T A x = x^T U D U^T x $

  so if we know consider that $x^T U$ and $U^T x$ are still vector of
  the same shape as before and $D$ is exactly the $A$ matrix of the simple case
  we're done

  $
    lambda_"min" norm(U^T x)^2 <=
    x^T U D U^T x <=
    lambda_"max" norm(U^T x)^2
  $
]

If we choose $x$ as an eigenvector of $A$, in particular the the associated with
$lambda_"max"$, we have

$
  v^T A v = v^T (lambda_"max" v) = lambda_"max"
  v^T v = lambda_"max" norm(v)^2
$

the same holds for $lambda_"min"$.

= Power of a Matrix

Let’s now consider a matrix $A = V D V^(- 1)$ and its eigenvalues $lambda_1,
dots, lambda_n$, the eigenvalues of $A^k$ can be easily computed by notice that

$ A^k = product_(i = 1)^k A = product_(i = 1)^k V D V^(- 1) $

but if we expand the product like this

$ A^k = V D V^(- 1) V D V^(- 1) dots.h.c V D V^(- 1) V D V^(- 1) $

we can notice that there are a lot of $V^(- 1) V$ products that can simplified,
resulting in

$
  A^k = V D^k V^(- 1) =
  V mat(
    lambda_1^k, , ;
    #none, dots.down, ;
    #none, , lambda_n^k
  ) V^(- 1)
$

from which we can deduce that the eigenvalues of $A$ are $lambda_1^k, dots,
lambda_n^k$ while the eigenvectors are the same, because the matrix $V$ is still
the same, so we can take their columns as eigenvectors.

A direct implication of this is with polynomials. Let’s consider a classic
polynomial of degree $k$

$ p (x) = c_0 + c_1 x + c_2 x^2 + dots.h.c + c_k x^k $

In a similar way is possible to write a matrix polynomial like this

$ p (A) = c_0 I + c_1 A + c_2 A^2 + dots.h.c + c_k A^k $

Like before, we can expand every $A^i$ in $V D^i V^(- 1)$, for all $k$

$
  p (A) = c_0 I + c_1 V D V^(- 1) + c_2 V D^2 V^(- 1) + dots.c + c_k V D^k
  V^(- 1)
$

if we now factor out $V$ on the left and $V^(- 1)$ on the right, we get

$ p (A) = V (c_0 I + c_1 D + c_2 D^2 + dots.h.c + c_k D^k) V^(- 1) $

concluding that

$ p (A) = V p (D) V^(- 1) $

and so the eigenvalues of $p (A)$ are

$
  p (D) = mat(
    p (lambda_1), , ;
    #none, dots.down, ;
    #none, , p (lambda_n)
  )
$

= Symmetric Positive (Semi)Definite Matrices <spsd>

Some interesting matrices are the *symmetric positive definite (SPD)*, that are
defined as symmetric matrices whose eigenvalue are all *strictly* positive

$ A succ 0 $

It's easy to imagine that *symmetric positive semidefinite (SPSD)*
are symmetric matrices with all eigenvalues greater or equal than $0$

$ A succ.eq 0 $

Let’s also notice that

- $A$ is SPD if and only if $x^T A x > 0$ for all $x eq.not 0$.
- $A$ is SPSD if and only if $x^T A x gt.eq 0$ for all $x$.

For rectangular matrices we have that, given $A in bb(R)^(m times n)$ the
matrices $A^T A$ and $A A^T$ are SPSD. They’re both symmetric:

$
  A^T A & = (A^T A)^T = A^T A \
  A A^T & = (A A^T)^T = A A^T
$

and their eigenvalues are greater or equal than $0$

$
  x^T A^T A x & = (A x)^T (A x) = norm(A x)^2 >= 0 \
  x^T A A^T x & = (A^T x)^T (A^T x)
                = norm(A^T x)^2 >= 0
$

so they are both SPSD.

