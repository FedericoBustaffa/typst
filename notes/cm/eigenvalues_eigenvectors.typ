#import "@local/note_template:0.1.0": *
#show: doc => note_template([Eigenvalues and Eigenvectors], doc)

#title()

Given a matrix $A in bb(R)^(n times n)$, a scalar $lambda$ and a vector $v$ such
that

$ A v = lambda v $

$lambda$ and $v$ are respectively an *eigenvalue* and an *eigenvector* of $A$.
To compute eigenvalues and eigenvectors we need to *diagonalize* the matrix $A$,
that of course has to be *diagonalizable* in the first place.

#important(title: "Diagonalizable Matrix")[
  A matrix $A in bb(R)^(n times n)$ is *diagonalizable* if exists a matrix $V in
  bb(R)^(n times n)$ that is invertible and a *diagonal* matrix $D$, such that

  $
    A = V D V^(- 1) =
    mat(
      #none, , ;
      bold(v)_1, dots.h.c, bold(v)_n;
      #none, ,
    )
    mat(
      lambda_1, , ;
      #none, dots.down, ;
      #none, , lambda_n
    )
    mat(
      #none, bold(w)_1^tack.b, ;
      #none, dots.v, ;
      #none, bold(w)_n^tack.b,
    )
  $

  This is also called *eigen-decomposition*.
]

where $(lambda_i , v_i)$ are *eigenpairs* of $A$, formed by the eigenvalue
$lambda_i$ and the eigenvector $v_i$.

The set ${ v_1 , dots , v_n }$ is a basis of $bb(R)^n$ made of eigenvectors of
$A$.

Some interesting property of eigenvectors are

- If $v$ is an eigenvector of $A$, then also $alpha v$ is an eigenvector of $A$
  $ A (alpha v) = alpha (A v) = alpha lambda v $
- If $v$ and $w$ are eigenvectors of $A$, then $v + w$ is also an eigenvector of
  $A$
  $ A (v + w) = A v + A w = lambda v + lambda w = lambda (v + w) $

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

#important(title: "Theorem")[
  If $A in bb(R)^(n times n)$ is symmetric, then

  $
    lambda_"min" || x ||^2 <= x^tack.b A x <=
    lambda_"max" || x ||^2
  $

  for any $x$. Of course the formula can be changed in

  $
    lambda_"min" <= frac(x^tack.b A x, || x ||^2)
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

  $ x^tack.b A x = lambda_1 x_1^2 + dots.c + lambda_n x_n^2 $

  that of course satisfies the inequality because $lambda_"max" ||x||^2$ is
  essentially the same thing but with the maximum eigenvalue (same reasoning for
  $lambda_"min"$).

  For the *general case*, things do not change that much we just have to use the
  _spectral theorem_, since $A$ is symmetric

  $ x^tack.b A x = x^tack.b U D U^tack.b x $

  so if we know consider that $x^tack.b U$ and $U^tack.b x$ are still vector of
  the same shape as before and $D$ is exactly the $A$ matrix of the simple case
  we're done

  $
    lambda_"min" || U^tack.b x ||^2 <=
    x^tack.b U D U^tack.b x <=
    lambda_"max" || U^tack.b x ||^2
  $
]

If of course we choose $x$ as an eigenvector of $A$, in particular the the
associated with $lambda_"max"$, we have

$
  v^tack.b A v = v^tack.b (lambda_"max" v) = lambda_"max"
  v^tack.b v = lambda_"max" || v ||^2
$

the same holds for $lambda_"min"$.

= Symmetric Positive (Semi)Definite Matrices <spsd>

Some interesting matrices are the *symmetric positive definite (SPD)*, that are
defined as symmetric matrices whose eigenvalue are all *strictly* positive

$ A succ 0 $

It's easy to imagine that *symmetric positive semidefinite (SPSD)*
are symmetric matrices with all eigenvalues greater or equal than $0$

$ A succ.eq 0 $

Let’s also notice that

- $A$ is SPD if and only if $x^tack.b A x > 0$ for all $x eq.not 0$.
- $A$ is SPSD if and only if $x^tack.b A x gt.eq 0$ for all $x$.

For rectangular matrices we have that, given $A in bb(R)^(m times n)$ the
matrices $A^tack.b A$ and $A A^tack.b$ are SPSD. They’re both symmetric:

$
  A^tack.b A & = (A^tack.b A)^tack.b = A^tack.b A \
  A A^tack.b & = (A A^tack.b)^tack.b = A A^tack.b
$

and their eigenvalues are greater or equal than $0$

$
  x^tack.b A^tack.b A x & = (A x)^tack.b (A x) = || A x ||^2 gt.eq 0 \
  x^tack.b A A^tack.b x & = (A^tack.b x)^tack.b (A^tack.b x)
                          = || A^tack.b x ||^2 gt.eq 0
$

so they are both SPSD.

