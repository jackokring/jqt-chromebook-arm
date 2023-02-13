NB. zu.ijs, for zulu.ijs written by Ian Clark
NB. Sun 09 Sep 2012 17:50:00
NB. TESTING all interconversions of form: *2*

ZU_z_=: 0

cocurrent 'zulu'	NB. FOR: SANDBOX ...

	NB. TRIVIAL (0 and 1-entry) SAMPLE LISTS IN ALL FORMATS...
	NB. c/f zun.ijs
	NB. For instant clarity, no samples are derived from other samples.
	NB. NAMING CONVENTION:
	NB. Suffix the stub (in this case: 'z1' or 'z0') with the letter:
	NB.  b=boxed, o=open, f=LF-separated, x=2D-mx

	NB. test-data singlet lists (stub: 'z1')
zu=: 'alpha'
z1b=: ,<'alpha'
z1o=: zu
z1f=: zu
z1x=: ,:zu

	NB. test-data empty lists (stub: 'z0')
z0b=: 0$,<'alpha'	NB. -: 0$a:
z0o=: 0$'alpha'		NB. -: ''
z0f=: 0$'alpha'		NB. -: ''
z0x=: 0 0$'alpha'	NB. -: 0 0$''


ZU_z_=: 1
