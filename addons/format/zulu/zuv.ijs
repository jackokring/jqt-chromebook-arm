NB. zuv.ijs, for zulu.ijs written by Ian Clark
NB. Sat 08 Sep 2012 02:00:00
NB. All interconversions of form: *2* (uncorrected).
NB. For corrected verbs load: zuvco.ijs on top of this script.
NB. Fix (f.) is used to allow ancillary verbs to be erased.

ZUV_z_=: 0

cocurrent 'z'	NB. BASIC VERBS ARE ALWAYS LOADED INTO _z_ LOCALE !!

	NB. Transient consts for use in tacit defs
	NB. these go away once the script is loaded
	NB. although counterparts may already exist

'SP LF'=. 32 10{a.

	NB. The *2* conversion verbs
b2b=:	]
b2o=:	}.@((<SP) ;@,. ])
b2f=:	}.@((<LF) ;@,. ])
b2x=:	>

o2b=:	[: <;._1 SP , ]
o2o=:	]
o2f=:	3 : 'LF(I. y=SP)}y'
o2x=:	b2x@o2b f.	NB. (f.) makes it faster

f2b=:	[: <;._1 LF , ]
f2o=:	3 : 'SP(I. y=LF)}y'
f2f=:	]
f2x=:	b2x@f2b f.

x2b=:	[: (#~ ([: +./\. SP&~:))&.> <"1
x2o=:	b2o@x2b f.
x2f=:	b2f@x2b f.
x2x=:	]

	NB. Apply the [no]-final-LF convention
t0f=:	}:^:({: = LF"_)		NB. terminates with NO LF
t1f=:	(,&LF)^:({: ~: LF"_)	NB. terminates with an LF

ZUV_z_=: 1
