NB. zun.ijs, for zulu.ijs written by Ian Clark
NB. Sun 09 Sep 2012 17:50:00

ZUN_z_=: 0

cocurrent 'zulu'	NB. FOR: SANDBOX

require 'format/zulu/zu'	NB. include the trivial nouns too <<<<<

	NB. SHORTER (3-MEMBER) SAMPLE LISTS IN ALL FORMATS...
	NB. c/f zulun.ijs

 	NB. 3-member sample lists (stubs: 'Zu' and 'zu')
	NB. Shorter versions of: Zuluf Zuluo Zulux zuluf zuluo zulux
	NB. This verb both defines and documents the sample lists:
	NB.  Zuf Zuo Zux	(Capitalised)
	NB.  zuf zuo zux	(all lowercase)
	NB. For instant clarity, no samples are derived from other samples.
	NB. NAMING CONVENTION:
	NB. Suffix the stub (in this case: 'Zu' or 'zu') with the letter:
	NB.	b=boxed, o=open, f=LF-separated, x=matrix

Zub=: 'Alpha' ; 'Bravo' ; 'Charlie'	NB. boxed list
zub=: 'alpha' ; 'bravo' ; 'charlie'	NB. boxed list
Zuo=: 'Alpha Bravo Charlie'		NB. open list (SP-separated)
zuo=: 'alpha bravo charlie'		NB. open list (SP-separated)
Zuf=: 'Alpha',LF,'Bravo',LF,'Charlie'	NB. LF-separated list
zuf=: 'alpha',LF,'bravo',LF,'charlie'	NB. LF-separated list
Zux=: 3 7$'Alpha  Bravo  Charlie'	NB. matrix
zux=: 3 7$'alpha  bravo  charlie'	NB. matrix

ZUN_z_=: 1
