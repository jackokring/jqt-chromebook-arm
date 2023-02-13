NB. calculate eigenvalues
NB.
NB. defines globals: LV EV RV RIM END
NB.
NB. LV EV RV   result of dgeev
NB. RIM END    points on unit circle, end points of eigenpicture
NB. WID        width of half axis

calc=: 3 : 0

RIM=: spokes SPOKES

'LV EV RV'=: cleanit each dgeev MATRIX

IFCOMPLEX=: iscomplex RV

if. IFCOMPLEX=0 do.
  RV=: {.@+. RV
  rv=. (,-) |:RV
  RIM=: rv, RIM
end.

END=: RIM + MATRIX mp"2 1 RIM
WID=: >. >./ | , END
)

NB. =========================================================
spokes=: 3 : 0
|: 2 1 o./ o. +: }: int01 y
)
