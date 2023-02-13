NB. handy4uu.ijs
0 :0
Tuesday 27 August 2019  15:09:09
-
Establishes in _z_ all handy verbs actually needed by UU CAL TABULA
)

cocurrent 'z'

atrain=: adverb define
  NB. LF-separated list --> train using Adverse (::)
  NB. needs to be defined before first use
13 : ('(', ')y',~ (}:u) rplc LF ; ' ::')
)

ddefine=: adverb : 'm&$: : (4 : 0)'

ide=: 3 : 0
select. y
  case. 0 do. wd 'ide hide' [IDE_z_=: y
  case. 1 do. wd 'ide show' [IDE_z_=: y
  case.   do. ide -.IDE_z_	NB. toggle status
end.
)

runlab=: 1&$: : (4 : 0)
  NB. run the lab: y (paranoid version)
if. 0=#y do.
  if. absent'thelab_z_' do. thelab_z_=: jpath TPUU,'/uu.ijt' end.
  y=. thelab_z_
end.
if. -.fexist y do.
  smoutput '>>> runlab: file not found: ',y
  return.
end.
if. x-:0 do. open y return. end.
]thelab_z_=: y
(trace_cal_ :: 0:) 0
(trace_uu_ :: 0:) 0
require '~addons/labs/labs/labs.ijs'
try. lab_jlab_ thelab
catch.
  require '~addons/labs/labs/labs805.ijs'
  lab_jlab805_ thelab
end.
)

AZ=: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
CM=: ','
CO=: ':'
DT=: '.'
NUL=: 0{a.
QT=: ''''
SP=: ' '
az=: 'abcdefghijklmnopqrstuvwxyz'
n9=: '0123456789'

Cut=: <;._1
real=: 9&o.
imag=: 11&o.
ifdefined=: 0 <: [: 4!:0 <
isLit=: 2 2048 e.~ 3!:0
isNo=: isNum *. isScalar
isNum=: 1 4 8 16 64 128 e.~ 3!:0  NB. accepts complex num too (…16…)
isReal=: 1 4 8 64 128 e.~ 3!:0    NB. NOT complex num (…16…)
isScalar=: [: {. 0 = [: $ $
isStr=: ([: -. '' -: ]) *. ] -: [: , ":
daterev=: 3 : 'if. 31<2{y do. |.3{.y else. 3{.y end.'
dayy=: (Cut ' Sunday Monday Tuesday Wednesday Thursday Friday Saturday') pick~ [: weekday 3 {. ]
isBoxed=: 0 < L.
loadall=: [: load&.> ([: pathof&.> <&jpath) ,&.> [: {."1 [: 1!:0 <&jpath
llog=: (1 { ":)@(,@([: ] ;: ,. [: ".&.> ;:))
q1=: '''' , '''' ,~ [: ": >
smclear=: 3 : 'wd ''sm set term text *'',y'
  NB. smresolve=. is only used by Swift-string verb: sw
smresolve=: (((<0),(<3 3 2$1 0 0 0 0 0 2 1 2 1 2 1 2 0 0 3 2 0),<'(';')') ;: ucp)"1
sw=: ] rplc [: , (paren&.> ,. ":&".&.>)&smresolve
emsg=: smoutput&sw		NB. for error signal: always smoutputs
ssw=: smoutput&sw		NB. the standard verb: always smoutputs
ifabsent=: 4 : 'if. ifdefined y do. ".y else. x end.'
all=: *./
and=: *.
any=: +./
begins=: beginsWith=: ] -: [ {.~ [: # ]
endsWith=: ends=: [ (] -: [ {.~ [: - [: # ]) [: , ]
brack=:	1 |. '][' , ":  NB. layout tool for message string ->'[y]'
nb=: [: ([: }. [: ; ' ' ,&.> ]) ":&.>	 NB. embed nums in string
or=:  +.
not=: -.
sl=: ('//';'/') stringreplace ('\';'/') stringreplace [ , '/' , ]
to=: [ + [: i. [: >: -~	NB. eg: 3 to 5 <--> 3 4 5
NaNoun=: 0 ~: [: nc ;:  NB. y==open list, recommended for: absent
cmx=: [: > <;._2   NB. use with (0 : 0) --needs LF-: {:y
date=: 6!:0@('YYYY-MM-DD  hh:mm:ss'"_)
day=: dayy&daterev

default=: 0&$: :(4 : 0)
	NB. pronoun (y) created with value (x)
	NB. UNLESS name (y) already in-use.
	NB. NOT compatible with the "misc.ijs" version
	NB. which has x<--> swapped.
	NB. Permits MYVAR=: 99 default 'MYVAR'
	NB. as well as:   99 default 'MYVAR'
if. 0<: 4!:0 <y do. y~ return. end.
(y)=:x
)

edwn=: 3 : 0
  NB. return choice (y) of data from top Edit window
t=. wd'sm get edit'  NB. table: boxed(3 2) from Edit window
select. {.y
fcase. ' ' do.  NB. to match prev behavior
fcase. {.'text' do.
case. 0 do.
	(<0 1) pick t
fcase. {.'range' do.
case. 1 do.
	". (<1 1) pick t
fcase. {.'path' do.
case. 2 do.
	z=. (<2 1) pick t
	wd 'clipcopy *',utf8 z
	'+++ edwn: copied: ',LF,z
fcase. {.'selected' do.
case. 3 do.
	z=. ucp (<0 1) pick t
	utf8 z{~ }: to/ ". (<1 1) pick t
case. '?' do.
	smoutput 'edwn ''text'''
	smoutput 'edwn ''range'''
	smoutput 'edwn ''path'''
	smoutput 'edwn ''selected'''
end.
)

min=: $:/ :<.
paren=: 1 |. ')(' , ":
parentpathof=: [: pathof [: }: pathof
pathof=: ] {.~ [: >: '/' i:~ ]
rnd=: 0&$: :(4 : '(<. 0.5 + y*10^x)%10^x')
term=: 3 : '>{:{. wd''sm get term'''  NB. (string) from Term window
vv=: ":@|:@,:

	NB. handy4cal.ijs
append=: [ 1!:3 [: < ]

countdown=: 3 : 0
	NB. Returns a countdown to control potential runaways.
	NB. countdown '?'  NB. query the o/s count
	NB. countdown 500	NB. set a limit
	NB. countdown''    NB. forces error after 500 calls
	NB. -Alternatively: take action on (0=countdown'')
if. y-:'?' do.
  COUNTDOWN_z_ NB. [ sess1 'COUNTDOWN=',":COUNTDOWN_z_
elseif. 0=#y do.
  if. 0=COUNTDOWN_z_ do. 'countdown over'(13!:8)199 end.
  COUNTDOWN_z_=: COUNTDOWN_z_-1
elseif. do.
  assert. 0< <.y
  COUNTDOWN_z_=: <.y
end.
)

crex=: 0&$: :(4 : 0)
	NB. printable lit repn of (string)noun y
	NB. y is VALUE. For cr-replacement use: crx
	NB. x=1 reveals diagnostics otherwise hidden
NB. Need to deal with null case first
if. 0 e. $y do. 5!:6 <'y' return. end.
z=. y rplc QT ; QT,QT  NB. SHOULD leave non-null & non-byte intact
z=. q1 z rplc CRLF ; (q1',CRLF,') ; CR ; (q1',CR,') ; LF ; (q1',LF,') ; TAB ; (q1',TAB,')
NB. catch remaining non-print chars in: y
for_c. ~. y -. 32}. 127{. a. do.
  z=. z rplc c ; q1 CM, CM,~ paren (":a. i. c),'{a.'
end.
NB. eliminate: '',*  *,'' *,'',*
z=. z rplc (CM,QT,QT,CM) ; CM
if. (3{.z)-:QT,QT,CM do. z=. 3}.z end.
if. (_3{.z)-:CM,QT,QT do. z=. _3}.z end.
NB. specify ravel for vec len: 1
if. ($y)-:(,1) do. z=. CM,z end.
try. assert y -: ".z	NB. Does it convert back again?
catch.
  if. x do.
    smoutput '>>> crex: BAD lit repn: z --'
    smoutput z
    smoutput '>>> crex: --using instead: 5!:6 <''y'''
  end.
  5!:6 <'y' return.	NB. use built-in conversion instead
end.
z
)

  NB. smcut3: cut into 3 cols at first TWO whitespace-sections
s=. 6 3 2$0 0 0 0 1 1 2 3 2 3 1 0 2 0 2 0 3 1 4 3 4 3 3 0 4 0 4 0 5 1 0 3 5 0 5 0
m=. < LF ; NUL,SP,TAB
smcut3utf=: (0;s;m)&(;:"1)      NB. cuts utf-8 (byte) string
smcut3ucp=: ((0;s;m) ;: ucp)"1  NB. cuts unicoded string
smcut3=: smcut3ucp

dec=: 16 #. 16 | '0123456789ABCDEF0123456789abcdef' i. ]
errno=: 13!:11
isEmpty=: 0 = [: */ $
listnameswithprefix=: 0 1 2 3&$: :(] ((] -: ({.~ #))S:0 _ # [)~ a: , [ 4!:1~ [: {. ])
log=: [: ": ;: ,. [: ".&.> ;:
nouns=: 3 : 'z ,. (datatype each v) ,. v=.".each z=.nl 0'
np=: [: <: 2 * -.
NB. op=: 3 : 'opec ijs ''~proj/'',y'
pc=: '%' ,~ [: ": [: <. 0.5 + 100 * 88350 %~ ]
read=: [: 1!:1 <
st=: [: 1!:1 [: < tmp
sst=: smoutput@st
temp=: [: jpath '~temp/' , ijs@":
ts=: 6!:2 , 7!:2@]
wide=: uucp
write=: [ 1!:2 [: < ]

	NB. handy4tab.ijs
brace=: 1 |. '}{' , ":
cr=: [: 5!:5 boxopen
crr=: > , '=: ' , cr
cuT=: <;._2  NB. fret is {:y (c/f Cut)

platform=: 3 : 0
  NB. list the IF* booleans and their values
if. y-: 1 do. z=. 'IFJHS';'IFQT'
else. z=. 'IF' nl_z_ 0
end.
('=:',~"1 >z),. ": vv ". ','sfy z
)

dtlf=: #~ ([: +./\. LF&~:)   NB. delete trailing LF
dt0=:  #~ ([: +./\. '0'&~:)  NB. delete trailing '0'
edit=: [: open [: , [: > whichscript_z_
extx=: (0 < [: # ]) # ] , [ #~ [: -. '.' e. ]	NB. …tacit
fname=: ([: >: '/' i:~ ]) }. ] {.~ '.' i:~ ]
fw=: firstwords=: (' ' taketo ])"1  NB. take 1st word in each row of (cmx) y
ijs=: '.ijs'&extx
isBool=: isBools *. isScalar
isBools=: [: all 0 1 e.~ ]
max=: $:/ :>.
sllog=: smoutput@llog
sortd=: \:~ :\:
sq=: *: :[:
sqrt=: %: :[:
square=: *: :[:

NB. zulu verbs, now loaded directly from: format/zulu
0 :0
o4b=: b2o=:	}.@((<SP) ;@,. ])
b4o=: o2b=:	[: <;._1 SP , ]
b4f=: f2b=:	[: <;._1 LF , ]
f4b=: b2f=:	}.@((<10{a.) ;@,. ])
f4o=: o2f=: 3 : 'LF(I. y=SP)}y'
f4x=: x2f=: }.@((<10{a.) ;@,. ])@([: (#~ ([: +./\. ' '&~:))&.> <"1)
x2b=: [: (#~ ([: +./\. ' '&~:))&.> <"1
x4f=: ([: <;._1 LF , ]) (1 : 'if. 0=#y do. 0 0$'''' else. >@u y end.')
)