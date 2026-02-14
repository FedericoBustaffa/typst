= Evolutionary Optimization
<evolutionary-optimization>
The field of #strong[evolutionary optimization] takes inspiration by the
darwinian #strong[biological evolution];, where an environment have some
#strong[initial conditions] and then starts evolving in an iterative
process mostly guided by #strong[natural selection];.

This approach lead to what are called #strong[evolutionary algorithms]
that are what is used to solve typically optimization problems; here why
the name #emph[evolutionary optimization];.

== Biological Evolution
<biological-evolution>
In this process of #strong[natural selection] there are some traits that
are more advantageous for some task and so they will survive, while
other traits will disappear. Usually there is some concept of
#emph[generation] in which a population lives and whose individuals
reproduce, combining their genetic traits, and so passing them to the
next generation.

So the aim is to use most interesting aspects of evolution like

- #strong[Punctuated equilibria];: evolution can happen fast.
- #strong[Adaptation];: a trait favored by natural selection becomes
  increasingly important for a given task.
- #strong[Exaptation];: finding a different use for a trait is
  previously developed for a different use.

These are the main points on which evolutionary optimization will focus.

Another interesting aspect of biological evolution is about
#strong[diversity];, which theoretically leads to a population of
individuals good in some task but genetically different.

Usually in nature this is achieved by the combination of

- #strong[Mutation];: random changes in genes.
- #strong[Recombination];: genetic shuffling of genetic material from
  different individuals.
- #strong[Natural selection];: survival of the fittest.

This is in general a #emph[divergent process] whose aim is to create
novelty.

== Digital Evolution
<digital-evolution>
So in order to have an evolution effect to solve some problem we need to
simulate #emph[initial conditions] of an environment and the
#emph[biological evolutionary algorithm] the powers the evolution.

The skeleton of a generic #strong[evolutionary algorithm] is the
following:

+ #strong[Initialize] a population of individuals with $N$ features.
+ #strong[Evaluate] the #emph[fitness] of the population.
+ For each step (generational step):
  - #strong[Select parents] based on fitness.
  - #strong[Reproduction];: generate offsprings by recombination of
    features.
  - #strong[Mutation];: random little variations on the features.
  - #strong[Evaluate] the fitness of new population.
  - #strong[Survival];: select a subset of $K$ individuals to keep.

Of course there are many details and variants for these algorithms that
can produce different effects and solutions.

The same structure have been used to develop two types of evolutionary
algorithms, but specialized for different purposes:

- #strong[Evolutionary strategies];: #emph[distribution-based]
  algorithms, generally for continuous optimization problems, in which
  the main operation is the mutation.
- #strong[Genetic algorithms];: #emph[population-based] algorithms were
  there is representation of a genome for the features, the mutation is
  rare and recombination is central.

These algorithms’ type of optimization is also called #strong[black-box
optimization] because their main goal is to maximize a #emph[fitness
function] without knowing anything on the function’s properties or
shapes, so there is no such thing as gradient descent or in general
#emph[derivative optimization];.

We can see the process as a random sampling process guided by an
heuristic function.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
- \[\[evolutionary\_strategies\]\]
- \[\[genetic\_algorithms\]\]
- \[\[novelty\]\]
