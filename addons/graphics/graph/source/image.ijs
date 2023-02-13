NB. save

NB. =========================================================
ppng=: 3 : 0
if. 0=#y do.
  y=. '~temp/graph.png'
else.
  y=. y, (-. '.png' -: _4 {. y) # '.png'
end.
initwin''
box=. 0 0, glqwh''
res=. glqpixels box
png=. (3 2{box) $ res
png writepng jpath y
EMPTY
)
