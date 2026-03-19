#import "@local/note_template:0.1.0": *
#show: doc => note_template([Causal Models], doc)

#title()

There are cases were we need to model *causality* over *independence*, and this
can be done by *causal models*. A little bit more formally we can say that a
random variable *causes* another if a _*manipulation*_ on the former alters the
distribution of the latter. A direct consequence of this is that a set of
completely different _causal structures_ can entail the same set of conditional
independences and dependences.

#important(title: [Reichenbach's Common Cause Principle])[
  Let $X$ and $Y$ be two variables such that $X$ and $Y$ are statistically
  dependent, then it holds:

  - $X$ is indirectly causing $Y$, or
  - $Y$ is indirectly causing $X$, or
  - There is a possibly unobserved common cause $Z$ that indirectly causes both
    $X$ and $Y$.
]

