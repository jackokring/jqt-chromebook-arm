NB. flip

NB. =========================================================
flipypos=: 3 : 0
ry=. $y
(ry $ 0, CY) + y * ry $ 1 _1
)

NB. =========================================================
NB. movepos
NB. form: line movepos xy
movepos=: [ + $@[ $ ]

NB. =========================================================
NB. moverect
NB. rect moverect xy
moverect=: 13 : 'x + ($x)$y,0 0'

NB. =========================================================
NB. scalepos
NB. dat scalepos xy
scalepos=: [ * $@[ $ ]

NB. =========================================================
NB. scalerect
NB. form: rect scalerect scalepos
scalerect=: 4 : 0
new=. y * old=. 2 3{x
((2{.x)+-:old-new),new
)
