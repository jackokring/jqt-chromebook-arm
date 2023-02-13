NB. ascii85.ijs  - convert to/from ascii85 representations
NB.
NB.   toascii85     to ascii85 representation
NB.   fromascii85   from asci855 representation
NB.
NB. Note: the encoding does not begin with '<~', though sometimes
NB. that is allowed. However PDF files do not accept this prefix.
NB. Decoding supports the prefix.

NB. =========================================================
NB. encode to ascii85
NB. returns lines of length no more than 75 + LF
toascii85=: 3 : 0
r=. ,y
len=. #r
r=. 256 #. _4[\ a.i.r
m=. 0 (_1) } r = 0
n=. 5 * I.m
r=. a. {~ 33 + ,(5#85) #: r
r=. 'z' n } r
m=. 1 n } 5 # -. m
r=. m # r
r=. (- (4|len) { 0 3 2 1) }. r
r=. }: ,(_75 [\ r),.LF
('~>',LF) ,~ (r i: ' ') {. r
)

NB. =========================================================
fromascii85=: 3 : 0
r=. ,y
r=. a.i.r
r=. (r > 32) # r
r=. (2 * (a.i.'<~') -: 2 {. r) }. r
r=. (-2 * (a.i.'~>') -: _2 {. r) }. r
m=. r = a.i.'z'
r=. r - 33
r=. 0 (I.m) } r
r=. (1+4*m) # r
b=. 5 | #r
r=. r,84 #~ b{ 0 4 3 2 1
r=. a.{~ ,(4#256) #: 85 #. _5 [\ r
r }.~ - b { 0 0 3 2 1
)
