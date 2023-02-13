NB. dup

NB. =========================================================
NB. jdup         - duplicate file
NB.
NB. if specific components are to be duplicated, these are read
NB. and written one at a time, otherwise the file is duplicated
NB. in batches of up to the size <max> given in the function.
jdup=: 3 : 0
'' jdup y
:

fl=. j_name x
'y sel'=. 2{.boxopen y
y=. j_name y

max=. 100000

if. own=. 0=#fl do.
  fl=. ((+./\.y='/')#y),'eraseme.pls'
end.

'h o'=. j_open y
if. h=_1 do. return. end.

if. #sel do.
  c=. #sel
  c jcreate fl
  hx=. jopen fl
  whilst. #sel=. }.sel do.
    (jread h;{.sel) jappend hx
  end.

else.
  'v s c l d f q'=. j_dir h
  if. v < V64L do.
    v=. j_getver h
  end.
  w=. (v e. V64B,V64L) { 8 16
  c jcreate fl
  hx=. jopen fl
  pos=. 0
  blk=. 1000
  read=. j_read@(h&;)
  dir=. j_readdir v,h,c,d
  while. #dir do.
    sel=. (blk <. #dir) {. dir
    dir=. blk }. dir
    while. #sel do.
      siz=. {:"1 sel
      len=. 1>.(max<+/\siz)i.1
      (read &.> <"1 len{.sel) jappend hx
      sel=. len}.sel
    end.
  end.

end.

jclose hx
if. o do. jclose h end.

if. own do.
  pos=. 0
  siz=. 1!:4 <fl
  '' 1!:2 <y
  while. siz>pos do.
    len=. max<.siz-pos
    (1!:11 fl;pos,len) 1!:3 <y
    pos=. pos+max
  end.
  1!:55 <fl
end.

j_validate fl
c
)

