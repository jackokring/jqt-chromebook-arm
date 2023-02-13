NB. jpg

NB. =========================================================
readjpg=: 3 : 0
dat=. 1!:1 boxxopen y
if. -. 255 216 255 224 -: a.i.4{.dat do.
  throw '101 Not recognized as a JPEG: ',>y
end.
dat
)

NB. =========================================================
readjpgshape=: 3 : 0
ff=. 255{a.
sf=. a. {~ 192 + (i.16) -. 4 8 12
dat=. 4 }. y
while. 1 do.
  ndx=. dat i. ff
  if. ndx >: _10 + #dat do.
    throw '101 Could not read JPEG file correctly'
  end.
  sel=. (ndx+1) { dat
  if. sel=ff do. dat=. }. dat continue. end.
  if. sel e. sf do. break. end.
  len=. 256 #. a.i.(ndx+2 3) { dat
  dat=. (ndx+len+2) }. dat
end.
256 #. a.i. _2 [\ 5 6 7 8 { dat
)
