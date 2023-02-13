load 'math/lbfgs'
cocurrent 'base'

NB.===========================================================
NB.
NB. Von Bertalanfy fit using LBFGS optimizatin
NB. outputs stats matrix & parm vector
NB. solution with EXCEL's SOLVER is linf = 55.9778, k = 0.385595, t0 = 0.171371
NB.

NB.========================================================================
NB. INPUTS
years=: 1.0 2.0 3.3 4.3 5.3 6.3 7.3 8.3 9.3 10.3 11.3
length=: 15.4 26.93 42.23 44.59 47.63 49.67 50.87 52.3 54.77 56.43 55.88
initial=: 30.0 0.20 0.01

NB.=======================================================================
VON_B=: 3 : 0
'a b c'=. y
l_pred=. a * (1 -^ - (b * years - c))
rss=. e +/ .* e=. length - l_pred
n2=: ($years)%2
NB. sd  =: %: var =: rss%$e
NB. (($years)%2)*((^.(o.2))+(2*^.sd) +1)
NB. (($years)%2)*((^.(o.2))+(^.var) +1)
NB. (n2*(^.rss))-(n2*^.$years)-(n2*(^.o.2))+n2
NB. (n2*(^.var))+(n2*(^.o.2))+n2
n2*(^.rss)
)

NB.========================================================================
DERIVLOGL=: 3 : 0
epsd=. 1e_5
f0=. OBJ_FN y
grad=. 0$0
for_i. i.#y do.
  yy=. (epsd+i{y) i } y
  f1=. OBJ_FN yy
  yyy=. ((-epsd)+i{y) i } y
  f2=. OBJ_FN yyy
  grad=. grad,(f1-f2)%+:epsd
end.
)

test=: 4 : 0
OBJ_FN=: (<x)`:6
n=. $parm=. y       NB. length n; number of parameters
m=. 5               NB. length 1; number of corrections used in BFGS update.  Should be between 3 and 7
diagco=. 2-2        NB. length 1; Logical variable; set at 0; if 1.0, need to provide diagonal matrix
diag=. n$2.2-2.2    NB. length n$0; provide double array if diagco 1
iprint=. 2 2-2 2    NB. length 2; only 0 0 implemented
eps=. 1.0e_5        NB. Accuracy of solution: grad < eps (max of 1, fun_parm)
machine=. 1.0e_16   NB. estimate of machine presision
w=. (n*(2*m+1)+2*m) $ 2.2-2.2   NB. workspace size for LBFGS
iflag=. 2-2         NB. initially set to 0; codes which indicate performance of routine
niter=. 0
while. niter <: 1000 do.
  fun_parm=. OBJ_FN parm       NB. Value of objective function at parm
  grad=. ((0.00001*parm) + (0.00000001*parm = 0)) OBJ_FN D: 1 parm  NB.  length n; gradient of objective function at parm
NB. grad  =.  DERIVLOGL parm
  'n m parm fun_parm grad diagco diag iprint eps machine w iflag'=. r=. }. lbfgs ,&.> (n;m;parm;fun_parm;grad;diagco;diag;iprint;eps;machine;w;iflag)
  if. iflag <: 0 do. break. end.
  output=. niter, ; 3 2 4{r    NB. iter, value, point, grad
  niter=. >: niter
end.
output
)

echo 'VON_B' test initial

