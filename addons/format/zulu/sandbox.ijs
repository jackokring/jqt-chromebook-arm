NB. sandbox.ijs
NB. for Addon: zulu, written by Ian Clark
NB. Sun 09 Sep 2012 12:00:00
NB. For loading sandbox on top of (say) zulu-lite

zp=. 'format/zulu/'	NB. path prefix
load 	zp,'zulun'	NB. longer sample nouns
load	zp,'zun'	NB. shorter sample nouns
load	zp,'zu'		NB. trivial sample nouns
load	zp,'zuphon'	NB. mini app: phonetic + crex

smoutput '+++ sandbox --loaded.'