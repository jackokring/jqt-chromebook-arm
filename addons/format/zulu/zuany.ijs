NB. zuany.ijs, for zulu.ijs written by Ian Clark
NB. Sat 08 Oct 2011 18:55:00
NB. GENERIC interconversions of form: a2*
NB. including verb: zutype

ZUANY_z_=: 0

cocurrent 'z'	NB. c/f BASIC VERBS - ALWAYS LOADED INTO _z_ LOCALE

zutype=: 3 : 0
	NB. Returns scalar char showing what type of list y is...
	NB. 	'o'	-openlist
	NB. 	'b'	-boxed
	NB. 	'x'	-literal mx
	NB. 	'f'	-LF-separated
	NB. 	'm'	-empty (matrix)
	NB. 	'n'	-empty (all other types)
	NB. 	'-'	-not a valid zutype
if.	0 0-:$y		do. 'm' return.
elseif.	0=#y		do. 'n' return.
elseif. 32=z=. 3!:0 y	do. 'b' return.
elseif. 2~:z		do. '-' return.	NB. non-literal
elseif.	2=s=.#$y	do. 'x' return. NB. litmx
elseif.	0=s		do. 'o' return. NB. scalar char
elseif.	LF e. y		do. 'f' return. NB. LF-sep
elseif.	' ' e. y	do. 'o' return. NB. ' '-sep
elseif.	1=s		do. 'o' return. NB. scalar char
end.
'-'	NB. whatever remains is not a good zutype
)

	NB. Error verbs to return empty list of correct zutype
	NB. -called if verb *2* fails in: a2* ...
LL=: ''"_		NB. empty literal 1D list
MM=: (0 0$'')"_		NB. empty literal 2D list
BB=: LL			NB. (use as) empty boxed list also

	NB. Generic interconversions of form: a2*
a2b=:	3 : '". :: BB ''2b y'',~zutype y'
a2o=:	3 : '". :: LL ''2o y'',~zutype y'
a2x=:	3 : '". :: MM ''2x y'',~zutype y'
a2f=:	3 : '". :: LL ''2f y'',~zutype y'

ZUANY_z_=: 1
