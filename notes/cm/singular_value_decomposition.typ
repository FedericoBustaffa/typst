#import "@local/note_template:0.1.0": *
#show: doc => note_template([Singular Value Decomposition], doc)

#title()

The *singular value decomposition (SVD)* is a way to the decompose every matrix
$A in bb(R)^(m times n)$ in a product of three matrices

$ A = U Sigma V^T $

where $U in bb(R)^(m times m)$ and $V in bb(R)^(n times n)$ orthogonal and
$Sigma in bb(R)^(m times n)$ is diagonal, where, on the diagonal we have the so
called *singular values* $sigma_1 , dots.h , sigma_min(m, n)$, such that

$ sigma_1 >= sigma_2 >= dots.h >= sigma_(min (m , n)) >= 0 $

Singular values are unique, while in general $U$ and $V$ are not; in other
words, the singular values depend only on the matrix $A$, while there are
multiple choices of $U$ and $V$ that keep the decomposition valid.

As said, $sigma_1 , dots.h , sigma_(min (m , n))$ are the singular values of
$A$, while the columns of $U$ are called the *left singular vectors* of $A$ and
in a similar way, the rows of $V^T$ (or the columns of $V$) are called the
*right singular vectors* of $A$.

The intuition behind the SVD is again the change of basis pattern and it is
quite similar to the one for eigen decomposition. In fact we will see later that
SVD and eigen decomposition are closely related.

One of the most important things about SVD is that $U$ and $V^T$ are orthogonal
and so they perform a change of basis without scaling the space. They just
rotate the point of view in a way that every direction is independent one
another and so the singular values are an effective measure of how much the
transformation modifies such directions.

#note[
  This is basically the same as a spectral decomposition but generalized to
  rectangular matrices that can augment or reduce the space dimensionality.
]

Similary to the eigen decomposition we have a patter in which

+ $V^T$ performs a basis change to an orthonormal basis of $RR^n$ since $V^T$ is
  orthogonal.
+ $Sigma$ performs a dimensionality augmentation or reduction and scales
  components.
+ $U$ performs another basis change to come map the result vector in a
  coordinate system consistent with the one of the initial vector space.

The main difference between SVD and eigen decomposition is that SVD performs a
basis change in both the domain and codomain, while the eigen decomposition
operates in the same vector space, by performing a basis change and then undone
it.

= SVD and Eigen Decomposition

Let's now try to better visualize and formalize the connection between SVD and
eigen decomposition. Let's consider a generic matrix $A in RR^(m times n)$ and
its SVD $U Sigma V^T$, then it's reasonable to write

$
  A^T A & = (U Sigma V^T)^T (U Sigma V^T) \
        & = V Sigma^T U^T U Sigma V^T \
        & = V Sigma^T Sigma V^T = V Sigma^2 V^T
$

That is the *spectral decomposition* of $A^T A$ from which we can deduce
that $sigma_1 , dots.h , sigma_n$ are the singular values of $A$ if and only if
$sigma_1^2 , dots.h , sigma_n^2$ are the eigenvalues values of $A^T A$.

Now we can exploit this fact to prove that, for every matrix $A$ there is a
valid SVD $A = U Sigma V^T$. We can see that $V^T$ is the same for
both decomposition, for the spectral decomposition we can say that $D =
Sigma^2$, so $Sigma = D^(1/2)$. Now is possible to write

$
             A & = U D^(1/2) V^T \
           A V & = U D^(1/2) \
  A V D^(-1/2) & = U
$

and so we can substitute $U$ in the first equation

$ A & = A V D^(-1/2) D^(1/2) V^T & = A V V^T = A $

so indeed this is a decomposition of $A$; to be sure that is a SVD we have to
check that $U$ and $V^T$ are orthogonal and $Sigma$ is diagonal with all
the properties described before for the singular values.

Let's just see if $U$ is orthogonal just by checking if $U^T U = I$:

$
  U^T U & = (A V D^(-1/2))^T A V D^(-1/2) \
        & = D^(-1/2) V^T A^T A V D^(-1/2) \
        & = D^(-1/2) V^T (U Sigma V^T)^T U Sigma V^T V D^(-1/2) \
        & = D^(-1/2) V^T V Sigma^T U^T U Sigma V^T V D^(-1/2) \
        & = D^(-1/2) D^(1/2) D^(1/2) D^(-1/2) = I
$

that proves $U$ being an orthogonal matrix.

