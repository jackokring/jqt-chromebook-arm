NB. text util

NB. =========================================================
NB.*delparaLF v delete leading and trailing blanks in paragraph
delparaLF=: 3 : 0
txt=. LF, y
a=. txt ~: ' '
b=. (a # txt) e. LF
c=. b +. }. b, 1
d=. ~: /\ a #^:_1 c ~: }: 0, c
}. (a >: d) # txt
)

NB. =========================================================
NB. fitdlb v delete leading blanks in line
fitdlb=: 3 : 0
'c f t w h'=. {.y
if. ' ' ~: {.t do. y return. end.
t=. (+./\ ' ' ~: t) # t
w=. f fontwidth t
(c;f;t;w;h) 0 } y
)

NB. =========================================================
NB. fitdtb v delete trailing blanks in line
fitdtb=: 3 : 0
'c f t w h'=. {:y
if. ' ' ~: {:t do. y return. end.
t=. (+./\. ' ' ~: t) # t
w=. f fontwidth t
(c;f;t;w;h) _1 } y
)

NB. =========================================================
fixbreak=: 3 : 0
y rplc ('<br/>',LF);'<br/>'
)
