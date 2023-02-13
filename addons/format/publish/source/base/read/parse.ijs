NB. parse

NB. =========================================================
NB. parseml v parse markup language
NB.
NB.   1 entry, _1 exit
NB.   tag
NB.   parameter
NB.   value
parseml=: 4 : 0
msk=. (y = '<') > premask y
ndx=. msk i. 1
hdr=. ndx {. y
txt=. ndx }. y
if. 0=#txt do. ,:1;'';'';hdr return. end.
dat=. msk <;.1 y
len=. # &> dat

NB. ---------------------------------------------------------
ndx=. (dat i.&> '>') <. dat i.&> ' '
val=. ndx {.each dat
ife=. (<'</') = 2 {.each val
bgn=. ; len {.each (}.each val) e. x
end=. ; len {.each ife *. (2 }.each val) e. x
msk=. bgn +. end
bgn=. msk#bgn
end=. msk#end

NB. ---------------------------------------------------------
ndx=. msk i. 1
hdr=. hdr, ndx {. txt
dat=. msk <;.1 txt
ind=. dat indexq &> '>'
prm=. ind {.each dat
dat=. (1+ind) }.each dat

NB. ---------------------------------------------------------
sel=. '/' ~: {:&> prm
if. -. (sel#bgn) pairs sel#end do.
  throw '101 Begin and end tags do not match'
end.

NB. ---------------------------------------------------------
off=. bgn-end
prm=. (bgn++:end) }.each prm
ndx=. prm i.&> ' '
tag=. ndx {.each prm
prm=. (1+ndx) }.each prm
prm=. cutparms each prm
res=. (<&>off),.tag,.prm,.dat

NB. ---------------------------------------------------------
if. #hdr do.
  (1;'';'';hdr),res
end.

)
