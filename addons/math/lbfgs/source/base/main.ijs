NB. Interface to J


NB. Adverb to run L-BFGS-B
NB. u is the function to be minimized.  It must accept a point (i.e. a list of coordinate values) and produce
NB.  function value; gradient
NB. where gradient is the list of partial derivatives wrt each coordinate
NB.
NB. Invocation: control-parms (u lbfgsmin) starting-point[;bounds]
NB. starting-point is the initial guess at the solution (shape n)
NB. bounds is (2,n) table of lower bound,:upper bound (if omitted, __ _ is used)
NB. control-parms is  [;corr-count[;term-eps[;grad-eps[;debug]]]]
NB.   If any value is omitted (i. e. a: or omitted), the default is used
NB.  corr-count is the number of correction dimensions (recommended 3-20; default=7)
NB.  term-eps terminates the search when the answer does not change by more than term-eps ULPs (default 1e7, moderate accuracy)
NB.  grad_eps terminates when the gradient's largest component is less than grad_eps (default 0, ignore the test)
NB.  debug selects debug information (see iprint below), default=_1 (no debug info)
NB.
NB. result is return code(0=result found, 1=not);best-x;(function value at best-x);(final value of task in the FORTRAN code (string))
NB.
NB. The verb created here runs in the user's namespace, where it always has access to u.  The verb is then executed on y[x] when they are given.
NB.
NB. Example use:
NB.    f=. +/@:*:@:(-&2 3) ; 2 * -&2 3   NB. function is (x-2)^2 + (y-3)^2; gradient is 2(x-2), 3(y-3)
NB.    (f lbfgsmin) 0 0
NB. +-+---+-+------------------------------------------------------------+
NB. |0|2 3|0|CONVERGENCE: NORM OF PROJECTED GRADIENT <= PGTOL            |
NB. +-+---+-+------------------------------------------------------------+
'ITERCT N M X LB UB NBH F G FACTR PGTOL WA IWA TASK IPRINT CSAVE LSAVE ISAVE DSAVE'=: i. 19
lbfgsmin=: 1 : 0
NB. Set up the input structure (also making the first call), and then loop until it indicates termination.  When it returns FG, we call the
NB. evaluation routine and install its results.  When it returns 'NE', we continue until it converges.
NB. On any other return we terminate the loop (indirectly).  After the loop we analyze the results
NB. Because of cd restrictions we must convert the result of f to a list
NB. We worry about the case where there is a sequence of FG_xxx with values that don't change much: then the iteration of tolerant ^:
NB. might terminate the iteration prematurely.  To prevent this we prepend an iteration counter. That will guarantee that ^: terminates only when  the FG/NEs are over.
lbfgsret_jlbfgs_ @: (((exeulb_jlbfgs_ @: ((F,G)}~ (0}~ ,&.>@:{.) @: u @: (X&{::))) ` (exeulb_jlbfgs_) `]) @.(('FG',:'NE') i. 2 {. TASK&{::)^:_) @: lbfgssetup_jlbfgs_ "1
)

NB. Support code for lbfgsmin

NB. Execute one round of setulb.  y is the input dataarea (with the extra last box for the iteration count)
NB. We execute setulb, discard the return code, and increment the iteration count to avoid falling out of the ^:_ loop
exeulb=: >:&.>@:{. 0} (setulb_jlbfgs_ @: }.)  NB. replace return code with incremented iterct

DEFAULTS=: 7;1e7;(2-2);_1
lbfgssetup=: 3 : 0
(0$a:) lbfgssetup y
:
NB. Get X and  bound information
if. 32 = 3!:0 y do. 'initvals bounds'=. 2 {. y
else. bounds=. __ _ #"0~ #initvals=. y
end.
assert. ($bounds) -: 2 , $initvals [ 'bounds length error'
NB. Get config information from x
x=. boxxopen x
assert. 5 > #x [ 'parms length error'
assert. #@> x [ 'parms not scalars'
'corr termeps gradeps debug'=. (a:&= {"0 1 ,.&DEFAULTS) 4 {. x
NB. Create the data area, field by field
n=. #initvals  NB. Number of coordinates, to save typing
m=. 3 >. <. corr  NB. number of correction vectors
dataarea=. < ,n  NB. N
dataarea=. dataarea , < 15!:15 ,m  NB. M, never less than 3
dataarea=. dataarea , < 15!:15 initvals  NB.  X
dataarea=. dataarea , <"(1) 15!:15 bounds  NB. LB,UB
dataarea=. dataarea , < 15!:15 (0 1 3 2) {~ +/ 2 1 * __ _ ~: bounds   NB. NBH, set when bound is not inf
dataarea=. dataarea , < 15!:15 ,2.2-2.2  NB. F
dataarea=. dataarea , < 15!:15 n$2.2-2.2  NB. G
dataarea=. dataarea , < 15!:15 ,termeps+2.2-2.2  NB. FACTR
dataarea=. dataarea , < 15!:15 ,gradeps+2.2-2.2  NB. PGTOL
dataarea=. dataarea , < 15!:15 ((n*(2*m)+5) + m * 8 + 11 * m)$2.2-2.2  NB. WA
dataarea=. dataarea , < 15!:15 (3*n)$2-2   NB. IWA
dataarea=. dataarea , < 15!:15 (60){.'START'  NB. TASK
dataarea=. dataarea , < 15!:15 ,_1  NB. IPRINT
dataarea=. dataarea , < 15!:15 (60) # ' '  NB. CSAVE
dataarea=. dataarea , < 15!:15 (4) # 2-2  NB. LSAVE
dataarea=. dataarea , < 15!:15 (44) # 2-2  NB. ISAVE
dataarea=. dataarea , < 15!:15 (29) # 2.2-2.2 NB. DSAVE
NB.  Make the initial call to the FORTRAN code and return the data area
if. 0 {:: dataarea=. setulb dataarea do. 'Error executing setulb in lbfgsmin' 13!:8 (8) end.
(<0) 0} dataarea
)

NB. Extract the final result from the last dataarea returned from FORTRAN.  Remember that the data area from exeulb has iteration count prepended
lbfgsret=: 3 : 0
('CO' -.@:-: 2 {. TASK {:: y);(X{::y);({.F{::y);TASK{::y
)

lbfgsmin_z_=: lbfgsmin_jlbfgs_
