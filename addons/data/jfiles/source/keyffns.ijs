NB. keyfilefns.ijs     keyed-file database (in jfiles locale)

NB. =========================================================
NB. keycreate file
keycreate=: 3 : 0
r=. jcreate y
if. r <: 0 do. return. end.
((1 7#'keyed file 2';'unused'),'';<'';i.0) jappend y
1
)

NB. =========================================================
NB. keydir file
keydir=: 3 : '>{.>jread y;9'

NB. =========================================================
NB. keydrop
keydrop=: 3 : 0
'f k'=. y
'h o'=. j_open f
if. h = _1 do. return. end.
'd c'=. >jread h;9
k=. ,each boxopen k
if. 0 e. k e. d do.
  if. o do. jclose h end.
  _4 return.
end.
b=. d e. k
'' jreplace h;b#c
b=. -. b
d=. b#d
c=. b#c
if. #e=. >jread h;8 do.
  if. 0 < L. e do. (<b#e) jreplace h;8 end.
end.
(<d;<c) jreplace h;9
if. o do. jclose h end.
1
)

NB. =========================================================
NB. keyerase
keyerase=: jerase

NB. =========================================================
NB. keyread file;key
keyread=: 3 : 0
'f k'=. key_right y
'h o'=. j_open f
if. h = _1 do. return. end.
'd c'=. >jread h;9
if. 0=#k do.
  r=. jread h;c
else.
  k=. ,each boxopen k
  if. 0 e. k e. d do.
    if. o do. jclose h end.
    _4 return.
  end.
  x=. d i. k
  r=. jread h; x { c
end.
if. o do. jclose h end.
r
)

NB. =========================================================
NB. keyreadx file;key
keyreadx=: 3 : 0
'f k'=. key_right y
'h o'=. j_open f
if. h = _1 do. return. end.
r=. >jread h;8
'd c'=. >jread h;9
if. 0 = L.r do. r=. (#c) # a: end.
if. #k do.
  k=. ,each boxopen k
  if. 0 e. k e. d do.
    if. o do. jclose h end.
    _4 return.
  end.
  x=. d i. k
  r=. x { r
end.
if. o do. jclose h end.
r
)

NB. =========================================================
NB. data keywrite file;key
keywrite=: 4 : 0
dat=. boxopen x
'f k'=. key_right y
'h o'=. j_open f
if. h = _1 do. return. end.
'd c'=. >jread h;9
if. 0=#k do.
  dat jreplace h;c
else.
  k=. ,each boxopen k
  x=. d i. k
  m=. x < #d
  if. 0 e. m do.
    new=. +/ m=0
    c=. c, key_new new;h;c
    d=. d, (m=0) # k
    x=. d i. k
    if. 0 < L. e=. >jread h;8 do.
      e=. e, new # a:
      (<e) jreplace h;8
    end.
    (<d;<c) jreplace h;9
  end.
  dat jreplace h; x { c
end.
if. o do. jclose h end.
empty''
)

NB. =========================================================
NB. data keywritex file;key
keywritex=: 4 : 0
dat=. boxopen x
'f k'=. key_right y
'h o'=. j_open f
if. h = _1 do. return. end.
'd c'=. >jread h;9
if. 0=#k do.
  if. -. (#dat) e. 1,#c do.
    if. o do. jclose h end.
    _3 return.
  end.
  (<dat) jreplace h;8
else.
  e=. >jread h;8
  if. 0 = L. e do. e=. (#c) # a: end.
  k=. ,each boxopen k
  x=. d i. k
  m=. x < #d
  if. 0 e. m do.
    new=. +/ m=0
    c=. c, key_new new;h;c
    d=. d, (m=0) # k
    e=. e, new # a:
    x=. d i. k
    (<d;<c) jreplace h;9
  end.
  (<dat x} e) jreplace h;8
end.
if. o do. jclose h end.
empty''
)

NB. =========================================================
NB.*key_new v make new components
NB. form: key_new number, handle, used
key_new=: 3 : 0
'n h c'=. y
f=. (10 }. i. 1{ jsize h) -. c
f=. (n <. #f) {. f
if. n > #f do.
  f=. f, ((n - #f)#a:) jappend h
end.
)

NB. =========================================================
key_right=: 3 : 0
if. 1=#y=. boxopen y do. y , a: else. y end.
)
