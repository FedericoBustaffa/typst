= Intelligent Agents
<intelligent-agents>
An #strong[agent] is anything that can act and it is usually equipped
with #strong[sensors] (to perceive the environment) and
#strong[actuators] (to interact with the environment).

The behavior of the agent can be defined through an #strong[agent
function] (or #strong[policy];)

$ f : P^(\*) arrow.r A $

where $P^(\*)$ is the history of all percepts and $A$ is the set of
possible actions.

To have a good intelligent agent is necessary to build the policy guided
some #strong[performance metric];, that in general, need to be
maximized. In some cases the metric is numerical but in others can be
the reach of some state. This can change how complex is to build a good
policy function.

Another important aspect is the type of environment the agent will be
in; this can be fully or partially observale, deterministic or
stochastic, static or dynamic, discrete or continuous etc. Being aware
of the environment is crucial for designers to build an efficient agent
with better strategies.

Usually a intelligent agent task is described through the #strong[PEAS]
schema:

+ #strong[P];erformance metric
+ #strong[E];nvironment
+ #strong[A];ctuators
+ #strong[S];ensors

From which we can define the #strong[agent architecture] (A + S), while
the agent itself is composed by the architecture and the policy function
that uses sensors and actuators.

== References
<references>
- \[\[artificial\_intelligence\_fundamentals\]\]
