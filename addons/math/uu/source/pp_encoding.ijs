	NB. uu - pp_encoding.ijs
'==================== [uu] pp_encoding.ijs ===================='
0 :0
Corrected qtcode4anyunit: IAC Wednesday 6 May 2020  10:59:09
wd'msgs'  NB. REMOVED: IAC Wednesday 6 May 2020  12:19:12
)
cocurrent 'uu'

UNSETCODE=: BADCODE=: KILLERCODE=: ZEROCODE=: 0x
TRIVIALCODE=: 1x
Nmks=: #mks	NB. # of base units == # of primes for pp-coding
  NB. …Nmks used in tacit verbs. Otherwise scarcely faster than #mks
Pmks=: x:p:i.Nmks	NB. the first (#mks) primes

randompp=: 3 : '? Nmks#>:y'
encoded=:  3 : '*/ Pmks ^ y'		NB. pp-> code
decodedx=: 3 : 'x:^:_1 Nmks q: y'	NB. (extended)code-> pp
decodedr=: 3 : 'x:^:_1 -/decodedx 2 x: y'  NB. (rational)code-> pp
decoded=: decodedx :: decodedr

expandcode=: (0&$: :(4 : 0))"0
  NB. the canonical expansion (xunit) of code: y
NB. if. y=0 do. '' return. end.  NB. AVOIDS J HANGING <<<<<<<<<<<<<
if. y=0 do. ,ST return. end.  NB. code 0 is KILLERCODE --> '*'
asTokens=. x  NB. (bool): x=1 -return list of boxed tokens (not string)
for_p. decoded y[z=.'' do.
  unit=. p_index pick mks  NB. the mks unit, e.g. 'mol'
  SS=. (p<0){SP,SL
  select. p
  case.  0 do. cell=. 0        NB. to be omitted (0--crash if used)
  case.  1 do. cell=. SP,unit  NB. if p=1, exponent is redundant
  case. _1 do. cell=. SL,unit
  case.    do. cell=. SS,unit,PW,":|p
  end.
  if. p~:0 do.
    NB. ssw '--- [(p_index)]: append cell=[(cell)]'
    if. asTokens do. z=. z,<cell else. z=. z,cell end.
  end.
end.
if. asTokens do. z else. dlb z end.
)

NB. isGoodCode=: 13 : '-. y e. ZEROCODE,%ZEROCODE' "0
isGoodCode=: ([: -. (ZEROCODE,%ZEROCODE) e.~ ])"0

make_unitc=: 1&$: :(4 : 0)
  NB. x=pass# (1,2,3…)
  NB. does NOT use: msg or sllog, but ssw instead
ssw=. empty  NB. -to suppress smoutput, set: ssw to: empty
pass=. x
rebuild=. pass<:1
ssw '+++ make_unitc: pass=(pass) rebuild=(rebuild) #UUC=(#UUC)'
if. rebuild do.
  ssw=. empty
  uvalc=:(#UUC)$0
  rvalc=:(#UUC)$0r1	NB. <<<<<<<<<< rational
  unitc=:(#UUC)$UNSETCODE
end.
for_i. i.#UUC [n=.0 do.
  val=. i{uvalc [code=. i{unitc
  rval=. i{rvalc		NB. <<<<<<<<<< rational
  if. (-. isGoodCode code) or (0=rval) do.	NB. <<<<<<<<<< rational
    ssw '--- id=(i) val=(val) code=(crex code) [(i pick units)]'
    NB. …use of crex prints 4x instead of 4 (say)
    'val rval code'=. qtcode4i i	NB. <<<<<<<<<< rational
    ssw '--- id=(i) val=(val) rval=(rval) code=(crex code)(LF)'
    uvalc=: val  i}uvalc
    rvalc=: rval i}rvalc	NB. <<<<<<<<<< rational
    unitc=: code i}unitc
    n=. n+1
    assert. 64 128 e.~ 3!:0 unitc  NB. must remain extended|rational
  end.
end.
n return.  NB. count of unitc entries reassigned
)

qtcode4i=: (3 : 0)"0
  NB. returns (valu;ralu;code) for index into UUC: (…4i) (y)
if. (y<0) or (y>:#UUC) do. 0;BADCODE return. end.
]valu=.    y{uvalu
]ralu=.    y{rvalu		NB. <<<<<<<<<< rational
]valc=.    y{uvalc
]ralc=.    y{rvalc		NB. <<<<<<<<<< rational
]vald=.    y{uvald	      NB. displacement for valu	NOT USED IN THIS VERB
]rald=.    y{rvald	      NB. displacement for ralu	NOT USED IN THIS VERB
]units_y=. y pick units  NB. nominal units of valu
]unitv_y=. y pick unitv  NB. units definition as per UUC
  NB. Recognise [/] and [*] and handle them
NB. if. unitv_y -: ,SL do. valu;TRIVIALCODE return. end.
if. unitv_y -: ,SL do. valu;ralu;TRIVIALCODE return. end.	NB. <<<<<<<<<< rational
NB. if. unitv_y -: ,ST do. 1;KILLERCODE return. end.
if. unitv_y -: ,ST do. 1;1r1;KILLERCODE return. end.	NB. <<<<<<<<<< rational
  NB. Recognise a basic unit and return its prime with "valc"==1
NB. if. Nmks > i=. mks i. <,units_y do. 1;i{Pmks return. end.
if. Nmks > i=. mks i. <,units_y do. 1;1r1;i{Pmks return. end.	NB. <<<<<<<<<< rational
code=. y{unitc
msg '(LF)+++ qtcode4i[(y)]: units_y=[(units_y)] unitv_y=[(unitv_y)] code=(crex code)'
  NB. …use of crex prints 4x instead of 4 (say)
  NB. if code is valid, assume y{uvalc is valid too
if. -. code e. UNSETCODE,BADCODE do.  NB. <<<<<<<<<<<<<<<<<<<<<< ????
  msg '--- qtcode4i: VALID1 code=(crex code) valu=(valu) valc=(valc) valu*valc=(val)'
  msg '--- qtcode4i: VALID1 code=(crex code) ralu=(ralu) ralc=(ralc) ralu*ralc=(ral)'	NB. <<<<<<<<<< rational
NB.   val;code return.
  (valu*valc);(ralu*ralc);code return.	NB. <<<<<<<<<< rational
end.
  NB. Else compute qty==(valc;code) from specd units: unitv_y
'valc ralc code'=. qtcode4anyunit unitv_y
msg '... qtcode4i: valc=(valc) ralc=(ralc) code=(crex code) from: qtcode4anyunit ''(unitv_y)'''
if. code e. UNSETCODE,BADCODE do.
  msg '--- qtcode4i: invalid-code=(crex code)'
  0;0r1;BADCODE
else.
  val=. valu*valc
  ral=. ralu*ralc	NB. <<<<<<<<<< rational
  msg '--- qtcode4i: VALID2 code=(crex code) valu=(valu) valc=(valc) ralu=(ralu) ralc=(ralc) valu*valc=(val) ralu*ralc=(ral)'
  val;ral;code
end.
)

qtcode4bareunit=: 3 : 0
  NB. lookup the qty (value;code) for BARE NAMED unit: y
  NB. may be basic or derived, BUT expect to find it in: units
i=. units i. <,y
msg '+++ qtcode4bareunit[(y)] id=(i) #uvalc=(#uvalc)'
if. (i<0) or (i >: #UUC) do. 0;0r1;BADCODE return. end.
valc=. i{uvalc
ralc=. i{rvalc	NB. <<<<<<<<<< rational
code=. i{unitc
msg '--- qtcode4bareunit[(y)] id=(i) valc=(valc) ralc=(ralc) code=(crex code)'
valc;ralc;code
)

qtcode4anyunit=: 3 : 0
  NB. RECALCULATES code for ANY entry (y) in (units)
  NB. …ignores existing code in unitc if product of codes
  NB. multiply the codes for each (powered)token
if. (,SL)-: ,y do. 1;1r1;TRIVIALCODE return. end.
if. (,ST)-: ,y do. 1;1r1;KILLERCODE return. end.
r=. v=. z=. 0$0x  NB. Initialize list-caches paralleling (utoks y)
for_t. utoks y do.
  'invert scale bareunit power'=. cnvCunit cunit=.>t
  scale=. scale ^ power  NB. IAC Wednesday 6 May 2020  10:59:09
  if. invert do. scale=. %scale end.  NB. IAC Monday 29 June 2020  23:35:31
  rscale=. rational scale
  rpower=. rational power
  'valu ralu code'=. qtcode4bareunit bareunit
sllog 'cunit invert scale bareunit power code valu ralu rscale rpower'
  if. invert do.
    z=. z , % (code^power)
    v=. v , scale % (valu^power)
    assert. notFloat r=. r , rscale % (ralu^rpower)	NB. <<<<< rational
  else.
    z=. z , code^power
    v=. v , scale * (valu^power)
    assert. notFloat r=. r , rscale * (ralu^rpower)	NB. <<<<< rational
  end.
end.
muv=. */v  NB. combine all the valu's
mur=. */r  NB. combine all the ralu's			NB. <<<<< rational
muz=. */z  NB. combine all the code's
msg '--- qtcode4anyunit: y=[(y)] v=[(v)] muv=(muv) mur=(mur); z=[(crex z)] muz=(muz)'
muv;mur;muz return.
)

cnvCunit=: 3 : 0
  NB. cut prefs/suffs from a cunit (eg: '/kg^3')
msg '+++ cnvCunit: y=(y)'
z=. dltb y  NB. (,'m') for y=='m' or y==' m'
k=. p=. 1   NB. to be overridden below
   NB. elim a NEGATIVE power in all forms
if. (SL~:{.z) and ((any PWM E. z) or (any PWU E. z)) do.
  z=. SL,z rplc PWM ; PW ; PWU ; PW  NB. replace by leading SL
end.
  NB. drop prefix: SP|SL from z -but remember it as (bool) j
if. j=.(SL={. sp1 z) do. z=. }.z end.
if. PW e. z do.  NB. recognise a power-suffix
  NB. drop power-suffix from z -but remember it as (int) p
  'p z'=. (".{:z) ; (}:}:z)
end.
msg '... cnvCunit: y=(y) z=(z) j=(j) p=(p)'
  NB. split-off scaling prefixes, eg 'ms' 'Gs' 'µ' (all variants of: s)
  NB. ONLY IF z is not itself in: units, eg 'knot' ...
if. (-.iskg z) and (-.listedUnits z) do.
  'k z'=. scale4bareunit z
end.
msg '--- cnvCunit: j=(j) k=(k) z=(z) p=(p)'
j ; k ; z ; p return.
)
  NB. Scaling prefixes recognised by scale4bareunit (below):
  NB.	------------------------------------------------------------------------------
  NB. 	deca- 	hecto- 	kilo- 	mega- 	giga- 	tera- 	peta- 	exa- 	zetta- 	yotta-
  NB. 	da 	h 	k 	M 	G 	T 	P 	E 	Z 	Y
  NB. 	10^1 	10^2 	10^3 	10^6 	10^9 	10^12 	10^15 	10^18 	10^21 	10^24
  NB.	------------------------------------------------------------------------------
  NB. 	deci- 	centi- 	milli- 	micro- 	nano- 	pico- 	femto- 	atto- 	zepto- 	yocto-
  NB. 	d 	c 	m 	µ 	n 	p 	f 	a 	z 	y
  NB. 	10^−1 	10^−2 	10^−3 	10^−6 	10^−9 	10^−12 	10^−15 	10^−18 	10^−21 	10^−24
  NB.	------------------------------------------------------------------------------

scale4bareunit=: 3 : 0
  NB. returns e.g. (1e9 ; 'Hz') for y=='GHz'
  NB. ALSO returns (1e3 ; ,'m') for y=='km'
  NB. ...AVOID CALLING WITH y if y is listed in (units) !!!
z=. ,y  NB. (,'m') for y=='m'
k=. 1   NB. to be overridden below
  NB. internal constants used below…
dalen=. #da=. 'da'  NB. deka-
mulen=. #mu=. 'µ'   NB. micro-
  NB. Refuse misbehaving units, e.g. 'G' 'm' 'µ' or 'm/…'
if. 1=#('/'taketo z) do. k;z return. end.
if. da-:('/'taketo z) do. k;z return. end.
if. mu-:('/'taketo z) do. k;z return. end.
  NB. Identify a multibyte ascii or unicoded scaling prefix...
if.     z beginsWith da do.	k=. 1e1  [ z=. dalen}.z
elseif. z beginsWith mu do.	k=. 1e_6 [ z=. mulen}.z
elseif. do.
  NB. Identify a SINGLE-CHAR ASCII scaling prefix (i.e. NOT µ)
  select. {.z
  case. 'h' do. k=. 1e2	[ z=.}.z	NB. hecto-
  case. 'k' do. k=. 1e3	[ z=.}.z	NB. kilo-
  case. 'M' do. k=. 1e6	[ z=.}.z	NB. mega-
  case. 'G' do. k=. 1e9	[ z=.}.z	NB. giga-
  case. 'T' do. k=. 1e12	[ z=.}.z	NB. tera-
  case. 'P' do. k=. 1e15	[ z=.}.z	NB. peta-
  case. 'E' do. k=. 1e18	[ z=.}.z	NB. exa-
  case. 'Z' do. k=. 1e21	[ z=.}.z	NB. zetta-
  case. 'Y' do. k=. 1e24	[ z=.}.z	NB. yotta-
  case. 'd' do. k=. 1e_1	[ z=.}.z	NB. deci-
  case. 'c' do. k=. 1e_2	[ z=.}.z	NB. centi-
  case. 'm' do. k=. 1e_3	[ z=.}.z	NB. milli-
  case. 'u' do. k=. 1e_6	[ z=.}.z	NB. micro- (µ handled separately)
  case. 'n' do. k=. 1e_9	[ z=.}.z	NB. nano-
  case. 'p' do. k=. 1e_12	[ z=.}.z	NB. pico-
  case. 'f' do. k=. 1e_15	[ z=.}.z	NB. femto-
  case. 'a' do. k=. 1e_18	[ z=.}.z	NB. atto-
  case. 'z' do. k=. 1e_21	[ z=.}.z	NB. zepto-
  case. 'y' do. k=. 1e_24	[ z=.}.z	NB. yocto-
  end.
end.
z=. deb z  NB. guarantee z has NO prefixed SP (or SL)
k ; z
)

compatible=: 4 : 0
  NB. =1 iff units x,y compatible
  NB. [*] [!] compatible with everything…
    if. ('*' ident x) or ('*' ident y) do. 1 return.
elseif. ('!' ident x) or ('!' ident y) do. 1 return.
end.
xcode=. >{: qtcode4anyunit bris x
ycode=. >{: qtcode4anyunit bris y
xcode -: ycode
)

compatlist=: 3 : 0
  NB. return extract of (units) compatible with units: y
]ycode=. >{: qtcode4anyunit y
(ycode=unitc) # units
)

convert=: 3 : 0"1
  NB. y (units) --> base-units ; displacement ; conversion-factor
yb=. bris y  NB. kosher of (units) y
disp=. displacement yb
rdisp=. rdisplacement yb  	NB. <<<<< rational
msg '+++ convert: ENTERED: y=(y) yb=(yb) disp=(disp) rdisp=(rdisp)'
'factor rfactor code'=. qtcode4anyunit yb
targ=. canon expandcode code
msg '--- convert: EXITS'
NB. wd'msgs'  NB. REMOVED: IAC Wednesday 6 May 2020  12:19:12
NB. targ ; disp ; factor return.
targ ; rdisp ; rfactor	NB. <<<<< rational
:
  NB. x,y (units)--> displacement ; factor
  NB. Add displacement then apply factor
'ytarg yrdisp yrfactor'=. z=.convert y
if. 0=#x do. z return. end.  NB. empty x - treat as monad
'xtarg xrdisp xrfactor'=. convert x
if. (xtarg-:ytarg) or (xtarg ident '*') or (ytarg ident '*') do.
  rfactor=. yrfactor % xrfactor
  rdisp=. (yrdisp-xrdisp)%yrfactor
  x ; rdisp ; rfactor	NB. <<<<< rational
elseif. do.
  msg '>>> convert: incompatible units: x=[(x)] y=[(y)]'
  x ; 0x ; 0x		NB. error values <<<<< rational
end.
)
0 :0
't d f'=: 'degC' convert_uu_ 'degF'  NB. °F-->°C
]float d,f
]float C=: f*(F+d)  [F=:212
]t
't d f'=: 'degF' convert_uu_ 'degC'  NB. °C-->°F
]float d,f
]float F=: f*(C+d)  [C=:100
)

scale_displace=: 4 : 0
  NB. FOR REFERENCE ONLY
'coeft coefu dispt dispu'=. z=: x,(4-~#x){.1 1 0 0
vaSI=. dispu + y*coefu
(vaSI-dispt)%coeft
)


uniformD=: 3 : 0
  NB. apply verb: uniform to UNITS ONLY in (qty) y
brack sval=: strValueOf y
brack unit=: uniform unitsOf y
]sval,SP,unit
)

cannotScale=: 3 : 'CANNOTSCALE e.~ <deb y'
  NB. (kosher unit) y cannot be scaled, e.g. [note]

onload 'qtcode4anyunit ''/mm^2'''