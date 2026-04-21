#import "@local/note_template:0.1.0": *
#show: doc => note_template([Orthogonality], doc)

#title()

Conceptually, two vectors are orthogonal if they are perpendicular or, in terms
of linear algebra, it means that there is a $90$ degree angle between them. For
example

$ vec(1, 0) quad vec(0, 1) $

are orthogonal vectors.

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Assi (grigio chiaro per non appesantire)
    line((-0.5, 0), (3, 0), stroke: gray + 0.5pt, name: "asse-x")
    line((0, -0.5), (0, 3), stroke: gray + 0.5pt, name: "asse-y")

    // Vettore v1 (orizzontale)
    // In CeTZ moderno si usa 'mark' dentro 'line' per fare le frecce
    line((0, 0), (2.5, 0), stroke: blue + 1.5pt, mark: (end: ">", fill: blue))
    content((2.5, 0.6), [ $hat(v)_1$ ], anchor: "north")

    // Vettore v2 (verticale)
    line((0, 0), (0, 2.5), stroke: red + 1.5pt, mark: (end: ">", fill: red))
    content((0.5, 2.2), [ $hat(v)_2$ ], anchor: "south")

    // Quadratino per indicare angolo retto
    // Usiamo rect ma con coordinate specifiche per il vertice opposto
    rect((0, 0), (0.3, 0.3), stroke: 0.5pt)

    // Opzionale: un puntino nell'origine
    circle((0, 0), radius: 0.05, fill: black)
  }),
  caption: [ Orthogonal Vectors ],
)

#important(title: "Orthogonality")[
  Two vectors $u , v$ are orthogonal if
  $ u^T v = iprod(u, v) = 0 $ their scalar product is zero.
]

If two vectors are orthogonal and have both length $1$ (euclidean norm),
than they are called *orthonormal*.

#figure(
  cetz.canvas({
    import cetz.draw: *

    // axes
    line((-1.5, 0), (1.5, 0), stroke: gray + 0.5pt, name: "asse-x")
    line((0, -1.5), (0, 1.5), stroke: gray + 0.5pt, name: "asse-y")

    // unitary circle
    circle((0, 0), radius: 1, stroke: gray + 0.5pt)

    // orthonormal vectors
    line((0, 0), (1, 0), stroke: blue + 1.5pt, mark: (end: ">", fill: blue))
    content((1.25, 0.25), [ $hat(v)_1$ ])

    line((0, 0), (0, 1), stroke: blue + 1.5pt, mark: (end: ">", fill: blue))
    content((0.25, 1.2), [ $hat(v)_2$ ])

    // orthogonal vectors
    line((0, 0), (0, -1.5), stroke: red + 1.5pt, mark: (end: ">", fill: red))
    content((0.4, -1.25), [ $hat(u)_1$ ])

    line((0, 0), (-0.75, 0), stroke: red + 1.5pt, mark: (end: ">", fill: red))
    content((-0.4, 0.35), [ $hat(u)_2$ ])

    rect((0, 0), (0.3, 0.3), stroke: 0.5pt)
    rect((0, 0), (-0.3, -0.3), stroke: 0.5pt)

    circle((0, 0), radius: 0.05, fill: black)

    line((2, 1), (2.5, 1), stroke: red + 1.5pt, mark: (
      end: ">",
      fill: red,
    ))
    content((3.8, 1), [ Orthogonal ])

    line((2, 0.5), (2.5, 0.5), stroke: blue + 1.5pt, mark: (
      end: ">",
      fill: blue,
    ))
    content((4, 0.5), [ Orthonormal ])
  }),
  caption: [ Orthogonal and Orthonormal ],
)

We can extend this to $n$-dimensional vectors, and we can also extend the
concept to matrices, except that for matrices the orthogonality is defined for
only one matrix and not between two (like vectors).

#important(title: "Matrix Orthogonality")[
  A matrix $U in bb(R)^(n times n)$ is *orthogonal* if
  $ U U^TT = U^TT U = I $
  A direct implication is that $U^TT = U^(- 1)$.
]

Equivalently we can say that $U$’s columns are an *orthonormal basis* of
$bb(R)^n$. So we can see an orthogonal matrix as a collection of column vectors
that are orthonormal with each other.

If two matrices $U_1$ and $U_2$ of size $n times n$ are orthogonal, then their
product $U_1 U_2$ is also an orthogonal matrix. And this can be proven by

$
  (U_1 U_2)^TT (U_1 U_2) = U_2^TT U_1^TT U_1 U_2 =
  U_2^TT U_2 = I
$

#important(title: "Property")[
  An interesting property is that if $U in bb(R)^(n times n)$ is orthogonal and
  $x in bb(R)^n$ then it holds

  $ norm(U x)_2 = norm(x)_2 $

  And more in general

  $ (U x)^TT (U y) = x^TT y $

  The geometric idea is that the transformation associated to $U$ is a rotation
  or a mirror symmetry.

  *Proof*

  Let’s prove first the first case

  $
    norm(U x)_2 & = sqrt((U x)^TT (U x)) \
                & = sqrt(x^TT U^TT U x) \
                & = sqrt(x^TT x) = norm(x)_2 \
  $

  For the second case is even simpler
  $ (U x)^TT (U y) = x^TT U^TT U y = x^TT y $
]

Let’s also notice that two non-zero and orthogonal vectors are also linearly
independent; if $u$ and $v$ are orthogonal, then

$ iprod(u, v) = u^TT v = 0 $

and if $u$ and $v$ are linearly independent, it means that they're not null and

$ alpha u + beta v = 0 $

only if $alpha = beta = 0$. So we can set

$
  u^TT (alpha u) + u^TT (beta v) = alpha u^TT u + beta u^TT v =
  alpha u^TT u = 0
$

But we know that $u eq.not 0$ so $u^TT u eq.not 0$, and so $alpha$ must be
$0$. Same reasoning for $beta$ but this time let’s multiply for $v^TT$

$
  v^TT (alpha u) + v^TT (beta v) = alpha v^TT u + beta v^TT v =
  beta v^TT v = 0
$

Again we know that $v eq.not 0$, so $beta$ must be $0$.

Let’s analyze a special case where we consider an orthogonal matrix
$U in bb(R)^(n times k)$ with $n > k$. This matrix, by definition has
orthonormal columns $u_1 , dots.h , u_k$ and so the product

$ U^TT U = V in bb(R)^(k times k) $

is the identity matrix of size $k times k$ ($V = I$) because, if we compute the
product we will assign to the element in position $(i , j)$ the value

$
  iprod(u_i, u_j) = cases(
    delim: "{", 0 & upright("if ") i eq.not
    j, 1 & upright("if ") i = j
  )
$

because in case $u_i eq.not u_j$ it means that they are orthonormal vector, and
so their scalar product is $0$; on the other hand if $u_i = u_j$ it means that
their scalar product is

$
  iprod(u_i, u_j) = u_i^TT u_j = u^TT u =
  norm(u) = 1
$

because $u_i = u_j = u$ that is orthonormal.

We cannot say the same for $U U^TT$ because in this case we have

$ U U^TT = sum_(i = 1)^k u_i u_i^TT $

that must be computed and could be any matrix.

