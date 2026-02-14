= Orthogonality
<orthogonality>
The concept of #strong[orthogonality] basically tells us if two vectors
are #strong[orthogonal];, that in a $2$-dimensional space is equivalent
to have two perpendicular lines. Or in terms of linear algebra, it means
that there is a $90$ degree angle between the two vectors. For example

$ mat(delim: "[", 1; 0) quad mat(delim: "[", 0; 1) $

are orthogonal vectors.

!\[\[orthogonal\_vectors.jpg\]\]

#quote(block: true)[
\[!NOTE\] Vectors Orthogonality Two vectors $u , v$ are orthogonal if
$ u^tack.b v = angle.l u , v angle.r = 0 $ their scalar product is zero.
]

If two vectors are orthogonal and have both length $1$ (euclidean norm),
than they are called #strong[orthonormal];.

!\[\[orthogonal\_orthonormal.jpg\]\]

We can extend this to $n$-dimensional vectors, and we can also extend
the concept to matrices, except that for matrices the orthogonality is
defined for only one matrix and not between two (like vectors).

#quote(block: true)[
\[!NOTE\] Matrix Orthogonality A matrix $U in bb(R)^(n times n)$ is
#strong[orthogonal] if $ U U^tack.b = U^tack.b U = I $ A direct
implication is that $U^tack.b = U^(- 1)$.
]

Equivalently we can say that $U$’s columns are an #strong[orthonormal
basis] of $bb(R)^n$. So we can see an orthogonal matrix as a collection
of column vectors that are orthonormal with each other.

If two matrices $U_1$ and $U_2$ of size $n times n$ are orthogonal, then
their product $U_1 U_2$ is also an orthogonal matrix. And this can be
proven by

$ (U_1 U_2)^tack.b (U_1 U_2) = U_2^tack.b U_1^tack.b U_1 U_2 = U_2^tack.b U_2 = I $

#quote(block: true)[
\[!NOTE\] Property An interesting property is that if
$U in bb(R)^(n times n)$ is orthogonal and $x in bb(R)^n$ then it holds

$ parallel U x parallel_2 = parallel x parallel_2 $

And more in general

$ (U x)^tack.b (U y) = x^tack.b y $

The geometric idea is that the transformation associated to $U$ is a
rotation or a mirror symmetry.

#quote(block: true)[
\[!note\] Proof Let’s prove first the first case

$ parallel U x parallel_2 & = sqrt((U x)^tack.b (U x))\
 & = sqrt(x^tack.b U^tack.b U x)\
 & = sqrt(x^tack.b x) = parallel x parallel_2\
 $

For the second case is even simpler
$ (U x)^tack.b (U y) = x^tack.b U^tack.b U y = x^tack.b y $
]
]

Let’s also notice that two non-zero and orthogonal vectors are also
linearly independent and this can be easily by observing that, if $u$
and $v$ are orthogonal, then

$ angle.l u , v angle.r = u^tack.b v = 0 $

and if $u$ and $v$ are linearly independent, it means that they’re not
null and

$ alpha u + beta v = 0 $

with $alpha = beta = 0$. So we can set

$ u^tack.b (alpha u) + u^tack.b (beta v) = alpha u^tack.b u + beta u^tack.b v = alpha u^tack.b u = 0 $

But we know that $u eq.not 0$ so $u^tack.b u eq.not 0$, and so $alpha$
must be $0$. Same reasoning for $beta$ but this time let’s multiply for
$v^tack.b$

$ v^tack.b (alpha u) + v^tack.b (beta v) = alpha v^tack.b u + beta v^tack.b v = beta v^tack.b v = 0 $

Again we know that $v eq.not 0$, so $beta$ must be $0$.

#horizontalrule

Let’s analyze a special case where we consider an orthogonal matrix
$U in bb(R)^(n times k)$ with $n > k$. This matrix, by definition has
orthonormal columns $u_1 , dots.h , u_k$ and so the product

$ U^tack.b U = V in bb(R)^(k times k) $

is the identity matrix of size $k times k$ ($V = I$) because, if we
compute the product we will assign to the element in position $(i , j)$
the value

$ angle.l u_i , u_j angle.r = cases(delim: "{", 0 & upright("if ") i eq.not j, 1 & upright("if ") i = j) $

because in case $u_i eq.not u_j$ it means that they are orthonormal
vector, and so their scalar product is $0$; on the other hand if
$u_i = u_j$ it means that their scalar product is

$ angle.l u_i , u_j angle.r = u_i^tack.b u_j = u^tack.b u = parallel u parallel = 1 $

because $u_i = u_j = u$ that is orthonormal.

We cannot say the same for $U U^tack.b$ because in this case we have

$ U U^tack.b = sum_(i = 1)^k u_i u_i^tack.b $

that must be computed and could be any matrix.

== References
<references>
- \[\[linear\_algebra\]\]
- \[\[matrices\]\]
- \[\[vector\_norms\]\]
