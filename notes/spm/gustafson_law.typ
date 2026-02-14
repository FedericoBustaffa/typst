= Gustafson’s Law
<gustafsons-law>
The #strong[Gustafson’s law] tries to take into account also weak
scalability in a more general formula because is quite common that when
we use more processors, we also want to increase the problem size. In
this case we talk about #strong[scaled speedup];, that incorporates such
scenarios when calculating the achievable speedup.

As before we consider the sequential version as baseline

$ T_(alpha beta) (1) = alpha dot.op T_(upright("ser")) + beta dot.op T_(upright("par")) = alpha dot.op f dot.op T_c (1) + beta dot.op (1 - f) dot.op T_c (1) $

where $alpha$ is a scaling function for the part of the program that
cannot be parallelized and $beta$ a scaling function for the
parallelized part. Similarly to Amdahl’s law we can now compute the
speedup as follows

$ S_(alpha beta) (p) = frac(T_(alpha beta) (1), T_(alpha beta) (p)) lt.eq frac(alpha dot.op f dot.op T_c (1) + beta dot.op (1 - f) dot.op T_c (1), alpha dot.op f dot.op T_c (1) + frac(beta dot.op (1 - f) dot.op T_c (1), p)) = frac(alpha dot.op f + beta dot.op (1 - f), alpha dot.op f + frac(beta dot.op (1 - f), p)) $

As before we can use the ratio $gamma = beta / alpha$ of the problem
complexity scaling between the parallelizable part and the
non-parallelizable part.

$ S_gamma (p) lt.eq frac(f + gamma dot.op (1 - f), f + frac(gamma dot.op (1 - f), p)) $

There are two notable cases for the possible values of $gamma$:

- $gamma = 1$ ($alpha = beta$): we obtain the Amdahl’s law.
- $gamma = p$: we obtain the Gustafson’s law, that means that the
  parallelizable part grows linear in $p$ while the non-parallelizable
  part remains constant.
  $ S (p) lt.eq f + p dot.op (1 - f) = p + f dot.op (1 - p) $

== Functional Dependency of Scaled Speedup
<functional-dependency-of-scaled-speedup>
If we parametrize the speedup with $gamma = p^delta$ we can reason in
terms of $delta$ and we can again notice that for

- $delta = 0$ we have $gamma = 1$, so we obtain the Amdahl’s law.
- $delta = 1$ we have $gamma = p$, so we obtain the Gustafson’s law.

We can now use this formula to compute the efficiency as follows

$ E_gamma (p) = frac(S_gamma (p), p) $

that becomes

$ E_gamma (p) lt.eq frac(f + (1 - f) dot.op gamma, p dot.op f + (1 - f) dot.op gamma) $

Computing the limits for $p arrow.r oo$ and for different values of
$gamma$ we obtain

$ lim_(p arrow.r oo) E_(gamma = p) (p) = 1 - f &  & lim_(p arrow.r oo) E_(gamma = 1) (p) = 0 $

#strong[Linear] parametrizations of the arguments that guarantee
constant efficiency are called #strong[iso-efficiency lines] and can
help to answer the following questions:

- How much must $delta$ increase in order to preserve parallel
  efficiency for increasing $p$?
- How much does the parallelizable part of our problem need to grow if
  we want to keep the same efficiency while using more processing units.

In this way is possible to fix the efficiency and try to tune $p$ and
$delta$ and find a nice combination of these two parameters.

== References
<references>
- \[\[parallelization\_laws\]\]
- \[\[amdahl\_law\]\]
