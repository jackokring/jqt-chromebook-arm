NB. init

coclass 'ppublish'

NB. font init
NB.
NB. the 4 basic postscript families are included:
NB.
NB.   0 helvetica (windows: arial)
NB.   1 times roman (windows: times new roman)
NB.   2 courier
NB.   3 symbol/zapfdingbats

CIDfonts=: ''  NB. none yet defined

NB. =========================================================
NB. AFMloc  locales
NB. AFMdir  table - 2 columns:
NB.         font family as index into font table
NB.         font size
NB. AFMffi  /F font family index
AFMloc=: ''
AFMdir=: i.0 2
AFMffi=: ''