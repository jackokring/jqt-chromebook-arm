	NB. uu - utilities.ijs
'==================== [z] utilities ===================='
cocurrent 'z'  NB. <<<<< MAKE THESE VISIBLE TO CAL & tests TOO

REPOCAL=: jpath '~Gitrcal'
REPOUU=:  jpath '~Gitruu'

O=: '\'-.~ 0 :0
cal''  NB\. open cal.ijs
cai''  NB\. open cal_interface
uui''  NB\. open uu_interface
uuc''  NB\. open uuc
uuf''  NB\. open uuf
uut''  NB\. open uu lab
utf''  NB\. open uu test folder
)

cal=: 3 : 'open REPOCAL,''/cal.ijs'''
cai=: 3 : 'open REPOCAL,''/source/cal_interface.ijs'''
uui=: 3 : 'open REPOUU,''/source/uu_interface.ijs'''
uuc=: 3 : 'open TPUC sl ''/uuc.ijs'''
uuf=: 3 : 'open TPUF sl ''/uuf.ijs'''
uum=: 3 : 'open TPUM sl ''/uum.ijs'''
uut=: 3 : 'open TPUU sl ''/uu.ijt'''
uuu=: 3 : 'open TPUU sl ''/uu.ijs'''
utf=: 3 : 'openf REPOUU,''/test'''

test=: test_uu_
tpaths=: tpaths_uu_
ident=: ([: , [) -: ([: , ])  NB. atom -: list[1]
choice=: 4 : '((0>.1<.x)){y'  NB. always pick 0 or 1 of y
abs=: |
avg=: +/ % #
div=: %
int=: [: <. ] + 0 > ]
mod=: |~
times=: *

'==================== [uu] utilities ===================='
cocurrent 'uu'

test=: 3 : 0
  NB. builtin test of UU - to run it press fkey 5
smoutput '+++ BUILTIN TEST OF UU [CAL, TABULA]'
try. smoutput '--- VERSION of UU -- ',VERSION_uu_ catch. end.
try. smoutput '--- VERSION of CAL -- ',VERSION_cal_ catch. end.
try. smoutput '--- VERSION of TABULA -- ',VERSION_tabby_ catch. end.
  NB. tpaths.ijs - check TABULA TP*vars in _z_
smoutput '--- TP*_z_ paths:'
tpaths''
)

tpaths=: 3 : 0
  NB. the basic set is: TPCA TPCL TPTA TPTT TPUU
xx=. 3 : '". y,''_z_'''
zz=. 0 2$a:
zz=.zz ,  (xx z) ;~ z=:'TPAR'	NB. ttarchive	NB. ~home/tabula-user
zz=.zz ,  (xx z) ;~ z=:'TPAT'	NB. patch		NB. ~addon/math/tabula
zz=.zz ,  (xx z) ;~ z=:'TPCA'	NB.*cal		NB. ~addon/math/cal
zz=.zz ,  (xx z) ;~ z=:'TPCL'	NB.*cal_log.txt	NB. ~home
zz=.zz ,  (xx z) ;~ z=:'TPMC'	NB. manifest CAL	NB. ~addon/math/cal
zz=.zz ,  (xx z) ;~ z=:'TPMT'	NB. manifest TAB	NB. ~addon/math/tabula
zz=.zz ,  (xx z) ;~ z=:'TPMU'	NB. manifest UU	NB. ~addon/math/uu
zz=.zz ,  (xx z) ;~ z=:'TPNG'	NB. toolbar.png	NB. ~addon/math/tabula
zz=.zz ,  (xx z) ;~ z=:'TPSA'	NB. (SAMPLE*)	NB. ~addon/math/cal
zz=.zz ,  (xx z) ;~ z=:'TPTA'	NB.*tabula	NB. ~addon/math/tabula
zz=.zz ,  (xx z) ;~ z=:'TPTT'	NB.*(ttables)	NB. ~home/tabula-user
zz=.zz ,  (xx z) ;~ z=:'TPUC'	NB. uuc		NB. ~addon/math/uu
zz=.zz ,  (xx z) ;~ z=:'TPUF'	NB. uuf		NB. ~addon/math/uu
zz=.zz ,  (xx z) ;~ z=:'TPUM'	NB. uum		NB. ~addon/math/uu
zz=.zz ,  (xx z) ;~ z=:'TPUT'	NB. usertools	NB. ~addon/math/tabula
zz=.zz ,  (xx z) ;~ z=:'TPUU'	NB.*uu		NB. ~addon/math/uu
)

  NB. NEEDS CHECKING against long PI again >>>>>>>>>>>>>>>>>>>>
dfr=: 3 : '180*y%PI'
rfd=: 3 : 'PI*y%180'

NB. boxed substrings in x at the stars of pattern: y
cutByPattern=: 13 : '((;:y) -. <,ST) -.~ ;:x'
cutByPattern=: ((<,'*') -.~ [: ;: ]) -.~ [: ;: [

report_complex_nouns=: 3 : 0
  NB. check for complex nouns in given locale
loc=. >coname''
nocomplex=. 1
for_no. nl 0 do.  val=. ".nom=. >no
  if. 16=3!:0 val do.
    smoutput nb 'cx:' ; nom ; 'is complex'
    nocomplex=. 0
  end.
end.
  NB. Suppress ok-confirmation...
NB. if. nocomplex do. smoutput 'cx: no nouns are complex in: ',loc end.
i.0 0
)

isUndefined=: (3 : 0)"0
  NB. test for presence of (_.) in numeric(y)
if. -. 128!:5 y do. 0 return. end.
'_.' -: 5!:6 <'y'
)

quoted=: 3 : 0
  NB. =1 iff (y) is a quoted currency
(<toupper y) e. {."1 CUTAB
)

utoks=: 3 : 0
  NB. tokenize y, ensuring leading SP|SL
z=. sp1 y	NB. ensure leading sign-byte: SP|SL
z=. (z e. SP,SL) <;.1 z
)

vt=: viewtable=: ''&$: :(4 : 0)
  NB. y == list of indexes into UUC -- OR ALTERNATIVELY...
  NB.   y == single index (expands to a block of VIEWTABLE lines)
  NB.   y == nominal unit, e.g. 'G'
  NB.   y == open list of nominal units, e.g. 'G N'
  NB. x == OPEN list of names of nouns (usually the table's columns)
  NB. x == '' (defaulted) - use the default list: faux
  NB. VIEWTABLE (if defined) alters the default number of displayed lines (10)
faux=. 'i unitc units unitv uvalc rvalc uvalu rvalu uvald rvald'  NB. x-default value
  NB. …for meaning of a given list, see: terminology.txt
if. '' -:x do. x=. faux end.
if. isNo y do.
  y=. y+i.10 default 'VIEWTABLE'
end.
if. isLit y do.
  y=. units i. b4o y
end.
st =. (":&.>)"0	NB. utility verb: numlist-->string
cst=. ([: st [) ,. [: st ]  NB. utility verb: combine st-ed lists x y
]h=. ,: ;: cols=. x
]i=. i.#UUC
]t=. ". cols rplc SP;' cst '
h,y{t
)
0 :0 NB. SAMPLES...
vt I. uvalc ~: uvalu
vt I. uvald>0
)

dip=: 3 : 0
  NB. y is bool e.g. u2~:unitc or: unitc=_
assert (#y)=(#UUC)
smoutput '+++ how many? - ',": (+/y)
if. 0<+/y do.
smoutput '+++ their IDs?'
smoutput list I. y
smoutput '+++ their names?'
smoutput list units pick~ I. y
smoutput '+++ their codes?'
smoutput list unitc pick~ I. y
end.
smoutput 75#'-'
)

ID=: 3 : 0
  NB. lookup y in (units) -- return IDs
  NB. e.g.  ID 'm kWh gbp' --> 1 37 73
  NB. vt ID 'm kWh gbp'
units i. ;:y
)

sci2j=: '/%-_Ee'&charsub  NB. convert sci notation to j numeral
sci4j=: '%/_-eE'&charsub  NB. convert j numeral to sci notation
