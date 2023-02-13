	NB. uu - uuverb.ijs
'==================== [uu] uuverb.ijs ===================='
0 :0
Wednesday 6 May 2020  11:10:46
)

cocurrent 'uu'

uu=: (''&$: :(4 : 0))"1
  NB. convert units: y (e.g. '212 degF') to target: x (e.g. '100 degC')
if. '*'={.y do. uuengine }.y return. end. NB. uuengine call-thru
if. isBoxed y do.
  'valu unit'=. y
  rvalu=. rat valu
elseif. isReal y do.  NB. no units specified
  valu=. y
  rvalu=. x: y	NB. <<<<< rational
  unit=. ,'/'	NB. "dimensionless" [/]
  unit=. ,'*'	NB. "wildcard" [*]
elseif. isStr y do.
  yf=. dltb formatIN y
  valu=. valueOf yf
  rvalu=. rvalueOf yf	NB. <<<<< rational
  unit=. unitsOf yf
elseif. do.  NB. cannot handle, treat as BAD*
  valu=.  BADFLOAT
  rvalu=. BADRAT
  unit=.  BADUNITS
end.
sllog 'uu x y valu rvalu unit'
  NB. compute target value: rvtarg
if. cannotScale unit do.  NB. formatOUT itself converts given value
  'targ rdisp rfactor'=. x convert unit
  rvtarg=. rvalu	NB. <<<<< rational
elseif. 0=#x do.  NB. (x) is empty | monadic invocation
  'targ rdisp rfactor'=. convert unit
  rvtarg=. (rfactor * rvalu) + rdisp  NB. rdisp always in BASE UNITS
elseif. do.  NB. target units are (x)
  'targ rdisp rfactor'=. x convert unit
  rvtarg=. rfactor * (rvalu + rdisp)
end.
  NB. cache the exact value, obtained from the rational calculations
UU_VALUE=: rvtarg	NB. <<<<< rational
z=. targ formatOUT rvtarg
sllog 'uu_3 z rvtarg VEXIN'
  NB. Flag: NO_UNITS_NEEDED is set by: formatOUT
if. NO_UNITS_NEEDED do. z else. deb z,SP,uniform targ end.
)

rvalueOf=: 3 : 0
  NB. extract the (RATIONAL) value of (qty-string) y
  NB. c/f eval, valueOf
try. val=. reval strValueOf y	NB. <<<<< rational
catch. BADRAT end.
)

valueOf=: 3 : 0
  NB. extract the (numeric) value of (qty-string) y
  NB. c/f eval
try. val=. ". strValueOf y
catch. _. end.
)

strValueOf=: 3 : 0
  NB. extract the (numeral-string) value of (qty-string) y
  NB. c/f eval
  NB. NEEDS TO HANDLE $ £ % ALSO????
SP taketo deb y rplc '°' ; SP ; 'deg' ; SP
)

unitsOf=: 3 : 0
  NB. extract the (utf-8) units of (qty-string) y
numeral=. strValueOf y
deb y }.~ #numeral
)

onload }: 0 :0
smoutput (x=:'m^2') uu (y=:'1 mm^2') [smclear''
)
0 :0  NB. spare lines for: onload
smoutput (x=:'degF') uu (y=:'100 degC') [smclear''
smoutput uu '212 degF'
smoutput (x=:'ft/s^2') uu y=:'1 Å h⁻²'
smoutput 'yd' uu 2r3 ; 'ft'
)