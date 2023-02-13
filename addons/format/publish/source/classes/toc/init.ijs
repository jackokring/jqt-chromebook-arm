NB. init
NB.
NB. Data is the toc header

coclass 'ppubtoc'

Data=: ''      NB. set when defined

NB. =========================================================
NB. alignment of page number (0=left or 2=right)
TOCALIGN=: 0

NB. =========================================================
create=: 3 : 0
coinsert 'ppubtext'
coinsert locP=: COCREATOR
Font=: fontindex FONTC0  NB. default font
)
