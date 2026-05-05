#import "@local/note_template:0.1.0": *
#show: doc => note_template([Agent Based Modelling], doc)

#title()

Instead of modelling global behaviors we can model a system in a more fine
grained way with *agent based modelling (ABM)*. For example, to model a
_prey-predator_ environment, instead of modelling the fact that at each time
step a population decreases of some factor (determined by a function), we can
directly model preys and predators behavior and state.

This leads to a *multi-agent* paradigm in which each agent can be
_heterogeneous_, _interactive_ and _dynamic_. Also the environment can be
modelled, so that agents can interact with it.

In this sense ABM is bottom-up approach in which we let agents operate freely in
the environment, interact with it and with each other, letting the emergent
behavior emerge.

In general an *agent* is something that can *perceive* the environment through
*sensors*, and *interact* with it through *actuators*. The core characteristic
of ABM are that it models individuals that can be heterogeneous and follow local
rules to interact with each other. Also the environment evolves over time by
interaction with agents or some rule that is independently triggered when some
condition is met.

The *time* is typically discrete and progresses in ticks, at which all agents
(synchronous setting) make a step or only one agent (asynchronous setting) makes
a step.

= AI Agents

Agents' behavior can be _hard-coded_ if we want to keep it constant and see the
emergent behavior it produces. But what if we want to _learn_ a behavior such
that the agent can adapt in a specific way to the environment? For example we
want to know the best behavior in order to achieve a certain state.

This lead to *reinforcement learning* agents, able to learn behavioral rules
through direct interaction with the environment and a _reward mechanism_ which
allow them to try and get rewarded or penalized. The agent will find out the
optimal rule by maximizing the utility of each action.

= Game Theory

The *game theory* is the mathematical study of strategical interactions between
rational decision makers, in which each agent have to maximize a utility
function through the study of a strategy.

In this field a common goal is to identify *Nash equilibria*, that is a state
where no player has incentive to deviate from their strategy, assuming also
others will keep theirs unchanged.

There are also two main categories of study in which players can *compete* or
*cooperate*, which lead to different search strategies: one that maximizes the
personal payoff and the other the maximizes the collective utility.

One example is the _prisoner dilemma_ in which there is a conflict between
individual and collective rationality. In this setting, the best outcome can be
obtained by mutual cooperation, but since the two agents are also trying to
double betrayal, leading to Nash equilibria.

This can be used in ABM context to model more rational agents that for example
are trying to survive, but at the same time collaboration with other agents can
have a bigger reward in the long run.

= Environment

The *environment* is an entity itself and provides *topology*, *resources* and
*constraints* to agents that live in it. It is often dynamic and has its own
rules like

- *Diffusion*: spreading substances.
- *Decay*: dissipation of signals over time.
- *Regeneration*: renewal of resources.

The *stigmergy* is an example of indirect communication through the environment
among angents in which:

- An agent leaves a *trace* in the environment.
- This trace changes the probability of future actions by other agents.

This can be better modelled with diffusion and decay of substances, leading to a
complex global coordination without agent-to-agent communication.

The environment can also be fully or partially observable, deterministic or
sotchastic, static or dynamic, leading to different and more or less complex
strategies and modelling techniques.
