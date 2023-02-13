NB. main

NB. =========================================================
NB. jappend      - append to file
jappend=: 4 : 0
'h o'=. j_open y
if. h=_1 do. return. end.
'v s c l d f q'=. j_dir h
if. -. v e. j_vcur '' do.
  'v s c l d f q'=. j_upver h
end.
w=. (v = V64B) { 8 16
free=. j_read h;f
dat=. j_box x
if. 1<#$dat do.
  if. o do. jclose h end.
  _3 return.
end.
res=. c+ i.#dat
'l free new'=. dat j_writerep l;free;h
dat=. , v j_tochar new
'b e'=. d
if. e>w*{:res do.
  dat 1!:12 h;b+w*c
  (j_rep free) 1!:12 h;{.f
else.
  dat=. (1!:11 h;b,w*c),dat
  free=. j_compress d,f,free
  'l free new'=. (<dat) j_write l;free;h
  'l f'=. j_writefree l;free;h
  d=. ,new
end.
c=. >:{:res
q=. >:{.q,0
(j_rep v;s;c;l;d;f;q) 1!:12 h;0
if. o do. jclose h end.
j_validate y
res
)

NB. =========================================================
NB. jclose      - close file
jclose=: 1!:22 :: _4:

NB. =========================================================
NB. jcreate      - create file
NB. overwrites any existing file
NB. optional left argument is initial # of components
jcreate=: 3 : 0
0 jcreate y
:
q=. s=. c=. 0
d=. 1024,<. >.&.(2&^.) 512>.8*x
f=. (+/d),256
l=. +/f
v=. IF64 { V32L,V64B
hdr=. ({.f){.j_rep v;s;c;l;d;f;q;s
hdr=. l{.hdr,j_rep i.0 2
y=. <j_name y
1!:55 :: 0: y
f=. (1: [ 1!:2) :: 0:
hdr f y
)

NB. =========================================================
NB. jerase       - erase file
jerase=: 1!:55 @ < @: j_name

NB. =========================================================
NB. jopen        - open file
NB. returns handle or _1
jopen=: 3 : 0
y=. >y
if. 0 e. #y do. _1 return. end.
if. j_ischar y do.
  y=. <j_ext y
  1!:21 :: _1: y
end.
)

NB. =========================================================
NB. jread        - read file
jread=: 3 : 0
'y x'=. y
'h o'=. j_open y
if. h=_1 do. return. end.
'v s c l d f q'=. j_dir h
if. v < V64L do.
  v=. j_getver h
end.
w=. (v e. V64B,V64L) { 8 16
cpt=. <.,x
if. (0=#cpt) +. 1 e. (cpt<0) +. cpt>:c do.
  if. o do. jclose h end.
  _2 return.
end.
dir=. (v,h,{.d) j_readcpt cpt
dat=. j_read &.> <"1 h,.dir
if. o do. jclose h end.
($x)$dat
)

NB. =========================================================
NB. jreplace     - replace in file
jreplace=: 4 : 0
't z'=. y
'h o'=. j_open t
if. h=_1 do. return. end.
'v s c l d f q'=. j_dir h
if. -. v e. j_vcur '' do.
  'v s c l d f q'=. j_upver h
end.
w=. (v = V64B) { 8 16
free=. j_read h;f
cpt=. <.,z
if. 0=#cpt do. return. end.
if. 1 e. (cpt<0) +. cpt>:c
do.
  if. o do. jclose h end.
  _2 return.
end.
dat=. j_box x
if. 1<#$dat do.
  if. o do. jclose h end.
  _3 return.
end.
dat=. (#cpt)$dat
dir=. (v,h,{.d) j_readcpt cpt
free=. j_compress dir,f,free
'l free new'=. dat j_writerep l;free;h
new=. <"1 v j_tochar new
new (1!:12 h&;) &.> ({.d)+cpt*w
'l f'=. j_writefree l;free;h
q=. >:{.q,0
(j_rep v;s;c;l;d;f;q) 1!:12 h;0
if. o do. jclose h end.
j_validate >{.y
cpt
)

NB. =========================================================
NB. jseqno
jseqno=: 3 : 0
'h o'=. j_open y
if. h=_1 do. return. end.
q=. >6{j_dir h
if. o do. jclose h end.
q
)

NB. =========================================================
NB. jsize
jsize=: 3 : 0
'h o'=. j_open y
if. h=_1 do. return. end.
'v s c l d f q'=. j_dir h
free=. j_read h;f
if. o do. jclose h end.
s,c,l,{:+/free
)
