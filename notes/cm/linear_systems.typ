#import "@local/note_template:0.1.0": *
#show: note_template

#title("Linear Systems") <linear-systems>

One of the main goal in linear algebra is to solve #strong[linear systems]
(systems of linear equations), because many problems can be formulated in this
way.

A linear system can have zero, one (unique) or infinite solutions, but this
depends on many factors that can be brought to light before trying to calculate
a solution.

From a #strong[geometric point of view];, if we think the linear equations of
the system as vectors, the system solution is the intersection point between
them, if there is only one solution. If the system has infinite solutions the
intersection will be an hyper-plane and if there is no solution it means that
there is no intersection.

A linear system is usually represented in a compact form as matrix-vector
product

$ A x = y $

where $A$ is a matrix and $x$ and $y$ are vectors. We can also say that $A$ is
#strong[invertible] if the system has a unique solution (for example when its
columns are basis) and if $A$ is #strong[square];. In that case the solution is
given by

$ x = A^(- 1) y $

= References <references>

- Linear Algebra
- Matrices
