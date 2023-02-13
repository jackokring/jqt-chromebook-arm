NB. zulun.ijs, for zulu.ijs written by Ian Clark
NB. Sun 09 Sep 2012 17:50:00

ZULUN_z_=: 0

cocurrent 'zulu'	NB. FOR: SANDBOX

	NB. 26-MEMBER SAMPLE LISTS IN ALL FORMATS...
	NB. c/f zun.ijs

SP=: ' '

Zuluf=: }: 0 : 0
Alpha
Bravo
Charlie
Delta
Echo
Foxtrot
Golf
Hotel
India
Juliet
Kilo
Lima
Mike
November
Oscar
Papa
Quebec
Romeo
Sierra
Tango
Unicorn
Victor
Whisky
Xray
Yalta
Zulu
)

	NB. 26-member sample lists (stubs: 'Zulu' and 'zulu')
	NB. The International Phonetic Alphabet (alpha only).
	NB. This verb both defines and documents the sample lists:
	NB.  Zuluf Zuluo Zulux	(Capitalised)
	NB.  zuluf zuluo zulux	(all lowercase)
	NB. Expects Zuluf (LF-separated list) to be already defined.
	NB. NAMING CONVENTION:
	NB. Suffix the stub (in this case: 'zulu') with the letter:
	NB.	b=boxed, o=open, f=LF-separated, x=matrix

Zuluo=: SP(I.Zuluf=LF) } Zuluf	NB. open list (SP-separated)
zuluo=: tolower Zuluo		NB. open list (SP-separated)
zuluf=: tolower Zuluf		NB. LF-separated list
Zulux=: > Zulub=: ;: Zuluo	NB. matrix and boxed list
zulux=: > zulub=: ;: zuluo	NB. matrix and boxed list

ZULUN_z_=: 1
