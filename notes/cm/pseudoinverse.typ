#import "@local/note_template:0.1.0": *
#show: doc => note_template([Pseudoinverse Matrix], doc)

#title()

The concept of #strong[pseudoinverse] of a matri is a generalization of the
inverse for square matrices. The pseudoinverse is used for example to solve
overdetermined systems like a regression problem.

= Least Squares <least-squares>

One definition for the pseudoinverse of a matrix is given by the *least squares*
problem, where we want to solve

$ min_x parallel A x - y parallel^2 $

Expand the formula gives us a quadratic form for the problem, of which we can
calculate the *gradient*, that is

$ (A^T A) x - A^T y $

and by setting it to $0$, in order to minimize the previous quantity, we obtain

$
  (A^T A) x - A^T y & = 0 \
          (A^T A) x & = A^T y \
                  x & = (A^T A)^(- 1) A^T y \
$

If we notice, this form is very similar to the canonical form used to solve
square systems:

$ A x = y arrow.l.r.double x = A^(- 1) y $

For rectangular matrices we can instead define the concept of _pseudoinverse_,
denoted as $A^(+)$

$ A^(+) = (A^T A)^(- 1) A^T $

that let us solve the rectangular system by computing

$ x = A^(+) y $

In fact if we have a matrix $A in bb(R)^(n times n)$ that is invertible, its
pseudoinverse is equal to its inverse:

$
  A^(+) = (A^T A)^(- 1) A^T = A^(- 1) A^(- T) A^T = A^(- 1)
$

It’s important to notice that the multiplication for the pseudoinverse it’s, in
general, not commutative, for the least squares problem, we usually have a
matrix $A in bb(R)^(m times n)$ with $m gt.eq n$:

- Case $A^(+) A$ with $A^T A$ invertible:
  $ A^(+) A = (A^T A)^(- 1) A^T A = I_n $
  but if $A^T A$ is not invertible, it means that $A$ has not full column
  rank, and most important is not possible to solve the system.
- Case $A A^(+)$:
  $
    A A^(+) = A (A^T A)^(- 1) A^T = A A^(- 1) A^(- T) A^T =
    (A A^(- 1))^T = I_m
  $
  but this works only if $A$ is square and invertible or if $A$ is
  underdetermined with full row rank, so in general $A A^(+) eq.not I_m$.

To check when $A^T A$ is invertible we need to know if $A$ has full column
rank.

= Singular Value Decomposition <singular-value-decomposition>

Given a matrix $A = U Sigma V^T$ with rank $r$ and that is _thin_, then its
pseudoinverse is defined as

$ A^(+) = V Sigma^(+) U^T $

where

$
  Sigma^(+) = mat(
    delim: "[", 1 \/ sigma_1, , , ;
    #none, dots.down, , ;
    #none, , 1 \/ sigma_r, ;
    #none, , , 0
  )
$

A special case, is when $A$ has full column rank, then, like we saw
before, it holds

$ A^(+) = (A^T A)^(- 1) A^T $

so in this case is also possible to write

$ A^(+) = V Sigma^(+) U^T = V Sigma^(- 1) U^T $

because $Sigma$ is invertible if and only if $A$ has full column rank,
in fact we can obtain the formula by noticing that

$
  (A^T A)^(- 1) A^T & = (V Sigma U^T U Sigma V^T)^(- 1) V Sigma U^T \
                    & = (V Sigma^2 V^T)^(- 1) V Sigma U^T \
                    & = V Sigma^(- 2) V^T V Sigma U^T = V Sigma^(- 1) U^T
$

that is the same thing we get with the previous definition.

