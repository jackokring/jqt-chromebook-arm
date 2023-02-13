NB. zulu-lite.ijs written by Ian Clark
NB. Sun 09 Sep 2012 12:00:00
NB. FULL conversion suite WITHOUT SANDBOX. NO TESTING.

zp=. 'format/zulu/'	NB. path prefix
load	zp,'zuerase'	NB. clear out existing zulu words
load 	zp,'zuv'	NB. conversion verbs (unpatched)
load	zp,'zuvco'	NB. patch for conversion verbs
load	zp,'zuany'	NB. additional "generic" a2* verbs
load	zp,'zu4'	NB. *4* aliases
