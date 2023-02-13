NB. color
NB.
NB. colors used are in Colors
NB.
NB. format is a 3 column table, each value in [0,1]
NB.
NB. colors are given by indices into Colors

". toupper COLORTABLE

Colors=: i.0 3

NB. =========================================================
NB. colorindex
NB.
NB. return index or indices into Colors
colorindex=: 3 : 0
c=. y % 255
r=. Colors i. c
m=. r = #Colors
if. is1color c do.
  if. m do.
    Colors__locS=: Colors,c
  end.
else.
  if. 1 e. m do.
    Colors__locS=: Colors,m#c
  end.
  r=. Colors i. c
end.
r
)

NB. =========================================================
NB. initialize colors
colorinit=: 3 : 0
a=. ;:'BLACK WHITE RED'
('i',each a)=: i.#a
colorindex ". >a
Tfcolor=: colorindex 3 {."1 TCOLOR
Tbcolor=: colorindex 3 }."1 TCOLOR
)
