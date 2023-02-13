	NB. uu - uu_interface.ijs
'==================== [uuengine] uu_interface ===================='

0 :0
Friday 10 May 2019  16:11:59
-
(Pass-thru CAL instructions are identical to these.)
(string | boxed) y is a uuengine instruction.
…Lowercase instructions change the state of UU
…Uppercase instructions simply return requested info
 and DO NOT change the state of UU
)

cocurrent 'uu'

uuengine=: 3 : 0
  NB. The "keyhole" interface to UU.
if. isBoxed y do.
  'inst y1 y2 y3'=. 4{.y
  select. inst
  case. 'CONV' do. y2 convert y1
  case. 'FMTI' do. formatIN nb }.y
  case. 'FMTO' do. y2 formatOUT y1
  case. 'UDIV' do. y2 udiv y1
  case. 'UUUU' do. y3 uu 1 2{y
  case.        do. '>>> uuengine: bad instruction:';y
  end.
  return.
end.
  NB. Assume y-arg is string, (4{.y) is instr
yy=. dlb 4}.y=. dltb y
select. 4{.y
case. 'CPAT' do. NB. are 2 units compatible?
	('>'takeafter yy) compatible '>'taketo yy
case. 'CPLI' do. NB.[uarg] list of compatible units
	compatlist yy
case. 'CNVJ' do. NB.[uarg] cut a cunit, eg: '/km^3' --> 1;1000;(,'m');3
	cnvCunit yy
case. 'CONV' do. NB.[uarg] convert
	('>'takeafter yy) convert '>'taketo yy
case. 'CONS' do. NB.[arg] cut "cons" formatted string (c/f UUC)
	0&udat yy
case. 'DISP' do. NB.[uarg] displacement for units
	rdisplacement unucode yy	NB. <<<<<<<<<< rational
case. 'FUNC' do. NB.[arg] cut "func" formatted string (c/f UUC)
	1&udat yy
case. 'FMTI' do. NB.[arg] format string-qty
	formatIN yy
case. 'FMTO' do. NB.[arg] format qty: arg as output string
	(unitsOf yy) format valueOf yy
case. 'QRAT' do. NB.[] query rational value saved by: uu
	UU_VALUE
case. 'QSCI' do. NB.[] query scientific notation threshold
	SCI
case. 'QSIC' do. NB.[] query SI-conformance level
	SIC
case. 'QSIG' do. NB.[] query significant figures
	SIG
case. 'QSIZ' do. NB.[] query zero attraction threshold
	SIZ
case. 'QZER' do. NB.[] query Boolean ZERO word
	ZERO
case. 'SCIN' do. NB.[numarg] --> (string numeral) scientific notation
	scino ".sci2j yy
case. 'SELF' do. NB.[uarg] self-cancel units
	selfcanc yy
case. 'UCOD' do. NB.[arg] convert special symbols --> "goy"
	ucode yy
case. 'UCOS' do. NB.[arg] convert special symbols --> "goy" (not currency)
	ucods yy
case. 'UNUC' do. NB.[uarg] un-convert "goy" special symbols --> "kosher"
	0&uniform yy
case. 'UDIV' do. NB.[uarg utarg] divide two units symbolically
	('>'takeafter yy) udiv~ '>'taketo yy
case. 'UNIF' do. NB.[uarg] convert special symbols wrto SI-compliance level
	uniform yy
case. 'UUUU' do. NB.[arg targ] call LOCAL uu via a uuengine-instruction
	('>'takeafter yy) uu '>'taketo yy
case. 'VUUC' do. NB.[arg] LF-separated contents of UUC
	x2f 0 uurowsc yy
case. 'VUUF' do. NB.[arg] LF-separated contents of UUF
	x2f 0 uurowsf yy
case. 'VUUM' do. NB.[] LF-separated contents of UUM
	x2f UUM
case. 'WUUC' do. NB.[arg] LF-separated contents of UUC
	x2f 1 uurowsc yy
case. 'WUUF' do. NB.[arg] LF-separated contents of UUF
	x2f 1 uurowsf yy
case. 'WUUM' do. NB.[] LF-separated contents of UUM
	x2f UUM
case. 'fcty' do. NB.[] restore factory settings
	factory''
case. 'ssci' do. NB.[numarg] set scientific notation threshold
	SCI=: {.".yy
case. 'ssic' do. NB.[numarg] set SI-conformance level
	SIC=: {.".yy
case. 'ssig' do. NB.[numarg] set significant figures
	SIG=: {.".yy
case. 'ssiz' do. NB.[numarg] set zero attraction threshold
	SIZ=: {.". sci2j yy
case. 'strt' do. NB.[] restart this instance of UU
	start''
case. 'szer' do. NB.[arg] set Boolean ZERO word
	ZERO=: yy
case.        do. '>>> uuengine: bad instruction:';y
end.
NB. >>>>> NO CODE PAST THIS POINT: return values are waiting
)