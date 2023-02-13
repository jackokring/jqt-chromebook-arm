NB. zulu.ijs written by Ian Clark
NB. Sun 09 Sep 2012 23:50:00
NB. FULL literal list conversion suite plus sample lists

	NB. Make sandbox visible to CURRENT locale (eg _base_) ...
coinsert 'zulu'

zp=. 'format/zulu/'		NB. path prefix
load	zp,'zuerase'	NB. clear out existing zulu words
load 	zp,'zuv'	NB. conversion verbs (unpatched)
load	zp,'zulun'	NB. longer sample nouns
load	zp,'zun'	NB. shorter sample nouns
load	zp,'zuphon'	NB. mini app: phonetic
load	zp,'zucrex'	NB. noun-viewing utility: crex
load	zp,'zuvco'	NB. patch for conversion verbs
load	zp,'zuany'	NB. additional "generic" a2* verbs
load	zp,'zu4'	NB. *4* aliases
load	zp,'zutest'	NB. test all interconversions


