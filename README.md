#  Tangent In ARM Assembly :memo:
## :pushpin: Short Description
  Calculation of the _tangent_ with a given accuracy by the formula:
  
  $$
  \begin{align}
  &\huge tg(x) = x + \frac{x^3}{3} + \frac{2x^5}{15} + \dots = \Large \sum_{n = 1}^{\infty} \frac{B_{2n}(-4)^n(1-4^n)}{(2n)!}x^{2n-1} \\ 
  &\large |x| < \frac{\pi}{2}, \text{ } B_{2n} - \text{ Bernoulli numbers}
  \end{align}
  $$
 
  Assembly language was used for the ***ARMv8(AArch64)*** architecture.
## :pushpin: Usage
   - [x] Download **BernoulliNums.txt**, **tan.s** and **Makefile.txt**
   - [x] Use the following commands with **QEMU**: <br>
         `make` <br>
         `aarch64-run` <br>
         `aarch64-debug` <br>
        And test in GDB.
  
  
