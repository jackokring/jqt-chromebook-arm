NB. bare.ijs
NB. Sat 22 Sep 2012 13:07:37
NB. adapted from zulu.ijs by commenting out given lines
NB. BARE conversion suite WITHOUT SANDBOX. NO TESTING / TRIVS-FIX / ALIASES
NB. Use like this:   require 'format/zulu/bare'

NB. 	NB. Make sandbox visible to CURRENT locale (eg _base_) ...
NB. coinsert 'zulu'

zp=. 'format/zulu/'		NB. path prefix
load	zp,'zuerase'	NB. clear out existing zulu words
load 	zp,'zuv'	NB. conversion verbs (unpatched)
NB. load	zp,'zulun'	NB. longer sample nouns
NB. load	zp,'zun'	NB. shorter sample nouns
NB. load	zp,'zuphon'	NB. mini app: phonetic
NB. load	zp,'zucrex'	NB. noun-viewing utility: crex
NB. load	zp,'zuvco'	NB. patch for conversion verbs
NB. load	zp,'zuany'	NB. additional "generic" a2* verbs
NB. load	zp,'zu4'	NB. *4* aliases
NB. load	zp,'zutest'	NB. test all interconversions

