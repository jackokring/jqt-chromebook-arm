load 'math/lbfgs'
load 'math/calculus'
cocurrent 'base'

NB. =========================================================
test=: 3 : 0
'N M'=. 4 5           NB. dimension of X, number of corrections
f=. +/@:*:@:-&3 _2002 800 1 NB. example sum of squares  function

NB. Df=. f D. 1       NB. D. deprecated
h=. 1.0e_8            NB. h for numerical derivative
H=. (h&*)@=@i.@#      NB. diag h

'DIAGCO IFLAG'=. 2-2  NB. logical set to 0=false
DIAG=. N$2.2-2.2      NB. real set to 0
IPRINT=. 2 2-2 2      NB. integer: only 0 0 permitted
'EPS XTOL'=. 1.0e_5 1.0e_16    NB. real epsilon and tolerance
W=. ((N*(>:+:M))++:M)$2.2-2.2  NB. real work vector

X=. N$400.2-2.2      NB. initialize X
iter=. 0             NB. initialize iter
whilst. (IFLAG>0)*.(iter<:2000) do. iter=. >:iter
  F=. f X   NB. funtion value
  G=. f pderiv_jcalculus_ 1 X  NB. derivative value -- numerical derivative
  'N M X F G DIAGCO DIAG IPRINT EPS XTOL W IFLAG'=. r=. }. lbfgs ,.&.> (N;M;X;F;G;DIAGCO;DIAG;IPRINT;EPS;XTOL;W;IFLAG)
end.
iter;(f;])X
)

echo test''
