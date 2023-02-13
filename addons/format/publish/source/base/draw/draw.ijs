NB. draw

NB. =========================================================
drawbox=: 3 : 0
'x y w h'=. y
xw=. x + w
yh=. y + h
cn=. _2 [\ x,y,x,yh,xw,yh,xw,y,x,y
r=. '0.1 w',LF
r,,(":}:cn) ,"1 ' m ' ,"1 (":}.cn) ,"1 ' l S',LF
)

NB. =========================================================
drawboxc=: 4 : 0
(setcolor x),(drawbox y),setcolor BLACK
)

NB. =========================================================
NB. drawtext
NB.
NB. argument is a table:
NB.   position
NB.   color
NB.   font
NB.   text
NB.
NB. requires and updates global Textf/Texth/Textc
drawtext=: 3 : 0
r=. ''
for_d. y do.
  'pos clr font txt'=. d
  if. clr -: Textc do.
    s=. ''
  else.
    Textc=: clr
    s=. (":clr{Colors),' rg ',LF
  end.
  if. font ~: Textf do.
    Textf=: font
    Texth=: fontheight font
    s=. s,'/F',(":font{AFMffi),' ',(":Texth),' Tf ',LF
  end.
  txt=. pdfesc txt
  txt=. ' Tm (',txt,') Tj'
  clr=. ''
  pos=. pos - 0,Texth
  r=. r,s,clr,'1 0 0 1 ',(pfmt pos),txt,LF
end.
)