NB. multiline statements
NB.
NB. ismultiline  -     for explicit definitions
NB. dirdef_begin/end - for {{ }} definitions

NB. =========================================================
NB. return if line is start of multiline definition
NB. checks only most common cases, using standard library
Multiline=: (,each '01234'),;:'noun adverb conjunction verb monad dyad'

ismultiline=: 3 : 0
if. 0=#y do. 0 return. end.
t=. ;: :: 0: y
if. t-:0 do. 0 return. end.
if. (<'Note') = {.t do. 1 return. end.
n=. I. }: t e. Multiline
if. 0=#n do. 0 return. end.
if. (<'define') e. (n+1){t do. 1 return. end.
(,each ':0') e. (n+/1 2){t,<''
)

NB. =========================================================
NB. multiline direct definition begin
NB. result is count of multiline defs started
NB. note this for single lines only, not surrounding lines
dirdef_begin=: 3 : 0
t=. ;: :: 0: y
if. t-:0 do. return. end.
b=. t = <'{{'
e=. (t = <'}}') *. +./\ b
0 >. +/ b - e
)

NB. =========================================================
NB. multiline direct definition end
NB. result is count of multiline defs ended
NB. same note as dirdef_begin
dirdef_end=: 3 : 0
t=. ;: :: 0: y
if. t-:0 do. return. end.
b=. t = <'{{'
e=. t = <'}}'
+/ e - b
)

NB. =========================================================
NB. y is boxed list of lines
NB. returns [p,s] where
NB. p = number of lines read (1 or more)
NB. s = string for J execution
getnextentry=: 3 : 0
p=. 1
s=. 0 pick y
t=. }.y
if. n=. dirdef_begin s do.
  while. #t do.
    p=. p + 1
    s=. s,LF,w=. 0 pick t
    n=. n - dirdef_end w
    if. n <: 0 do. break. end.
    t=. }.t
  end.
end.
if. ismultiline s do.
  n=. 1 + t i. <,')'
  s=. s,LF,tolist n {. t
  p=. p + n
end.
p;s
)
