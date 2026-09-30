# acnewton
APL package to numerically solve for diameter given arc and chord length

To exercise the package, )COPY in the solver and a testsuite and time N runs of the solver.

```
      )copy acnewton.apl
DUMPED 2026-09-30  10:33:33 (GMT-7)
      )copy acnewtontc01.apl
DUMPED 2026-09-30  10:33:42 (GMT-7)
      )nms
acnewton∆init.3     acnewton∆newton.3       acnewton∆param.2
acnewton∆solve.3    acnewton∆validate.3     chord01.2
driver.3            driver2.3
driver3.3           ratio.2                 testsuite01.2
timeit.3
      ⊣timeit testsuite01
 elapsed  151
```
