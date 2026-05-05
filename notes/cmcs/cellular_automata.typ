#import "@local/note_template:0.1.0": *
#show: doc => note_template([Cellular Automata], doc)

#title()

*Cellular automata* are a way to model the environment, that can be *discrete*
(1D, 2D or 3D grids) or *continuous*.

Every cell has a *state* and at each iteration a *transition rule* is applied in
order to evolve the system. The transition rule is applied cell-wise, taking in
input the state of the cell and the state of its neighbors.

Different definitions of the neighborhood will lead to different behaviors of
the environment during the simulation.

#figure(
  image("images/ca_neighborhoods.png", width: 60%),
  caption: [ Cellular Automata Neighborhoods ],
)

The neighborhood for a cellular automata can be defined without any particular
constraint or limitation; of course we must take into account that a large
neighborhood means more computation to evaluation the transition rule for every
cell and typically it adds not needed complexity to the model.

Typically CAs models a _finite space_ and so it's necessary to handle the case
in which we have to evaluate the transition rule for cells that are on the
boundary and so they lack some neighbor.

#figure(
  image("images/ca_boundary_conds.png", width: 40%),
  caption: [ Boundary Conditions ],
)

Common choices are

- *Padding/Halo cells*: some cells are added outside the boundary with a fixed
  value but can lack flexibility.
- *Torus*: make the environment circular.
- *Copy*: copy the value of the central cell into the missing neighbor or copy
  part of the available neighborhood onto the boundary (_adiabatic_ and
  _reflection_ conditions).

Once defined the CA rules we have to run simulations but, depending on *initial
conditions*, we can obtain different results. Since the CA (as defined above) is
completely deterministic, and we may be interested in many possible system
behaviors, a common thing to do is simply try different initial conditions.

There exist some special rules that can be applied when the transition table of
a generic CA is too big:

- *Totalistic*: if the new value depends only on the sum of neighbors' values.
- *Outer totalistic*: if the new value depends only on the current cell's value
  and the sum of neighbors' values.

These two are just a more compact definition for some special rules but it does
not change anything about the semantics of the CA.

To have some idea of the expressive power of a given CA, the number of possible
rules can be counted by considering

- The number $k$ of possible states of a cell.
- The range $r$ of the neighborhood.

For a 1D CA for example, the number of possible rules is defined by the
following two formulas:

$
          k^(k^(2 r + 1)) & " possible rules" \
  k^((2 r + 1) (k-1) + 1) & " totalistic rules"
$

For example with $k=2$ and $r=1$ we have $256$ possible rules, while for $k=3$
and $r=1$ we have $8 dot 10^12$ possible rules.

Actually the particular base case is the *elementary CA*, where $k=2$ and $r=1$
that is the minimal setting to define a non-trivial cellular automata. On top of
elementary CAs are defined 4 *qualitative behavioral classes*, depending on the
type of state reached in the end:

+ Uniform final state
+ Simple stable or periodic final state
+ Chaotic, random, nonperiodic patterns
+ Complex, localized, propagating structures

Typically the last two are the most interesting patterns we are looking for.

= Conway's Game of Life

One of the most famous CA is the *Conway's game of life (GOL)* which is a simple
2D CA with a Moore neighborhood, and with a binary state for each cell (alive or
dead). The transition rule is very simple:

- *Birth*: a dead cell becomes alive if there are exactly 3 alive cells in its
  neighborhood.
- *Survival*: an alive cell stays alive if 2 or 3 neighbors are alive.
- *Death*: that can happen for isolation if there are less than 2 cells in the
  neighborhood, or by overcrowding if more than 3 neighbors are alive.

Although very simple, the GOL allow creating patterns with interesting
behaviors:

- *Blinkers*: periodic oscillators.
- *Gliders*: cells able to move.
- *Glider guns*: able to periodically create new gliders.

All these elements can be used as components of a computing device for example
by defining logical operators:

#figure(
  image("images/GOL_logical_operators.png", width: 70%),
  caption: [ Logical Operators from Game of Life ],
)

CAs can be used to encode Turing and machines and, in general, the trick to make
computation possible is to think about the CA as an I/O device: the initial
state is the input and the CA should go in a fixed point state, which is the
output. The difficulty stems from the fact that we use local rule to evaluate a
property that depends on information distributed globally.

= Variants

There exists a lot of variants for CAs, for example *particle CA* and
*probabilistic CA* that offer more ways and flexibility to model specific use
cases.
