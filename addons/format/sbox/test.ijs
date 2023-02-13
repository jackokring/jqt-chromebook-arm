NB. Test script for sbox.ijs

load 'format/sbox'		NB. force a re-load
require 'format/zulu/lite'

cocurrent 'base'
clear''		NB. allows a reliable re-load

NB. ====================
	DATUM=: 'ft'	NB. <<< ALTER THIS
NB. ====================
NB. a      b      c      d      dom    domw   e
NB. fr     frc    frcl   frx    fs     fsx    ft     
NB. ftc    ftcl   ftx    qqd    qqdw
NB. ...Choice of nouns for DATUM.
NB. These nouns are defined below.
NB. Combine them in further nouns ad-lib.


	NB. SAMPLE CHAR/UNICODE MATRICES

fr=: }: 0 : 0
TABLE
Français
Arménien
Hébreu
Thâna
Gourmoukhî
Dévanâgarî
Gourmoukhî
Télougou
Tibétain
Géorgien
Jamos hangûl
Éthiopien
Chérokî
Taï-le
Flèches
Opérateurs mathématiques
Pavés
Formes géométriques
)

frc=: fr rplc LF ; CR
frcl=: fr rplc LF ; CRLF
frx=: f2x fr

fs=: 'ça'
fsx=: f2x fs

ftx=: 5 9 {. frx
ft=: x2f ftx
ftc=: ft rplc LF ; CR
ftcl=: ft rplc LF ; CRLF


domw=: {. uucp dom=: '⌹'
qqdw=: {. uucp qqd=: '⍞'

	NB. NESTED BOXED SAMPLES TOOLKIT
a=: 'dom⌹'
b=: 'qqd⍞ & domino⌹'
c=: (2 3) ; a ; b
d=: '⍞and⌹' ; c ; 99
e=: '以圖片形式檢視變音符號表'

NB. Can't get it to work with Chinese in APL385 Unicode
NB. because glyphs are wider than the "fixed width" of this font.

da=: datatype		NB. for fast typing

dtable=: 3 : 0
	NB. table of test nouns
if. 0=#y do.
  y=. (nl 0)
  NB. Remove from list: y any pronouns unsuitable for dtable...
  y=.y -. ;:'e fr frc frcl frx'
end.
z=. ,: ;:'NOUN SHAPE DATATYPE VALUE'	NB. start z as 2-D list
for_bn. y do. n=. >bn
  entry=. n ; ($n~); (datatype n~) ;< (n~)
NB.   smoutput entry
  z=. z,entry
end.
)

trial=: 1 : 0
	NB. TEST ONLY: call with choice of verb: u (eg ] or sbox)
smoutput u <y
smoutput u 'ab' ; ('a',dom) ; qqd
smoutput u dom ; 'a'
smoutput u 'a' ;<y
smoutput u y ; 'a'
smoutput u dom ; y
smoutput u y ; '⌹'
smoutput u (<d) ,: (<y)
smoutput u (<y) ,: <d
smoutput u (<d) , (<y)
)

NB. =========================================================
smoutput '>>> BAD BOXED DISPLAYS...'
	] trial DATUM~

smoutput '>>> CORRECTED BOXED DISPLAYS...'
	sbox trial DATUM~

smoutput '>>> TEST DATA...'
	smoutput sbox dtable''
