= Amdahl’s Law
<amdahls-law>
The #strong[Amdahl’s law] assumes that a program is composed by various
parts which must be #emph[serial] and some parts that can be
#emph[parallelized];.

This law describes the theoretical limit on the achievable speedup when
using multiple processors for a fixed problem size. It states that the
speedup is fundamentally limited by the #strong[fraction of sequential
code];. The upper bound described is often unrealistic and really far
away from the actual speedup obtained in reality.

To derive the Amdahl’s law we consider the completion time of the serial
version

$ T_c (1) = T_(upright("ser")) + T_(upright("par")) $

where $T_(upright("ser"))$ is the serial part that cannot be
parallelized and $T_(upright("par"))$ is the part the #emph[can] be
parallelized. We now assume that the best achievable speedup is linear,
from which we can derive an upper bound.

$ T_c (p) gt.eq T_(upright("ser")) + T_(upright("par")) / p $

So now we can compute the speedup like

$ S (p) = frac(T_c (1), T_c (p)) lt.eq frac(T_(upright("ser")) + T_(upright("par")), T_(upright("ser")) + T_(upright("par")) / p) $

Instead of using the absolute execution times, lets now use their
relative fraction; $f$ is the serial fraction whereas $1 - f$ is the
parallelizable fraction. The completion time is now expressed in terms
of

$ T_(upright("ser")) & = f dot.op T_c (1)\
T_(upright("par")) & = (1 - f) dot.op T_c (1) $

with $0 lt.eq f lt.eq 1$. So the speedup becomes

$ S (p) = frac(T_c (1), T_c (p)) lt.eq frac(T_(upright("ser")) + T_(upright("par")), T_(upright("ser")) + T_(upright("par")) / p) = frac(f dot.op T_c (1) + (1 - f) dot.op T_c (1), f dot.op T_c (1) + frac((1 - f) dot.op T_c (1), p)) = frac(1, f + (1 - f) / p) $

So we can use this law to predict the performance of a parallel program
providing the serial and parallel fractions.

Another interesting thing we can do is to put $p = oo$ and see what
happens

$ lim_(p arrow.r oo) frac(1, f + frac(1 - f, p)) = 1 / f $

Therefore strong scalability is limited by the serial fraction. We can
of course use this value to make some predictions on the efficiency:

$ E (p) = frac(S (p), p) = frac(1, p dot.op f + (1 - f)) $

== Overhead
<overhead>
The Amdahl’s law described above does not take into account the
#strong[parallelization overhead];, so it tends to be #emph[optimistic];.
A more realistic formula can be

$ S (p) lt.eq frac(1, [f + O (p)] + frac(1 - f, p)) $

where $O (p)$ is a function that takes into account the overhead.

This formula assumes that the overhead is part of the serial part but
could not always be the case. For example we can have parallel
communication among processes, which is still overhead but can be better
than serial communication.

== References
<references>
- \[\[parallelization\_laws\]\]
