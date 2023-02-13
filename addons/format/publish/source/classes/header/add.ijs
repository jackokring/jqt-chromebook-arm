NB. add

NB. =========================================================
add=: 3 : 0
'off tag prm val'=. checktag2 y
num=. ; ,&'.' each ": each Level
num=. (-1 < #Level) }. num
fontname=. 'FONT',toupper tag
FONT=: fontname~
Tag=: tag
if. tag -: 'h0' do.
  addh0 prm;val return.
end.
set prm
if. ALIGN=iJUST do. ALIGN=: iCENTER end.
fnt=. fontindex FONT
Height=: fontheight fnt
val=. deb ' ' (I.val=LF) } val
ndx=. 1 i.~ '<br/>' E. val
hdr=. num,'  ',deb ndx {. val
addcontents Level;NAME;hdr
if. 0=#NAME do. NAME=: hdr end.
if. ndx < #val do.
  r=. ,:0;fnt;hdr,LF
  fnt=. fontindex FONTP
  Data=: ,<r,0;fnt;deb (ndx+5)}.val
else.
  Data=: ,<,:0;fnt;hdr
end.
)

NB. =========================================================
addh0=: 3 : 0
'prm val'=. y
ALIGN=: iCENTER
ALIGNV=: iCENTER
NAME=: 'Front Page'
set prm
if. ALIGN=iJUST do. ALIGN=: iCENTER end.
fnt=. fontindex FONTH0
val=. deb ' ' (I.val=LF) } val
val=. val rplc '<br/>';LF
val=. deb each <;._2 val,LF
hdr=. 0 pick val
val=. }. val
addcontents Level;NAME;hdr
res=. ,<,:0;fnt;hdr
if. #val do.
  fnt=. fontindex FONTP
  res=. res, ,: each 0 ;each fnt ;each val
end.
Data=: res
)
