NB. util

BOXEMPTY=: <''
BOXTYPE=: 32 NB. boxed type
CHARTYPE=: 2 131072 262144 NB. character types
EMPTY=: i. 0 0
LF2=: LF,LF
PATHJSEP=: PATHJSEP_j_
WHITESPACE=: TAB,CRLF,' '

create=: ]

addLF=: , (LF #~ 0 < #) -. {:
citemize=: ,:^:(2 > #@$)
dlb=: }.~ =&' ' i. 0:
fix=: 0&". ::]
intersect=: e. # [
partition=: 1 , [: -. }. -:"_1 }:
pfl=: [: ; {.&1&.>
readlist=: 3 : '<;._2 (0 : 0)'
tolist=: }.@;@:(LF&,@,@":each)
towords=: ;:^:_1
trimLF=: 3 : 'y #~ (+./\msk) *. +./\.msk=. y ~: LF'
trimWS=: 3 : 'y #~ (+./\msk) *. +./\.msk=. -. y e. LF,TAB,'' '''
wraptag=: '<'&, @ (,&'>')

NB. =========================================================
NB. endian - pdf always use big endian
endian=. ({.a.)={. 1&(3!:4) 1  NB. 0 little endian   1 big endian
toucodem=: ''&,@(1&(3!:4))@(3&u:)@u:
toucoder=: ''&,@:,@:(|."1@(_2: ]\ 1&(3!:4)))@(3&u:)@u:
toucode1=: toucodem`toucoder@.(-.endian) f.
4!:55 <'endian'  NB. Remove definition of 'endian' to avoid problems if the name is publicly assigned later

NB. =========================================================
is1integer=: ({. -: <.) :: 0:
isboxed=: 0 < L.
ischar=: 3!:0 e. CHARTYPE"_
isempty=: 0 e. $
isinteger=: (-: <.) :: 0:
isnumeric=: [: -. 3!:0 e. (CHARTYPE,BOXTYPE)"_
isscalar=: 0 = #@$
is1color=: 3 = */ @ $

round=: [ * [: <. 0.5"_ + %~
roundint=: <. @ +&0.5

NB. =========================================================
NB. required debug verbs
debugq=: 13!:17
debugss=: 13!:3
debugstack=: 13!:13

NB. =========================================================
NB. ascii2utf8
NB. Convert ascii to utf-8.
NB. 7-bit ascii is unchanged.
NB. 8-bit ascii is mapped to two characters
NB.
NB. examples:
NB.    a. i. ascii2utf8 165 { a.  NB. yen sign
NB. 194 165
NB.    a. i. ascii2utf8 225 { a.  NB. a acute
NB. 195 161
ascii2utf8=: 3 : 0
y=. a. i. y
y=. y #~ 1 j. 127 < y
c=. y {~ ndx=. I. 127 < y
n=. 192 128 +"1 [ 0 64 #: c
a. {~ n (<"0 ndx +/ 0 1) } y
)

NB. =========================================================
checktag2=: 3 : 0
if. 2 ~: #y do.
  throw '101 Invalid block for tag: ',wraptag 1 pick {.y
end.
if. -. (1;_1) -: {."1 y do.
  throw '101 Invalid begin, end tags for: ',wraptag 1 pick {.y
end.
{. y
)

NB. =========================================================
defineindex=: 3 : 0
y=. <;._2 (0 : 0)
('i',each y)=: i.#y
)

NB. =========================================================
destroy=: 3 : 0
coerase locT
codestroy''
)

NB. =========================================================
dictget=: 4 : 0
(({."1 y) i. boxxopen x) { ({:"1 y),<''
)

NB. =========================================================
dictget1=: > @: dictget

NB. =========================================================
filename=: 3 : 0
p=. PATHJSEP
d=. jpathsep deb y
if. 0 = #d do.
  throw '101 Filename is empty'
end.
if. IFWIN *: ':' = {: 2 {. d do.
  if. p ~: {.d do.
    d=. MasterPath,d
  end.
end.
d
)

NB. =========================================================
NB. index, ignoring quoted text
indexq=: 4 : 0
1 i.~ (x=y) > ~:/\x='"'
)

NB. =========================================================
info=: 3 : 0
sminfo@('Publish'&;) :: smoutput y
)

NB. =========================================================
getpath=: ([: +./\. =&PATHJSEP) # ]

NB. =========================================================
jcmd=: 3 : 0
loc=. 18!:5''
18!:4 <'base'
3 : '0!:100 y' y
18!:4 loc
)

NB. =========================================================
jcmdr=: 3 : 0
loc=. 18!:5''
18!:4 <'base'
r=. 3 : '". y' y
18!:4 loc
r
)

NB. =========================================================
jset=: 3 : 0
try.
  0!:100 y
catch.
end.
fixaligns''
)

NB. =========================================================
NB. create new instance, storing locale name
newinstance=: 4 : 0
obj=. cocreate''
coinsert__obj <y
COCREATOR__obj=: coname''
create__obj x
locT__locS=: locT,obj
obj
)

NB. =========================================================
pbuf=: 3 : 0
if. #y do.
  buf=: buf,,y,"1 LF
end.
)

NB. =========================================================
pbufread=: 3 : 0
a=. buf
buf=: ''
a
)

NB. =========================================================
pfmt=: 3 : 0
dat=. ": y
txt=. ,dat
($dat) $ '-' (I. txt='_') } txt
)

NB. =========================================================
pread=: 3 : 0
dat=. fread y
if. (dat -: _1) +. 0=#dat do. return. end.
NB. u16 marker:
if. (255 254 { a.) -: 2 {. dat do.
  dat=. utf8 6 u: 2 }. dat
NB. u8 marker:
elseif. (239 187 191 { a.) -: 3 {. dat do.
  dat=. 3 }. dat
NB. ansii codepage:
elseif. 0 -: 7 u: :: 0: dat do.
  val=. a. i. dat
  msk=. 127 < val
  uni=. 192 128 +"1 [ 0 64 #: msk # val
  val=. val #~ 1 j. msk
  ndx=. I. 127 < val
  dat=. a. {~ uni (<"0 ndx +/ 0 1) } val
end.
dat=. (-(26{a.)={:dat) }. dat
dat,LF -. {:dat=. toJ dat
)

NB. =========================================================
NB. round pdf positions to 2 dp
prnd=: 0.01 * [: <. 0.5 + 100&*

NB. =========================================================
query=: 4 : 0
x ((wdquery 'Publish'&;) :: (1: smoutput)) y
)

NB. =========================================================
rgb2alf=: 3 : 0
a.{~,|."1 [256 256 256 #: ,y
)

NB. =========================================================
NB. shrinkmargins
NB.
NB. form: rect shrinkmargins left,top,right,bottom
shrinkmargins=: 4 : 0
'l t r b'=. y
x + l,b,-(l+r),t+b
)

NB. =========================================================
NB. u2a
NB. Convert utf-8 to ascii (latin1)
u2a=: 5 u: 7 u: ]
