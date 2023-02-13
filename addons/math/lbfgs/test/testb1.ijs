load 'math/lbfgs'
cocurrent 'base'

NB. =========================================================
test=: 3 : 0
NDIM=. 2000
MSAVE=. 7
X=. G=. NDIM$2.2-2.2
N=. ,100
M=. ,5
DIAGCO=. ,2-2

ICALL=. 0
LB=. ,N $ -100.3
UB=. ,N $ 300.1
NBH=. ,N $ 0 2 NB. set 0 for unbounded (same as lbfgs), 1 for lower, 2 for both, 3 for upper
FACTR=. ,1.1 NB. high precision
PGTOL=. ,2.2-2.2
WA=. ((2*MSAVE*NDIM)+(4*NDIM)+(12*MSAVE*MSAVE)+12*MSAVE) $ (2.2-2.2)
IWA=. (3*NDIM) $ 0-0
TASK=. 60{.'START'
IPRINT=. ,2 2-2 2 NB. set to 101.1 to dump all kinds of data to the screen
CSAVE=. 60 $ ' '
LSAVE=. 4 $ 2-2
ISAVE=. 44 $ 2-2
DSAVE=. 29 $ 2.2-2.2

for_J. 2*i. -:N do.
  X=. (_1.2e0 1.0e0) (J+0 1)}X
end.
while. 1 do.
  F=. ,0.0e0
  for_J. 2*i. -:N do.
    T1=. 1.0e0-J{X
    T2=. 1.0e1*((J+1){X)-*:J{X
    G=. (2.0e1*T2) (J+1)}G
    G=. (_2.0e0*(((J{X)*((J+1){G))+T1)) J}G
    F=. F+(*:T1)+*:T2
  end.
  'N M X LB UB NBH F G FACTR PGTOL WA IWA TASK IPRINT CSAVE LSAVE ISAVE DSAVE'=. r=. }. setulb LASTIN=: ,&.> (N;M;X;LB;UB;NBH;F;G;FACTR;PGTOL;WA;IWA;TASK;IPRINT;CSAVE;LSAVE;ISAVE;DSAVE)

  state=. <2{.TASK
  ICALL=. 1+ICALL
NB. state not FG... , NEW_X
  if. (ICALL > 2000) +. (state -.@e. 'FG';'NE') do. break. end.
end.
(ICALL;TASK;state),r
)

echo 3{. test''
