	NB. uu - rational.ijs
'==================== [uu] rational ===================='

0 :0
Wednesday 6 May 2020  12:21:14
wd'beep'  NB. REMOVED: IAC Wednesday 6 May 2020  12:20:28
-
BADRAT - a bona-fide rational, but intended as signalling an error
)

cocurrent 'uu'

s4x=: 16&$: :(4 : 0)
  NB. make rational number in interval (1,10) out of integer|extended (y)
  NB. Cap #P at (x) digits
P=. ":y
if. x<#P do. P=. x{.P end.
".P,'r1',(<:#P)#'0'
)

rat_z_=: rational_z_=: x:!.0
float_z_=: _1&x:  		NB. rational-->	float|int|Bool
extended_z_=: x:!.0	NB. integer -->	extended
numDenom_z_=: 2&x:		NB. rational -->	(extended,extended)
rat4pair_z_=: (_2&x:)&x:	NB. (num,num)-->	rational

NB. isRational=: 3 : '64 128 e.~ 3!:0 y'
isRational=: 64 128 e.~ 3!:0  NB. also covers: isExtended
isExtended=: 64 = 3!:0
isFloating=: 8 = 3!:0
notFloat=: 8 ~: 3!:0

rat4sl=: 3 : 0 "1
  NB. rational for general expression containing '/'
msg '... rat4sl: y=[(y)]'
if. BADRAT = a=: reval '/'taketo y do. BADRAT
elseif. BADRAT = b=: reval '/'takeafter y do. BADRAT
elseif. do. rat a%b
end.
)

rat4pn=: 3 : 0 "1
  NB. rational for pronoun (=constant) (char)y, eg PI, PI2 …
msg '... rat4pn: y=[(y)]'
try.
  assert. 0= 4!:0 <y  NB. is (y) a pronoun?
  y~
catch.
  msg '>>> rat4pn: cannot handle y=''(y)'''
  BADRAT
end.
)

rat4pt=: 3 : 0 "1
  NB. rational for power-of-ten numeral (char)y of form: 10^…
msg '... rat4pt: y=[(y)]'
if. (y begins '10^_') or (y begins '10^-') do. ". NN=:'1r1',(".4}.y)#'0'
elseif. y begins '10^' do. ". NN=:'x' ,~ '1',(".3}.y)#'0'
elseif. do.
  msg '>>> rat4pt: cannot handle y=''(y)'''
  BADRAT  NB. a bona-fide rational, but representing an error
end.
)

rat4po=: 3 : 0 "1
  NB. rational for power numeral (char)y of form: a^b
msg '... rat4po: y=[(y)]'
if. BADRAT = a=. reval '^'taketo y do. BADRAT
elseif. BADRAT = b=. reval '^'takeafter y do. BADRAT
elseif. do. rat a^b
end.
)

rat4neg=: 3 : 0 "1
  NB. rational for negated general expression
msg '... rat4neg: y=[(y)]'
if. BADRAT = a=. reval }.y do. BADRAT
else. rat -a
end.
)

rat4bad=: 3 : 0 "1
  NB. adverse verb to report bad numeral
msg '>>> rat4bad: y=[(y)]'
BADRAT
)

rat4sc=: 3 : 0 "1
  NB. rational for scientific numeral (char)y
y=. y rplc 'E' ; 'e' ; '-' ; '_'
c=. 'e' taketo y
a=. ".c-.DT
b=. ".y
scale=. rnd 10^. a%b
msg '... rat4sc: y=[(y)] scale=(scale) c=(c) a=(a) b=(b)'
if. isRational b do. b
elseif. scale<0      do. ". ((c-.DT) , (|scale)#'0') , 'r1'
elseif.              do. ". (c-.DT) , 'r1' , scale#'0'
end.
)

rat_check=: 3 : 0 "0
  NB. verify integrity of rational caches
if. 0=#y do. rat_check i.6 return. end.
try.
select. y
case. 0 do. assert. all boo=. uvalu = float rvalu
case. 1 do. assert. all boo=. uvald = float rvald
case. 2 do. assert. all boo=. uvalc = float rvalc
case. 3 do. assert. all boo=. -. uvalu e. 0 _ __
case. 4 do. assert. all boo=. -. uvald e. _ __
case. 5 do. assert. all boo=. -. uvalc e. 0 _ __
end.
  NB. …means: all units have been resolved
catch.
  bads=. I. -.boo
  smoutput sw'>>> rat_check[(y)] failed at these UUC rows…'
  smoutput vt bads
NB.  wd'beep'  NB. REMOVED: IAC Wednesday 6 May 2020  12:20:28
end.
)

isNum=: 1 4 8 16 64 128 e.~ 3!:0

evalRC=: 4 : 0 "1
  NB. serves: eval
EVAL__=:''  NB. diagnostic flag
rc=. (9+2*x)&o.  NB. complex(x=1) or real(x=0) part of y
try.
  if. isNo z=.".y do. rc z	[EVAL__=: 'scalar num expression'
  else. BADFLOAT		[EVAL__=: 'evaluates -not scalar num'
  end.
catch. BADFLOAT		[EVAL__=: 'fails to evaluate'
end.
)

eval=: (3 : 0)"1
  NB. returns SCALAR num having datatype 'floating'
  NB. evaluates "numerals" (numeric phrases) in UUC without crashing
  NB. c/f valueOf, strValueOf
  NB. x==0 - return real part if complex
  NB. x==1 - return imag part if complex
0 eval y
:
EVAL__=:''  NB. diagnostic flag
if. 0=#y do. BADFLOAT		[EVAL__=: 'empty'
elseif. _1=4!:0<y do. BADFLOAT	[EVAL__=: 'unassigned id'
elseif. 0=4!:0<y do. x evalRC y
elseif. do.
  x evalRC '/%-_Ee'charsub ,>y
end.
)

ieval=: 1&eval

ireval=: 3 : 0 "1
  NB. variant of: eval - returns 'rational' --IMAGINARY PART
  NB. used by make_units to evaluate numeric exprns in: UUC
y=. deb >y
if. 'j' e. y do. rat4sc 'j' takeafter y  NB. IMAGINARY PART ONLY !!!
else. 0x
end.
)

reval=: 3 : 0 "1
  NB. returns SCALAR num having datatype 'rational' or 'extended'
  NB. "rational" replacement for: eval
  NB. used by make_units to evaluate numeric exprns in: UUC
  NB. recommended whenever working with user-entered numerals
msg '+++ reval: y=(y)'
doo=. ". :: rat4bad
if. 0=#y=. deb >y do. BADRAT [msg '>>> reval: empty y'
elseif. y-: ,'_' do. _r1
elseif. y-: '__' do. __r1
elseif. ('-'={.y) or ('_'={.y) do. rat4neg y
elseif. all y e. n9 do. doo y,'x'
elseif. (all (}:y) e. n9) and ('x'={:y) do. doo y
elseif. all y e. n9,'r' do. doo y
elseif. all y e. n9,'/' do. doo '/r'charsub y
elseif. '/' e. y do. rat4sl y
elseif. _1=4!:0<y do. BADRAT [msg '>>> reval: empty y'
elseif. 'j' e. y do. rat4sc :: rat4bad 'j' taketo y  NB. REAL PART ONLY !!!
elseif. all y e. n9,'._' do. rat4sc :: rat4bad y
elseif. 'e' e. y do. rat4sc :: rat4bad y
elseif. 'E' e. y do. rat4sc :: rat4bad y
elseif. y begins '10^' do. rat4pt ::rat4po y
elseif. '^' e. y do. rat4po y
elseif. 0=nc <y  do. rat4pn y
elseif.          do. rat eval y  NB. fall back on original: eval
end.
)

onload 'load temp 101'