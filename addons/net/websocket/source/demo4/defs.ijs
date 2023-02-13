NB. defs

cocurrent 'base'

a0=. ;: 'Ford GM Honda Toyota Total'
a1=. '2013';'2014'
a2=. ;: 'Hire Lease Sale'
a3=. ;: 'CA KS MN NY TX'
a4=. <;._1 '/Compact/Standard/Full Size/Luxury/MiniVan/SUV/Total'

AxisLabels=: a0;a1;a2;a3;<a4
AxisNames=: ;: 'Model Year Finance State Group'
AxisOrder=: , each 1 3;4;2 0;0 2
Shape=: # &> AxisLabels
d=. 3 + ?. 17 $~ _1 0 0 0 _1 + Shape
Data=: ,d,"1 0 +/"1 d=. d,"5 4 +/"5 d
