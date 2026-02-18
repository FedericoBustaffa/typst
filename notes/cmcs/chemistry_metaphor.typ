#import "@local/note_template:0.1.0": *
#show: note_template

#title("Chemical Reaction Metaphor") <chemical-reaction-metaphor>

Another, and in many cases, simpler way to deal with continuous  i
think about them like #strong[chemical reactions];. This can be done because for
example we deal with quantities like population densities that increase or
decrease, just like #strong[reactants and products] of a chemical reaction.

= Notation <notation>

Chemical reactions describe transformation of molecules: a group of
#strong[reactants] is transformed in a group of #strong[products];.

Every molecule is assumed to float in a #emph[fluid medium] and the quantity of
each molecule is usually expressed in terms of #strong[concentration];, the
concentration of molecule $A$ is denoted as $[A]$ and it is usually expressed in
$upright("mol") \/ upright("L")$.

A general notation for chemical reactions is the following

$
  l_1 S_1 + dots.h + l_rho S_rho arrow.r^k l'_1 P_1 + dots.h + l'_gamma P_gamma
$

where

- $S_i$ and $P_i$ are respectively #emph[reactants] and #emph[products];.
- $l_i , #h(0em) l'_i in bb(N)$ are #strong[stoichiometric coefficients] which
  express the number of reactants or products of each type that are consumed or
  produced by the reaction.
- $k in bb(R)_(gt.eq 0)$ is the #strong[kinetic constant] which is a coefficient
  used to compute the #strong[rate of occurrence] of the reaction. This constant
  can be seen as the speed at which the reactants become products.

Chemical reactions are often #strong[reversible] and they can occur in both
directions

$
  l_1 S_1 + dots.h + l_rho S_rho harpoons.rtlb^k_(k_(- 1))
  l'_1 P_1 + dots.h + l'_gamma P_gamma
$

where $k_(- 1)$ is the kinetic constant of the inverse reaction and that is not
related to $k$.

= Law of Mass Action <law-of-mass-action>

The assumption we take for modeling chemical reactions is that all the molecules
float in a fluid medium, where they are free to move and randomly meet with each
other.

When a group of molecules meet, they #emph[can] react and the dynamics of the
possible chemical reaction are modeled by the #strong[law of mass action];, used
to compute the #strong[rate] of a chemical reaction in a given chemical
solution. In other words, the number of occurrences of such reaction in a given
chemical solution in a time unit.

#important(title: "Law of Mass Action")[
  The rate of a chemical reaction is proportional to the product of the
  concentrations of its reactants

  $ k [S_1]^(l_1) dots.h.c [S_rho]^(l_rho) $

  The same is also true for the reverse reaction and in both cases the kinetic
  constant is the #strong[proportionality ratio] of the reaction.
]

Let’s also notice that the #emph[kinetic constant] is a intrinsic property of
the chemical reaction, independent of the amount of reactants.

The rate of a chemical reaction, given a chemical solution and a time span, is
the number of reactions occurred (coputed in function of the kinetic constant
and the reactants concentrations).

== Dynamic Equilibrium <dynamic-equilibrium>

The #strong[dynamic equilibrium] is reached when, in a reversible reaction, the
two reactions constantly compensate each other. This happen when the rate of the
two is the same

$
  k [S_1]^(l_1) dots.h.c [S_rho]^(l_rho) =
  k_(- 1) [P_1]^(l'_1) dots.h.c [P_gamma]^(l'_gamma)
$

It is easy to see that at the equilibrium we have

$
  k / k_(- 1) = frac(
    [P_1]^(l'_1) dots.h.c [P_gamma]^(l'_gamma), [S_1]^(l_1)
    dots.h.c [S_rho]^(l_rho)
  )
$

and in this state some #emph[conservation properties] are exploited.

= From Reactions to ODEs <from-reactions-to-odes>

Reactions rates can be used to build a differential equation model that
describes the dynamics of a set of chemical reactions. This model will contain
one differential equation for each molecular species. For each molecule $S$, an
ODE is constructed by applying these two rules:

- In a reaction where $S$ occurs as a reactant, its ODE contains a negative term
  $- l r$ where $l$ is stoichiometric coefficient of $S$ in the reaction and $r$
  is the rate of the reaction.
- The same rule is applied when $S$ occurs in the products, but this time the
  term will be $+ l r$.

From these two generic reactions

$
  l_1 S_1 + dots.h + l_rho S_rho harpoons.rtlb^k_(k_(- 1))
  l'_1 P_1 + dots.h + l'_gamma P_gamma
$

we obtain the following ODEs

$
  frac(d [S_1], d t) = l_1 k_(- 1) [P_1]^(l'_1) dots.h.c [P_gamma]^(l'_gamma) -
  l_1 k [S_1]^(l_1) dots.h.c [S_rho]^(l_rho)\
  dots.v\
  frac(d [S_rho], d t) = dots.h\
  frac(d [P_1], d t) = l'_1 k [S_1]^(l_1) dots.h.c [S_rho]^(l_rho) - l'_1 k_(-
  1) [P_1]^(l'_1) dots.h.c [P_gamma]^(l'_gamma)\
  dots.v\
  frac(d [P_gamma], d t) = dots.h
$

This is quite mechanical but it works and in the end we obtain a system of ODEs
where the concentrations have become state variables values and a combination of
kinetic constants and soichiometric coefficients have become the ODE’s
coefficients.

#example[
  Let’s now consider the following chemical reaction
  $ 2 H_2 + O_2 harpoons.rtlb^5_0.5 2 H_2 O $
  The ODE that we can obtain for the $H_2$ molecule is
  $ frac(d [H_2], d t) = 2 dot.op 0.5 [H_2 O]^2 - 2 dot.op 5 [H_2]^2 [O_2] $
]

== From ODEs to Reactions <from-odes-to-reactions>

Often is also possible to pass from a ODE to a chemical reaction but with some
differences. Starting from the ODE we can translate every term in a chemical
reaction but this time we can have an infinite number of chemical reactions that
can be mapped from the initial ODE.

This is because a generic ODE can be generated from a chemical reaction by
adding and subtracting terms that are the product of all the reactants/products
and, more important the stoichiometric coefficient of the molecule and the
kinetic constant.

In other words when we translate from chemical reactions to ODEs we know the
value of every term involved, but when we do inverse translation we only have a
coefficient that is the result of a product among $k$, $l$ and various
concentrations.

#example[
  Let’s consider the previous example ODE obtained from a chemical reaction

  $ frac(d X, d t) = 6 X - 0.2 X Y $

  If we consider only the first term ($6 X$) we can say that the reaction has
  $X$ as a reactant and produces $X$: $ X arrow.r^k 2 X $ Now we need the
  kinetic constant but, as we can see the exponent of $X$ is $1$, so it is its
  stoichiometric coefficient and so we have that

  $ 1 \* k = 6 arrow.l.r.double k = 6 $

  the final reaction obtained is

  $ X arrow.r^6 2 X $

  if now repeat the same process for all the terms we obtain a set of chemical
  reactions that can be used in a numerical simulator.
]

There are cases where the translation is not possible, for example when the ODE
implies that a reaction reduces the concentration of some term without having
among its reactant:

$ frac(d X, d t) = 6 X - 0.2 X Y - Y $

In this case we have the negative term $- Y$ in which $X$ does not appear, but
the fact that it is negative means that some $X$ must be consumed as a reactant.

= References <references>

- Complex Systems
- Continuous Systems
