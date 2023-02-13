NB. roman

r100=. <;._1 '  c cc ccc cd d dc dcc dccc cm'
r10=. <;._1 '  x xx xxx xl l lx lxx lxxx xc'
r1=. <;._1 '  i ii iii iv v vi vii viii ix'
R1000=: , r100 ,&.>/ r10 ,&.>/ r1

NB. =========================================================
roman=: 3 : 0
r=. ('m'$~<.y%1000),R1000{::~1000|y
'(',r,')'
)
