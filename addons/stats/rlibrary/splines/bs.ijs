NB. bs
NB.
NB. bs  - B-Spline Basis for Polynomial Splines

NB. =========================================================
NB. bs
NB. argument is package, where:
NB.   value x must be given
NB.   other values are optional
NB.
NB. possible package names:
NB.   x df knots degree intercept Boundary.knots
NB.
bs=: 3 : 0
nms=. ,each {."1 y
val=. {:"1 y
cmd=. ')' ,~ 'bs(', }. ; (',',],'=',]) each nms
try.
  rdcmd 'library(splines)'
  nms rdset val
  res=. rdget cmd
catcht.
  sminfo 'Splines Library';throwtext_rserve_
  res=. _1
end.
res
)
