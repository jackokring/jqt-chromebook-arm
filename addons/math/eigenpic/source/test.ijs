NB. test dgeev

load '~Addons/math/eigenpic/source/dgeev.ijs'

mp=: +/ . *

NB. =========================================================
test_dgeev=: 3 : 0
m=. 2 2$,y
r=. <m
'lv ev rv'=. dgeev m
r=. r,<ev;rv
's t'=. ev
'sv tv'=. |: rv
sb=. (m mp sv) -: s * sv
tb=. (m mp tv) -: t * tv
if. sv -: tv do.
  vb=. 1
else.
  vb=. (ev * =i.2) -: clean (%.rv) mp m mp rv
end.
(sb,tb,vb);r
)

NB. =========================================================
NB. eigenpicture demos:
test_dgeev _4 3 1 5 % 2
test_dgeev 1 _1 _1 1
test_dgeev (4-%:3), 1 _3, 4+%:3
test_dgeev 0 1 _2 _3
test_dgeev -1 2 _1 1
test_dgeev -3 2 _1 1

NB. =========================================================
NB. matrix with +/- w eigenvalues:
'a b c'=. 2 3 7
test_dgeev c,(a-b),(a+b),-c
