NB. zucrex.ijs - written by Ian Clark
NB. Sat 15 Sep 2012 10:45:00
NB. Noun output utility: crex

ZUCREX_z_=: 0

cocurrent 'z'

crex=: 3 : 0
0 crex y
:
	NB. printable lit repn of (string)noun y
	NB. y is VALUE. For cr-replacement use: crx
	NB. x=1 reveals diagnostics otherwise hidden
if. ((1 e. $) +. (0 e. $))y do.
  5!:5 <'y' return.	NB. use built-in conversion instead
end.
require 'strings'	NB. for: rplc
	NB. Ancillary nouns:
'QT CM'=. 39 44{a.
	NB. Ancillary verbs:
paren=. 1 |. ')(' , ":
q1=. QT , QT ,~ [: ": >
	NB. Build representation: z
z=. y rplc QT ; QT,QT
z=. q1 z rplc CRLF ; (q1',CRLF,') ; CR ; (q1',CR,') ; LF ; (q1',LF,') ; TAB ; (q1',TAB,')
	NB. catch remaining non-print chars in: y
for_c. ~. y -. 32}. 127{. a. do.
  z=. z rplc c ; q1 CM, CM,~ paren (":a. i. c),'{a.'
end.
	NB. eliminate: '',*  *,'' *,'',*
z=. z rplc (CM,QT,QT,CM) ; CM
if. (3{.z)-:QT,QT,CM do. z=. 3}.z end.
if. (_3{.z)-:CM,QT,QT do. z=. _3}.z end.
	NB. specify ravel for vec len: 1
if. ($y)-:(,1) do. z=. CM,z end.
try. assert y -: ".z	NB. Does it convert back again?
catch.
  if. x do.
    smoutput '>>> crex: BAD lit repn of noun:'
    smoutput z
    smoutput '>>> crex: --using instead: 5!:5 <''y'''
  end.
  z=. 5!:5 <'y'
	NB. Reject "cut" interpretation of boxed list
	if. '<;._1' -: 5{.z do.
NB. 	  smoutput '>>> redoing: ',z
	  4}. crex (<'~'),y return.
	end.
  z return.
end.
z
)

0 : 0
	NB. Use like this:
crex 'alpha',LF,'bravo'
crex ,:'alpha'
crex ''
crex a:
crex ' '
crex '  '
)

ZUCREX_z_=: 1
