NB. init

coclass 'ppubskip'

Size=: 1

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
)

NB. =========================================================
add=: 3 : 0
Size=: {. (0 ". y),Size
)

NB. =========================================================
draw=: 3 : 0
h=. Size * fontheight fontindex FONTP
setsxywhP Sxywh - 0 0 0,h
0;''
)