	NB. cal - inversion_CONTROLLER.ijs
'==================== [cal] inversion_CONTROLLER.ijs ===================='
NB. TABULA inversion controller via daisychain technique
0 :0
Tuesday 27 August 2019  15:11:26
-
INVERSION TEST: use SAMPLE4
-
Verb: inversion -resides in _cal_ and calls in-turn into inver* locales.
-
key verb: inversion itself is called by: beval ("backward-evaluation")
-
breakback''	shows a diagram of the basic inversion algorithm
	breakback_cal_ -defined in utilities.ijs
-
INVERSION HEURISTICS
inversionA=: beginstop ::inversion_inverNRUC_ ::endstop  NB. TAY expt
inversionB=: beginstop ::inversion_inverTAY_ ::endstop  NB. TAY expt
	NB. use temp 41 to switch inversion between inversionA/B
-
inverCser=: inversion_inverC0_ ::inversion_inverC1_ ::inversion_inverC2_ ::inversion_inverC3_ ::inversion_inverC4_ ::inversion_inverC5_ ::inversion_inverC6_ ::inversion_inverC7_ ::inversion_inverC8_ ::inversion_inverC9_
inverNRser=: inversion_inverNRFC_ ::inversion_inverNRUC_
inverNRRser=: inversion_inverNRFCR_ ::inversion_inverNRUC_
-
inversion0=: beginstop ::inverCser ::endstop    NB. debug inverCser
inversion1=: beginstop ::inverNRser ::endstop   NB. debug inverNRser
inversion2=: beginstop ::inverNRRser ::endstop  NB. debug N-R
inversion3=: beginstop ::inverCser ::inverNRser ::endstop  NB. operational use

inversion3=: beginstop ::inversion_inverC0_ ::inversion_inverC1_ ::inversion_inverC2_ ::inversion_inverC3_ ::inversion_inverC4_ ::inversion_inverC5_ ::inversion_inverC6_ ::inversion_inverC7_ ::inversion_inverC8_ ::inversion_inverC9_ ::inversion_inverNRFC_ ::inversion_inverNRUC_ ::endstop  NB. operational use
-
NOTATION:
  ! -- must not change for duration of (inversion-)invocation
  ] -- computed from other workvars
  ? -- notional -- need not be created here
  argLEFT(x), argRIGHT(y) -- args of invocation: argLEFT inversion argRIGHT
	argLEFT  is typically: X0
	argRIGHT is typically: dY0
====
?X		notional abscissa in the abstract algorithm
?Y		notional ordinate in the abstract algorithm
!X0		==argLEFT; X initial value, from invocation
?Y0		Y initial value = fwdX0=: fwd(X0)
]X1		X final value returned by: inversion
?Y1		Y final value = fwdX1=: fwd(X1)
!dY		(non-iterative) INCREMENT of manual alt'n to Y
!dY0		==argRIGHT; the INCREMENT of manual alt'n to Y
		--(NOT the overtyped Y itself, == Y0D !!!)
!Y0D		==Y0+argRIGHT ==Y0+dY0
		--(sometimes counfounded with Y1)
]dX		limit of d1X, d2X, ???, d_X, ???, dX (as retd by: g)
		--the change to be made to X0 to bring it to X1
]d_X		iterated estimate of ??X (d_X--> dX as n--> _)
]d1X		1st value of d_X, starts at 1 (nudged)
?d2X		2nd value of d_X, ???etc
-
Verb: endstop -simply returns x-arg unchanged
(Does it have to generate the error message itself?
 Or return a value of X which won't yield the delta: y ?)
---NO, it seems. Just return an unchanged X.
--the result is the "resists value" message.
-
TO DO: Walkthru how cal responds to endstop,
 recognising/signalling failure.
)

cocurrent 'cal'

NB. NOW DEFINED IN: handy4uu???
atrain=: adverb define
  NB. LF-separated list --> train using Adverse (::)
  NB. needs to be defined before first use
13 : ('(', ')y',~ (}:u) rplc LF ; ' ::')
)

inversion0=: (0 : 0) atrain  NB. debug inverC* train
beginstop
inversion_inverC0_
inversion_inverC1_
inversion_inverC2_
inversion_inverC3_
inversion_inverC4_
inversion_inverC5_
inversion_inverC6_
inversion_inverC7_
inversion_inverC8_
inversion_inverC9_
endstop
)

inversion1=: (0 : 0) atrain  NB. debug inverNR* train
beginstop
inversion_inverNRFC_
inversion_inverNRUC_
endstop
)

inversion2=: (0 : 0) atrain  NB. debug N-R
beginstop
inversion_inverNRFCR_
inversion_inverNRUC_
endstop
)

inversion3=: (0 : 0) atrain  NB. best heuristics so far
beginstop
inversion_inverC0_
inversion_inverC1_
inversion_inverC2_
inversion_inverC3_
inversion_inverC4_
inversion_inverC5_
inversion_inverC6_
inversion_inverC7_
inversion_inverC8_
inversion_inverC9_
inversion_inverNRFC_
inversion_inverNRUC_
endstop
)

inversion=: inversion3  NB. placeholder phrase, overridden by: start.ijs

beginstop=: 4 : 0
  NB. ALWAYS the first verb in the daisychain
ssw LF,'+++++ beginstop[(date$0)]: entered via:'
ssw '  (x) inversion_cal_ (y)'
assert. 0  NB. kick-off the daisychain with "bland" error
)

endstop=: 4 : 0
  NB. ALWAYS the final verb in the daisychain
qAssertionFailure''
ssw LF,'+++++ endstop[(date$0)]: entered via:'
ssw '  (x) inversion_cal_ (y)'
register 'endstop'  NB. assumes successful completion
  NB. Returning the (x) arg unchanged (i.e. X1=X0)
  NB. forces the caller (typically: beval) to reject
  NB.  the value offered for backfitting by the user.
x return.
)

qAssertionFailure=: 3 : 0
  NB. report if last error WAS NOT assertion failure (errno 12)
if. 12= errno=. 13!:11'' do. i.0 0 return. end.
if. 3= errno=. 13!:11'' do. i.0 0 return. end. NB. discount window_close too
smoutput sw '+++ qAssertionFailure: errno=(errno) WAS NOT assertion failure!'
smoutput '============================'
smoutput 13!:12''
smoutput '============================'
)

register=: 3 : 0
  NB. needs importing into locale using (f.)
z [INVERSION_cal_=: INVERSION_cal_ , <z=. y
)

inversionC=: 4 : 0
qAssertionFailure_cal_'' [me=. 'inversion_',(>coname''),'_'
smoutputINV '+++++ ',me,' entered'
  NB. === CURVE-FITTING INVERTER SADDLE for inverC* ===
  NB. COPIES MADE in locales: 'inverC*' (* = 1..9)
  NB. needs special case of verb: fit
  NB. in order to generate: bwd: Y0D --> X1
  NB. >>> WARNING: A COPY (???f.) executes in the caller's locale! <<<
ssw=: sswInversion_cal_ f.
argLEFT=. x [argRIGHT=. y
erase 'X Y X0 Y0 X1 Y1 dY dY0 Y0D dX d_X d1X d2X'
fwd=: fwd_cal_
amodel=: amodel_cal_
register=. register_cal_ f.
ssw LF,'+++ (me): argLEFT=(argLEFT) argRIGHT=(argRIGHT) amodel=(amodel)'
  NB.>>> NOW USE ONLY the workvars erased above???
X0=: argLEFT
Y0=: fwd(X0)	NB. cached: does not change.
dY0=: argRIGHT
Y0D=: Y0+dY0
fit''  NB. -->makes verb: bwd (fitted-coefficients backward mapping)
X1=: bwd Y0D
ssw'... (me): Y0D=(Y0D) ~= fwdX1=(fwd X1) ??'
assert. Y0D approximates_cal_ fwd X1
ssw'--- (me): ???yes, close enough. [???Exits]'
register me
smoutputINV '----- ',me,' returns X1'
X1 return.
)

markfirst=: i. = [: i. [: # [
marklast=:  i: = [: i. [: # [
fixup_amodel=: 3 : 'amodel=: amodel markfirst 1'  NB. hold all except for one

NB. ========================================================
NB. (tolerant) implements "official" J defn of tolerant equality
NB. But I prefer to use (approximates) with N-R
NB. -because I want the "slack" (??TOLERANCE) to be the
NB.  same in the neighbourhood of 0 as in the neighbourhood of 1
NB.  whereas (tolerant) has less and less slack as Y0D --> 0
NB. HOWEVER I want (approximates) to stay slacker than J itself
NB. -hence the overriding condition: '(x=y) or ???'

tolerant=: 4 : '(|x-y) <: TOLERANCE * (>./|x,y)'
NB. approximates=: 4 : 'TOLERANCE >: |x-y'
approximates=: 4 : '(x=y) or (TOLERANCE >: |x-y)'
