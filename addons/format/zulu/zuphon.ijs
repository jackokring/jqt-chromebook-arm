NB. zuphon.ijs - written by Ian Clark
NB. Sat 08 Sep 2012 02:00:00
NB. International Phonetic Alphabet mini-app

ZUPHON_z_=: 0

cocurrent 'zulu'	NB. FOR: SANDBOX

require 'format/zulu/zulun'	NB. to use (long) sample nouns

phonetic=: 3 : 0
	NB. show string: y in International Phonetic Alphabet
	NB. Non-alpha letters (incl SP) appear as asterisks
ap=. Zulub , <,'*'
azs=. 'abcdefghijklmnopqrstuvwxyz'
b2o ap {~ azs i. tolower y
)

0 : 0
	NB. Use like this:
phonetic 'Testing testing'
)

ZUPHON_z_=: 1
