smoutput(jpathsep>(4!:4<'zx'){4!:3'');~zx=.'test uuengine'
cocurrent 'uu'
'SIC SIG SIZ'=: 0 3 __
Q=: 3 : 'q1234__=: y'
A=: 3 : 'assert. y-:q1234__ [qqq__=: y;q1234__'
	NB. uuengine test
Q uuengine 'CPAT kg>ton'	NB. are 2 units compatible?
A 1
Q uuengine 'CPAT °C>°F'	NB. are 2 units compatible?
A 1
Q 5{. uuengine 'CPLI s'	NB. list of compatible units
A ;:'s sec min h d'
Q uuengine 'CNVJ /km^3'	NB. cut a cunit, eg: '/km^3'
A 1;1000;(,'m');3
Q uuengine 'CONV degF'	NB. convert
A (,'K');63843r250;5r9
Q uuengine 'CONV degF>degC'	NB. convert
A 'degC' ; _80001r2500 ; 5r9
Q float uuengine 'DISP °C'	NB. displacement for units
A 273.15
 z=. '1 m/s^2	[ac.si]	unit acceleration; SI'
Q uuengine 'CONS',z	NB. cut "cons" formatted string (c/f UUC)
A 'unit acceleration; SI' ; 'ac.si' ; 1
 z=. '(v^2)/r : v(m/s),r(m) [m/s^2] centripetal acceleration'
Q uuengine 'FUNC',z	NB. cut "func" formatted string (c/f UUC)
A 'centripetal acceleration' ; 'm/s^2' ; '(v^2)/r : v(m/s),r(m)'
z=. '23:59:58'
Q uuengine 'FMTI',z	NB. format string-qty
A '86398 s'
Q uuengine 'FMTO 440 note'	NB. format qty: arg as output string
A 'A note'
uu '86398 s'
Q uuengine 'QRAT'	NB. query rational value saved by: uu
A 86398
Q uuengine 'QSCI'	NB. query scientific notation threshold
A SCI
Q uuengine 'QSIC'	NB. query SI-conformance level
A SIC
Q uuengine 'QSIG'	NB. query significant figures
A SIG
Q uuengine 'QSIZ'	NB. query zero attraction threshold
A SIZ
uuengine 'szer OVER'	NB. set Boolean ZERO word
Q uuengine 'QZER'	NB. query Boolean ZERO word
A 'OVER'
Q uuengine 'SCIN 2.34e_5'	NB. numarg--> (string numeral) scientific notation
A '2.34E-5'
Q uuengine 'SELF km/s km s'	NB. self-cancel units
A 'km^2'
Q uuengine 'UCOD 100 degC'	NB. convert special symbols --> "goy"
A '100 °C'
Q uuengine 'UCOS 100 Ohm'	NB. convert special symbols --> "goy" (not currency)
A '100 Ω'
Q uuengine 'UNUC 100 Ω' 	NB. un-convert "goy" special symbols --> "kosher"
A '100 Ohm'
Q uuengine 'UDIV km > h'	NB.[uarg utarg] divide two units symbolically
A 'km/h'
Q uuengine 'ssic 3'		NB. set SI-conformance level
Q uuengine 'UNIF 1 kg m/s²'	NB. convert special symbols wrto SI-compliance level
A '1·kg·m·s⁻²'
Q uuengine 'ssic 0'
Q uuengine 'UNIF 1 kg m/s²'
A '1 kg m/s^2'
Q uuengine 'UUUU 3.01 ft > yd'	NB. call LOCAL uu via a uuengine-instruction
A '1.003 yd'
Q uuengine 'UUUU' ; 10 ; 'ft'
A '3.048 m'
Q uuengine 'UUUU' ; 10 ; 'ft' ; 'yd'
A '3.333 yd'
Q $ uuengine 'VUUC spa'	NB. LF-separated contents of UUC
A ,46
Q $ uuengine 'VUUF spa'	NB. LF-separated contents of UUF
A ,93
Q $ uuengine 'VUUM spa'	NB. LF-separated contents of UUM
A ,0
Q $ uuengine 'WUUC spa'	NB. LF-separated contents of UUC
A ,46
Q $ uuengine 'WUUF spa'	NB. LF-separated contents of UUF
A ,93
Q $ uuengine 'WUUM spa'	NB. LF-separated contents of UUM
A ,0
Q uuengine 'QZER'	NB. query Boolean ZERO word
A ZERO
uuengine 'fcty'  	NB. restore factory settings
uuengine 'ssci 2'	NB. set scientific notation threshold
Q SCI
A 2
uuengine 'ssig 6'	NB. set significant figures
Q SIG
A 6
uuengine 'ssiz _8'	NB. set zero attraction threshold
Q SIZ
A _8
uuengine 'strt'  	NB. restart this instance of UU
Q SCI,SIC,SIZ
A 5 1 __