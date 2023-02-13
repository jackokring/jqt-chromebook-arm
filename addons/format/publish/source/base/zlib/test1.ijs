NB. test1

NB. inflate pdf contents
inflatepdf=: 3 : 0
r=. ''
ff=. '/Filter /FlateDecode'
while. 1 do.
  ndx=. 1 i.~ ff E. y
  r=. r,ndx {. y
  y=. ndx }. y
  if. 0=#y do. break. end.
  ndx=. 6 + 1 i.~ 'stream' E. y
  r=. r,ndx {. y
  y=. ndx }. y
  if. LF = {. y do.
    r=. r,LF
    y=. }. y
  end.
  ndx=. 1 i.~ 'endstream' E. y
  txt=. uncompress_ppubzlib_ ndx {. y
  r=. r,txt
  y=. ndx }. y
end.
r
)
