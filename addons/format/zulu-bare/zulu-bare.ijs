NB. zulu-bare.ijs written by Ian Clark
NB. Sun 09 Sep 2012 12:00:00
NB. BARE conversion suite WITHOUT SANDBOX. NO TESTING / TRIVS-FIX / ALIASES

zp=. 'format/zulu/'	NB. path prefix
load	zp,'zuerase'	NB. clear out existing zulu words
load 	zp,'zuv'	NB. conversion verbs (unpatched)
