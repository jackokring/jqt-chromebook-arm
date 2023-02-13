	NB. uu - main.ijs
'==================== [uu] main ===================='

cocurrent 'uu'

bris=: unucode@unslash1@undotted@deb"1  NB. c(y)--> "kosher"

canon=: 3 : 0
	NB. Sort units (str y) into canonical order
	NB. y must be fully-resolved units, ie all from boxed list: mks
	NB. Sort tokens EACH REVERSED. This brings num+denom terms together
z=. ; |. each sort |. each utoks y
	msg '... canon: z=(z)'
	NB. Cancel-out/collect each unit from global boxed list: mks in turn...
for_w. mks do. m=. ,>w		NB. m== next unit from list: mks
  if. any m E. z do.		NB. only if m is present in z
    z=. (z canc m) coll m
	msg '... canon: [(m)] z=(z)'
  end.
end.
z=. debnSL dlb ; sort utoks z	NB. k-m-s order, with denominators gathered behind
if. 0=#z do. z=. ,SL end.  	NB. CONVENTION: (empty z) --> ,'/'
msg '--- canon: EXITS: z=(z)'
z return.
)

cnvi=: 1&$: : (4 : 0)
	NB. x=1 - invert SP <--> SL thru token-list (y)
if. -.x do. y return. end.
zz=. ''
for_i. i.#y do. z=. >i{y	NB. the i'th cunit of list: y
  if.     SL={.z do. zz=. zz,< SP,}.z
  elseif. SP={.z do. zz=. zz,< SL,}.z
  end.
end.
zz return.
)

curfig=: 3 : 'hy (0 j. 2)":y'
debSL=: #~ (+. (1: |. (> </\)))@('/'&~:)

debnSL=: 3 : 0
	NB. remove SL repetitions preserving (any) leading SL
	NB. serves: canon
if. SL={.y do. SL,debSL }.y
else. debSL y
end.
)

deslash=: 1&$: : (4 : 0)
  NB. deslash
  NB. x=1 --converts cunits with '/' into '^_n' form
  NB. x=0 --converts '^_n' cunits back into '/'
r=. ''	NB. accumulates modified cunits
for_cu. utoks y do. cunit=. >cu
  if. (x=0) or SL={.cunit do.  NB. inverse: do BOTH SP SL
    'j k z p'=. cnvCunit cunit
    if. x do.
      cunit=. SP, (}. PW taketo cunit),PWM,":p
    else.
      sllog 'deslash__ cunit j k z p'
      cunit=. (j{SP,SL), (}. PW taketo cunit) ,(p>1)# PW,":p
    end.
  end.
  r=. r,cunit
end.
dlb r return.
)

displacement=: (3 : 'uvald {~ units i. <,y') :: 0:
rdisplacement=: (3 : 'rvald {~ units i. <,y') :: 0:  NB. is 0: okay to use??

dotted=: 1&$: : (4 : 0)
  NB. apply(x=1--default)/unapply(x=0) dotted (·) convention
  NB. cf: slash1
]z=. utf8 deb y
if. x do.  NB. apply convention
  if. any HD E. z do. y return. end.  NB. convention already applied
  ]z=. z rplc SP;HD
else.  NB. unapply convention
  if. -.any HD E. z do. y return. end.  NB. convention not applied
  z=. z rplc HD;SP
end.
)

exrate=: exrate_exch_

hy=: '_-' charsub ]
isNaN=: 128!:5

iskg=: 3 : 0
  NB. (iskg'') =1 iff units y is 'kg' or begins with: 'kg'
  NB.  and is scalable by altering the prefix: 'k'
if. y-:'kg' do. 1 return. end.
if. not 'kg' -: 2{.y do. 0 return. end.
	NB. Further test(s) if z starts with: 'kg'
if. any 'kg^' E. y do. 0 return. end.	NB. cannot accept powers of [kg]
1	NB. return true with no more tests
)

midi4Hz=: midino=: 69 + 12 * 2 ^. 440 %~ ]  NB. "midi number" of freq: y (Hz)
Hz4midi=: midino inv

nnote4Hz=: nnote=: 3 : 'rnd 12 | midino y'  NB. nearest musical note-number of freq: y (Hz)

note4Hz=: note=: 3 : 0
  NB. nearest musical note of freq: y (Hz)
NOTE=. cut 'C C# D D# E F F# G G# A A# B C'
NB. ,>NOTE {~ rnd (12 | midino y)
,>NOTE {~ nnote y
)

Hz4note=: note4Hz inv

0 :0
Hz4note=: 3 : 0
  NB. freq [Hz] for given musical note
  NB. UNFINISHED <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
NOTE=. <;._1 ' C C# D D# E F F# G G# A A# B C'
130.81  NB. [Hz] for C3	-- TEST ONLY. (WHOLE TABLE NEEDED!]
)

qty4str=: 3 : 0
  NB. return qty represented by (string) y
  NB. >>> CONSIDER implementing this like: make_units
val=. eval strValueOf y
uni=. dltb SP takeafter y
val ; uni
)

rnd=: [: <. 0.5 + ]

trim0=: 3 : 0
  NB. trim zeros from scientific numeral
if. 'E' e. y do.
  'n m'=. 'E'cut y
  z=. (trim0 n),'E',m 
  z return.
end.
z=. deb y
if. (1=+/DT=z) and (DT~: {: }:z) and all z e. n9,DT do. z=. dt0 z end.
if. DT={:z do. z=. z,'0' end.
z return.
)

scino=: (3 : 0)"0
  NB. Scientific notation for number: y
  NB. but returns ordinary integer for integer (y)
  NB. Uses current values of SCI, SIG, SIZ (they can change)
  NB. test: tempuu 108 <<<<<<<<<<<<<<<
y=. float y
if. y=0 do. z=. ,'0'
elseif. (10^SIZ)>|y do. z=. '0',~ '- +'{~ 1+*y
elseif. any (10^SCI)<: y,%y do. z=. sci4j y":~ 0 j. -SIG  NB. force sci
elseif. y=<.y do. z=. sci4j ":y
elseif. do.  NB. sci ntn OR decimals
  z=. sci4j y":~ 0 j. SIG
  if. *./ z e. '-0.' do. z=. sci4j y":~ 0 j. -SIG end.
end.
  NB. henceforth assume valid z, but needs zeros trimming
trim0 z return.
)

slash1=: 1&$: : (4 : 0)
  NB. apply(x=1--default)/unapply(x=0) single-slash convention
  NB. cf: dotted
z=. deb y
if. x do.  NB. apply convention
NB.   if. SIC>:2 do. y return. end.  NB. convention n/a
  if. ')'={:z do. y return. end.  NB. convention already applied
  z=. canon z
  a=. '/' taketo z
  b=. '/' dropto z  NB. all sub-units should be slashed
  z=. deb b rplc SL;SP  NB. crudely invert b
  if. SP e. z do.
    z=. a,'/',paren z
  else.
    z=. a,'/',z
  end.
else.  NB. unapply convention
  if. ')'~:{:z do. y return. end.  NB. convention not applied
  a=. '(' taketo z
  b=. }: '(' takeafter z
  z=. a, b rplc SP;SL
end.
)

sp1=: 3 : 0
	NB. ensure ONE leading SP iff there is no SL
y=. deb y
if. SL~:{.y do. y=. SP,y end.
)

ssmx=: 4 : 'if. UCASE do. x ssmxU y else. x ssmxM y end.'
ssmxM=: 4 : 'I. * +/"(1) y ss"1 x'
ssmxU=: 4 : '(toupper x)ssmxM toupper y'

hasutf=: [: +./ 127 < a. i. ]  NB. y has utf8 chars (not pure ASCII)
isascii=: [: *./ 128 > a. i. ]  NB. y is pure ASCII (no utf8s)
NB. isascii 'm² K⁻¹ s⁻²'
NB. isascii 'able'

undeslash=: 0&deslash

ucode=: 1&$: :(4 : 0)
  NB. Substitutes (for) correct utf-8 symbols in (string) y
  NB. x==1 NOT-unicoded --> unicoded
  NB. x==0     unicoded --> NOT-unicoded
y=. utf8 y  NB. This algo needs y to be bytes not wchars
if. x do.  NB. subst 'π' for 'PI' etc
  if. -.isascii y do. y return. end.  NB. already converted
  ]z=. y rplc ,cspel,.csymb
  NB. Change only the scaling prefix, 'u' ...
  if. 'u'={.z do. z=. 'µ',}.z end.
else.      NB. subst 'PI' for 'π' etc
  if. isascii y do. y return. end.  NB. no utf codes to convert
  NB. convert unicode back to utf-8 before rplc...
  ]z=. y rplc HD;SP
  ]z=. undeslash z rplc ,csymb,.cspel
  NB. Change only the scaling prefix, 'µ' ...
  if. z begins ,'µ' do. z=. 'u',2}.z end.
end.
)

ucods=: 1&$: : (4 : 0)
  NB. saddle to call ucode, but ignoring currency symbols
SAV=. cspel ;< csymb
'cspel csymb'=: sspel ;< ssymb
z=. x ucode y
z [ 'cspel csymb'=: SAV
)

udat=: (4 : 0)"1
  NB. cut (UUC/F-type) string into boxed fields
  NB. x==0 -- to create a constant line
  NB. x==1 -- to create a formula line
'y zdesc'=. 2{. ']'cut y
zdesc=. dltb zdesc -.TAB
'y znits'=. 2{. '['cut y
select. x
case. 1 do.		NB. return boxed data for a formula
  zfmla=. deb y-.TAB
  zdesc; znits; zfmla
case. 0 do.		NB. return boxed data for a const item
  zdesc; znits; 1
case. _1 do.		NB. return all boxed data (if ever reqd)
  zvalu=. (i=. y i. SP){.y=. deb y-.TAB
  znitv=. }.i}.y
  zdesc; znits; znitv; zvalu
end.
)

make_units=: 0&$: :(4 : 0)
  NB. makes globals: cspel csymb units unitv uvalu uvald
  NB. x=0: DONT adjust currency
  NB. (cspel csymb) -used by: ucode to convert units: unicode<-->ascii
  NB. (sspel ssymb_ -used by: ucods (ditto, omits currency symbols)
sspel=: <;._1 ' PI Ang Ohm ^-1 ^-2 ^-3 ^-4 ^2 ^3 ^4'
ssymb=: <;._1 '|π|Å|Ω|⁻¹|⁻²|⁻³|⁻⁴|²|³|⁴'
  NB. cspel,csymb converts these also...
NB.     cspel=: sspel, <;._1 ' deg amin asec eur cnt gbp'
NB.     csymb=: ssymb, <;._1 '|°|′|″|€|¢|£'
cspel=: sspel, <;._1 ' deg amin asec'
csymb=: ssymb, <;._1 '|°|′|″'
'v uv us'=: <"1 |: cutuuc UUC
openv=: >v
unitv=: deb each uv -.each TAB  NB. defined units
units=: deb each us    NB. nominal units
uvald=: ieval openv   NB. defined value: displacement
assert. notFloat rvald=: ireval openv  NB. defined value: rdisplacement <<<<< rational
uvalu=: eval openv   NB. defined value: factor
assert. notFloat rvalu=: reval openv  NB. defined value: factor <<<<< rational
i.0 0
)

uniform=: ''&$: :(4 : 0)
  NB. enforces SI-conformance on unit: y
  NB. optional x (default: '') is SI-conformance level (0 to 3)
  NB. x=='' - uses value of state-variable: SIC
if. 0=#x do. sic=. SIC else. sic=. x end.
msg '+++ uniform: ENTERED: x=(x) sic=(sic)  y=(y)'
  NB. reformat units (y) for SI-conformance level (sic)
y=. utf8 deb y  NB. convert (y) from possible datatype=='unicode'
select. sic
case. 0 do.  NB. ASCII only ("kosher")
NB.   z=. unucode undotted y
  z=. bris y
case. 1 do.  NB. Permitted SI units with slashes
  z=. undotted y
  NB. If more than 1 slash, convert to parenthesised denominator
  if. 1< +/SL=y do. z=. slash1 z end.
  z=. ucode z
fcase.2 do.  NB. Recommended SI units
case. 3 do.  NB. Recommended SI units with dots
  if. SL ident y do.  NB. …no bare SL permitted in SI units
    msg '--- uniform: y=(crex y) returns NIL'
    NIL return.
  end.
NB.   ]z=. unucode undotted y	NB. "kosher" as safe intermediate
  ]z=. bris y	NB. "kosher" as safe preliminary
  ]z=. ucode deslash unslash1 z
  if. sic=3 do. z=. dotted z end.
end.
z return.
)

undeg=: 3600 %~ _ 60 60 #. 3 {. ]
undotted=: 0&dotted
unslash1=: 0&slash1
unucode=: 0&ucode
uurowsc=: 4 : '(UUC ssmx y){UUC [UCASE=: x'
uurowsf=: 4 : '(UUF ssmx y){UUF [UCASE=: x'
listedUnits=: 3 : 'units e.~ <,y'

state=: 3 : 0
  NB. query and set the UU state variables
sv=. b4o 'SIC SCI SIG SIZ'
if. 0=#y do.
  ".}:;sv,.<';'
else.  NB. set the sv's
  sv=. (#y){.sv
  (sv{.~#y)=: y
end.
)

NB. =========== trace ========================
trace=: 3 : 0
  NB. enable/disable tracing verbs: msg, sllog
  NB. y== boolean
  NB. copied from: [cal] dashboard.ijs
if. y do.
  msg=: smoutput&sw
  sllog=: smoutput&llog
else.
  msg=: empty
  sllog=: empty
end.
NB. smoutput '+++ trace ',":y
i.0 0
)

NB. ========== udiv fix OVERRIDES ============
NB. From: tempuu 106
NB. Remove duplicated words above

canc=: 4 : 0
  NB. [from temp 106] - cancels-out adjacent ' xx' and '/xx' terms
  NB. ASSUMES: sorted: ' xx' series precedes '/xx' series
  NB. ASSUMES: all powered terms have been dissolved by: diss
  NB. serves: canon selfcanc  e.g.
  NB. 'm kg kg/kg/kg s/s' canc 'kg' --> ' m s/s'
msg '+++ canc: x=[(x)] y=[(y)]'
z=. SP ,~ sp1 x	NB. the object string
n=. SP,y		NB. unit: y in numerator
d=. SL,y		NB. unit: y in denominator
whilst. -. w-:z do.
  w=. z
  NB. remove e.g. ' xx/xx' ONLY if followed by ' ' or '/'
  z=. z rplc (n,d,SP);SP ; (n,d,SL);SL
  msg '... canc:   z=[(z)] n=[(n)] d=[(d)]'
end.
dtb z return.
)

coll=: 4 : 0
  NB. collects [y]-terms (no cancel-out)
  NB. serves: canon selfcanc  e.g.
  NB. ' m kg kg/kg/kg s/s' coll 'kg' --> 'm kg^2/kg^2 s/s'
  NB. WARNING: cannot handle powered terms in (x) correctly !!!
msg '+++ coll: x=[(x)] y=[(y)]'
z=. ,x		NB. the object string
n=. SP,y		NB. unit: y in numerator
d=. SL,y		NB. unit: y in denominator
for_p. 4 3 2 do.	NB. 4th-power units are highest recognised
  z=. z rplc ((p*$n)$n);(n,PW,":p) ; ((p*$d)$d);(d,PW,":p)
  msg '... coll:     n=[(n)] d=[(d)] p=(p) --> z=[(z)]'
end.
z return.
)

diss=: 3 : 0
  NB. Dissolve powered tokens in boxed list (y) into >1 toks of power 1
  NB. WARNING: can't handle tok of form: ' s^_1'
for_cboxed. y [z=.'' do. c=. >cboxed
  p=. 1 >. {. ". PW takeafter c
  z=. z, p# <PW taketo c
end.
z return.
)

selfcanc=: 3 : 0
  NB. Self-cancel unitstr (y) without reducing to base units
  NB. Sort tokens EACH REVERSED -collects ' xx' and '/xx' terms
  NB. (Without reversal, '/xx' terms would collect as a block)
z=. ; |.each sort |.each ut=. diss utoks bris y
msg '+++ selfcanc: y=(y) --> z=[(z)]'
  NB. enum distinct (signless) cunits (c)
for_cboxed. ~. }.each ut do. c=. >cboxed
  z=. z canc c
  z=. z coll c
  msg '... selfcanc: c=[(c)] --> z=[(z)]'
end.
z=. selfcancFix dlb canon z
msg '--- selfcanc: RETURNS: z=(z)'
z return.
)

selfcancFix=: 3 : 0
  NB. remove corrupt terms known to arise, viz. lacking unit
y rplc '/^0';'/';'/^1';'/';'/^2';'/';'/^3';'/';'/^4';'/';'/^5';'/';'/^6';'/';'/^7';'/';'/^8';'/';'/^9';'/'
)

NB. selfcancFix=: ]  NB. UNcomment to force: '?/?' with y-:''

udiv=: 4 : 0
  NB. divides 2 generalized units-strs: x y
  NB. For use by: combine and: fnline in: cal
x=. bris x  NB. code below needs KOSHER x
y=. bris y  NB. code below needs KOSHER y
NB. smoutput sw '+++ udiv: ENTERED x=[(x)] y=[(y)]'
if. y ident SL do. uniform x return. end.
if. 0 = #y     do. uniform x return. end.  NB. comment out to force: '?/?' with y-:''
  NB. invert y-toks and concatenate
z=. selfcanc ; (utoks x) , (cnvi utoks y)
if. udivCodesOk x;y;z do. uniform z
else. ERROR_UDIV
end.
)

udivCodesOk=: 3 : 0
  NB. check units pp-codes agree
'x y z'=. y
codex=. 2 pick qtcode4anyunit x
codey=. 2 pick qtcode4anyunit y
codez=. 2 pick qtcode4anyunit z
if. codez = codexy=.codex%codey do. 1  NB. yes - pp-codes agree
else. 0 [ smoutput llog 'BAD codez z codex x codey y codexy'
end.
)

NB. udivCodesOk=: 1:  NB. if you want to risk it !!!

onload 'smoutput (,.z) ; scino z=.0 1 1.0 1.23 1.230 123 12300 123000000 123.0 123.000'