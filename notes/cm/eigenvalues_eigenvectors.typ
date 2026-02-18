#import "@local/note_template:0.1.0": *
#show: note_template

#title("Eigenvalues and Eigenvectors") <eigenvalues-and-eigenvectors>

Given a matrix $A in bb(R)^(n times n)$, a scalar $lambda$ and a vector $v$ such
that

$ A v = lambda v $

we call $lambda$ and $v$ respectively an #strong[eigenvalue] and an
#strong[eigenvector] of $A$. To compute eigenvalues and eigenvectors we need to
#strong[diagonalize] the matrix $A$, but it has to be #strong[diagonalizable] in
the first place.

#important(title: "Diagonalizable Matrix")[
  A matrix $A in bb(R)^(n times n)$ is #strong[diagonalizable] if exists a
  matrix $V in bb(R)^(n times n)$ that is invertible and a #strong[diagonal]
  matrix $D$, such that

  $
    A = V D V^(- 1) =
    mat(
      delim: "[",
      #none, , ;
      upright(bold(v))_1, dots.h.c, upright(bold(v))_n;
      #none, ,
    )
    mat(
      delim: "[", lambda_1, , ;
      #none, dots.down, ;
      #none, , lambda_n
    )
    mat(
      delim: "[", #none, upright(bold(w))_1^tack.b, ;
      #none, dots.v, ;
      #none, upright(bold(w))_n^tack.b,
    )
  $

  This is also called #strong[eigendecomposition];.
]

where $(lambda_i , v_i)$ are #strong[eigenpairs] of $A$, formed by the
eigenvalue $lambda_i$ and the eigenvector $v_i$.

The set ${ v_1 , dots.h , v_n }$ is a basis of $bb(R)^n$ made of eigenvectors of
$A$.

Some interesting property of eigenvectors are

- If $v$ is an eigenvector of $A$, then also $alpha v$ is an eigenvector of $A$
  $ A (alpha v) = alpha (A v) = alpha lambda v $
- If $v$ and $w$ are eigenvectors of $A$, then $v + w$ is also an eigenvector of
  $A$
  $ A (v + w) = A v + A w = lambda v + lambda w = lambda (v + w) $


Let’s now consider a matrix $A = V D V^(- 1)$ and its eigenvalues
${ lambda_1 , dots.h , lambda_n }$, the eigenvalues of $A^k$ can be easily
computed by notice that

$ A^k = product_(i = 1)^k A = product_(i = 1)^k V D V^(- 1) $

but if we expand the product like this

$ A^k = V D V^(- 1) V D V^(- 1) dots.h.c V D V^(- 1) V D V^(- 1) $

we can notice that there are a lot of $V^(- 1) V$ products that can simplified,
resulting in

$
  A^k = V D^k V^(- 1) =
  V mat(
    delim: "[", lambda_1^k, , ;
    #none, dots.down, ;
    #none, , lambda_n^k
  ) V^(- 1)
$

from which we can deduce that the eigenvalues of $A$ are ${ lambda_1^k , dots.h
  , lambda_n^k }$ while the eigenvectors are the same, because the matrix $V$ is
still the same, so we can take their columns as eigenvectors.

A direct implication of this is with polynomials. Let’s consider a classic
polynomial of degree $k$

$ p (x) = c_0 + c_1 x + c_2 x^2 + dots.h.c + c_k x^k $

In a similar way is possible to write a matrix polynomial like this

$ p (A) = c_0 I + c_1 A + c_2 A^2 + dots.h.c + c_k A^k $

Like before, we can expand every $A^i$ in $V D^i V^(- 1)$, for all $k$

$
  p (A) = c_0 I + c_1 V D V^(- 1) + c_2 V D^2 V^(- 1) + dots.h.c + c_k V D^k
  V^(- 1)
$

if we now factor out $V$ on the left and $V^(- 1)$ on the right, we get

$ p (A) = V (c_0 I + c_1 D + c_2 D^2 + dots.h.c + c_k D^k) V^(- 1) $

concluding that

$ p (A) = V p (D) V^(- 1) $

and so the eigenvalues of $p (A)$ are

$
  p (D) = mat(
    delim: "[",
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
  and this is called #strong[spectral decomposition] of $A$.
]

This theorem implies a lot of interesting properties like the fact that if a
matrix is symmetric then is #emph[always diagonalizable];.

Another interesting fact is that the matrix $U$ containing the eigenvectors is
orthogonal and so the diagonalization is simplified due to the fact that we
don’t need to compute its inverse but its transpose.

Two interesting properties, derived by the fact that $U$ is orthogonal are that

- All the eigenvalues are real.
- We have $n$ eigenvectors that are an orthonormal basis of $bb(R)^n$.

#important(title: "Theorem")[
  If $A in bb(R)^(n times n)$ is symmetric, then

  $
    lambda_(upright("min")) parallel x parallel^2 lt.eq x^tack.b A x lt.eq
    lambda_(upright("max")) parallel x parallel^2
  $

  for any $x$. Of course the formula can be changed in

  $
    lambda_(upright("min")) lt.eq frac(x^tack.b A x, parallel x parallel^2)
    lt.eq lambda_(upright("max"))
  $
]

Let’s notice that when $parallel x parallel = 1$ the formula is simplified in

$ lambda_(upright("min")) lt.eq x^tack.b A x lt.eq lambda_(upright("max")) $

The result given by this theorem is a consequence of the fact that if $v eq.not
0$ such that $A v = lambda_(upright("max")) v$, then

$
  v^tack.b A v = v^tack.b (lambda_(upright("max")) v) = lambda_(upright("max"))
  v^tack.b v = lambda_(upright("max")) parallel v parallel^2
$

the same holds for $lambda_(upright("min"))$.

= Symmetric Positive (Semi)Definite Matrices <symmetric-positive-semidefinite-matrices>

Some interesting matrices are the #strong[symmetric positive definite] matrices
(#strong[SPD];), that are defined as symmetric matrices whose eigenvalue are all
#emph[strictly] positive and are denoted as

$ A succ 0 $

It’s easy to imagine that #strong[symmetric positive semidefinite] matrices
(#strong[SPSD];) are symmetric matrices with all eigenvalues greater or equal
than $0$ and are denoted as

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
  x^tack.b A^tack.b A x & = (A x)^tack.b (A x) = parallel A x parallel^2 gt.eq 0 \
  x^tack.b A A^tack.b x & = (A^tack.b x)^tack.b (A^tack.b x) = parallel A^tack.b
                          x parallel^2 gt.eq 0 \
$

so they are both SPSD.

= References <references>

- Linear Algebra
