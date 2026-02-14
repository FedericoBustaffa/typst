= Pseudoinverse Matrix
<pseudoinverse-matrix>
The concept of #strong[pseudoinverse] of a matrix is a generalization of
the inverse for square matrices. The pseudoinverse is used for example
to solve overdetermined systems like a regression problem.

== Least Squares
<least-squares>
One definition for the pseudoinverse of a matrix is given by the
#strong[least squares] problem, where we want to solve

$ min_x parallel A x - y parallel^2 $

Expand the formula gives us a quadratic form for the problem, of which
we can calculate the #strong[gradient];, that is

$ (A^tack.b A) x - A^tack.b y $

and by setting it to $0$, in order to minimize the previous quantity, we
obtain

$ (A^tack.b A) x - A^tack.b y & = 0\
(A^tack.b A) x & = A^tack.b y\
x & = (A^tack.b A)^(- 1) A^tack.b y\
 $

If we notice, this form is very similar to the canonical form used to
solve square systems:

$ A x = y arrow.l.r.double x = A^(- 1) y $

For rectangular matrices we can instead define the concept of
#emph[pseudoinverse];, denoted as $A^(+)$

$ A^(+) = (A^tack.b A)^(- 1) A^tack.b $

that let us solve the rectangular system by computing

$ x = A^(+) y $

In fact if we have a matrix $A in bb(R)^(n times n)$ that is invertible,
its pseudoinverse is equal to its inverse:

$ A^(+) = (A^tack.b A)^(- 1) A^tack.b = A^(- 1) A^(- tack.b) A^tack.b = A^(- 1) $

It’s important to notice that the multiplication for the pseudoinverse
it’s, in general, not commutative, for the least squares problem, we
usually have a matrix $A in bb(R)^(m times n)$ with $m gt.eq n$:

- Case $A^(+) A$ with $A^tack.b A$ invertible:
  $ A^(+) A = (A^tack.b A)^(- 1) A^tack.b A = I_n $ but if $A^tack.b A$
  is not invertible, it means that $A$ has not full column rank, and
  most important is not possible to solve the system.
- Case $A A^(+)$:
  $ A A^(+) = A (A^tack.b A)^(- 1) A^tack.b = A A^(- 1) A^(- tack.b) A^tack.b = (A A^(- 1))^tack.b = I_m $
  but this works only if $A$ is square and invertible or if $A$ is
  underdetermined with full row rank, so in general
  $A A^(+) eq.not I_m$.

To check when $A^tack.b A$ is invertible we need to know if $A$ has full
column rank.

== Singular Value Decomposition
<singular-value-decomposition>
Given a matrix $A = U Sigma V^tack.b$ with rank $r$ and that is
#emph[thin];, then its pseudoinverse is defined as

$ A^(+) = V Sigma^(+) U^tack.b $

where

$ Sigma^(+) = mat(delim: "[", 1 \/ sigma_1, , , ; #none, dots.down, , ; #none, , 1 \/ sigma_r, ; #none, , , 0) $

A special case, is when $A$ has full column rank, then, like we saw
before, it holds

$ A^(+) = (A^tack.b A)^(- 1) A^tack.b $

so in this case is also possible to write

$ A^(+) = V Sigma^(+) U^tack.b = V Sigma^(- 1) U^tack.b $

because $Sigma$ is invertible if and only if $A$ has full column rank,
in fact we can obtain the formula by noticing that

$ (A^tack.b A)^(- 1) A^tack.b & = (V Sigma U^tack.b U Sigma V^tack.b)^(- 1) V Sigma U^tack.b \)\
 & = (V Sigma^2 V^tack.b)^(- 1) V Sigma U^tack.b\
 & = V Sigma^(- 2) V^tack.b V Sigma U^tack.b = V Sigma^(- 1) U^tack.b $

that is the same thing we get with the previous definition.

== References
<references>
- \[\[linear\_algebra\]\]
- \[\[matrices\]\]
- \[\[singular\_value\_decomposition\]\]
- \[\[least\_squares\]\]
