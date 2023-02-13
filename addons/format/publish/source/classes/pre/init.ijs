NB. init
NB.
NB. a pre object has preformatted text
NB.
NB. Data is set by verb add
NB. Dbal is the balance of data to write out

coclass 'ppubpre'

Data=: ''    NB. set when defined
Font=: ''    NB. default font

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
)

NB. =========================================================
add=: 3 : 0
Data=: u2a y
Font=: fontindex FONTPF
)
