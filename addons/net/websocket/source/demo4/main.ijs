NB. main

NB. =========================================================
griddefs=: 3 : 0
enc AxisNames;AxisLabels;<AxisOrder
)

NB. =========================================================
NB. get data for given axis order
griddata=: 3 : 0
if. ischar y do. y=. dec y end.
AxisOrder=: ,each y
cube2html''
)

NB. =========================================================
gridindex=: 3 : 0
'rws cls sel ndx'=. y
d=. (sel,rws,cls) |: i.Shape
r=. (sel{Shape),(*/rws{Shape),*/cls{Shape
,(<ndx) { r ($,) d
)
