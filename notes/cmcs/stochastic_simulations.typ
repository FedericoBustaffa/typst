#import "@local/note_template:0.1.0": *
#show: note_template

#title("Stochastic Simulations") <stochastic-simulations>

Chemical reactions sometimes exhibit random behaviors that lead to the
definition of #strong[stochastic simulation algorithms] to simulate them.

The occurrence of a chemical reaction in a chemical solution is actually
difficult to be predicted in advance because the movement of the molecules in
the chemical solution is related with the interaction with the fluid. If we
ignore this low level interaction, the process appears random because we cannot
predict exactly when a specific combination of reactants will meet.

Another aspect to consider is the concentration of reactants; in fact when we
have high concentrations of reactants, the #strong[law of large numbers] allow
us to ignore random aspects of chemical reactions and justify the use of ODEs.
But with small concentrations the random aspects become crucial and
#strong[discrete variables] become necessary. If we consider for example the
reaction

$ A arrow.r^k B + C $

with only one molecule of $A$ in the solution. The ODEs would describe
the concentration of $A$ to pass slowly and continuously from $1$ to
$0$. In the real system the number of instances of $A$ would pass from
$1$ to $0$ with a discrete instantaneous change.

= Gillespie’s Stochastic Simulation Algorithm
<gillespies-stochastic-simulation-algorithm>

The #strong[Gillespie’s stochastic simulation algorithm (SSA)] is an exact
procedure for simulating the time evolution of a chemical reacting system by
taking proper account of the randomness inherent in such a system. Given a set
of reactions $cal(R) = { R_1 , dots.h , R_n }$, the SSA assumes a stochastic
reaction constant $C_mu$ for each chemical reaction $R_mu in cal(R)$ such that
$c_mu d t$ is the probability that a particular combination of reactants of
$R_mu$ react in an infinitesimal time interval $d t$.

The constant $c_mu$ is used to compute the #strong[propensity] (or stochastic
rate) of $R_mu$ to occur in the whole chemical solution, denoted $a_mu$, as
follows

$ a_mu = h_mu c_mu $

where $h_mu$ is the number of distinct molecular reactant combinations. Let
$R_mu$ be

$ l_1 S_1 + l_rho S_rho arrow.r^c l'_1 P_1 + l'_gamma P_gamma $

In accordance with standard combinatorics, the number of distinct reactant
combinations of $R_mu$ in a solution with $X_i$ molecules of $S_i$, is given by

$ h_mu = product_(i = 1)^rho binom(X_i, l_i) $

with $1 lt.eq i lt.eq rho$. The propensity $a_mu$ is used in the algorithm as
the parameter of an #strong[exponential probability distribution] modelling the
time between subsequent occurrences of reaction $R_mu$. Below the #emph[density]
function

$ f (x) = cases(delim: "{", lambda e^(- lambda x) & x gt.eq 0, 0 & x < 0) $

and the #emph[cumulative] function of the distribution

$ F (x) = cases(delim: "{", 1 - e^(- lambda x) & x gt.eq 0, 0 & x < 0) $

Remember also that the mean (expected value) of an exponentially distributed
variable with parameter $lambda$ is $1 / lambda$. Two important properties of
the exponential distribution are:

- #strong[Memory-less];: The simulation "forgets" about the history
  $ P (X > t + s divides X > s) = P (X > t) $
- Let $X_1 , dots.h , X_n$ be independent exponentially distributed random
  variables with parameters $lambda_1 , dots.h , lambda_n$. Then the variable

  $ X = min (X_1 , dots.h , X_n) $ is also exponentially

  distributed with parameter $lambda = lambda_1 + dots.h - lambda_n$. So that
  the algorithm can use a unique exponential distribution for the whole set of
  reactions.

The algorithm keep the #strong[state] of the simulation which is formed by

- A vector representing the multi-set of molecules (initially
  $X_1 , dots.h , X_n$).
- A real variable $t$ representing the simulation time (initially $t = 0$).

The algorithm iterates the following steps until $t$ reaches a final value
$t_(upright("stop"))$.

+ The time $t + tau$ at which the next reaction will occur is randomly chosen
  with $tau$ exponentially distributed with parameter
  $a_0 = sum_(nu = 1)^M a_nu$.
+ The reaction $R_mu$ that has occur at time $t + tau$ is randomly chosen with
  probability $a_mu \/ a_0$.

At each step $t$ is incremented by $tau$ and the multi-set representing the
chemical solution is updated by subtracting reactants and adding products.

= References <references>

- Complex Systems
- #link(
    "https://scispace.com/papers/stochastic-simulation-of-chemical-kinetics-53h3kqhk7k",
  )[Stochastic Simulation of Chemical Kinetics]

