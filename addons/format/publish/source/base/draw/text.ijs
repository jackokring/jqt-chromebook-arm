NB. text

NB. =========================================================
NB. pdftext
NB. y is font;text;color;position
pdftext=: 3 : 0
'f e p'=. y

NB. ---------------------------------------------------------
NB. set up fonts
loc=. f { AFMloc
fnx=. f { AFMffi
asc=. AscenderP__loc
siz=. Size__loc
fnm=. Name__loc

rot=. 0    NB. nonce
und=. 0    NB. nonce

txt=. '/F',(":fnx),' ',(": siz),' Tf '

NB. ---------------------------------------------------------
NB. adjust position to PDF baseline
if. rot do.
  p=. p +"1 asc, 0
else.
  p=. 0 >. p -"1 [ 0, asc
end.

lin=. ''

NB. ---------------------------------------------------------
if. is1color e do.
  'rtxt rlin'=. (fnm e. CIDfonts) pdf_text f;e;t;p;a;rot;und
  txt=. txt,,LF ,"1 rtxt
  lin=. lin,rlin,(0<#rlin)#LF
else.
  for_i. i.#e do.
    'rtxt rlin'=. (fnm e. CIDfonts) pdf_text f;(i{e);(i{t);(i{p);a;rot;und
    txt=. txt,,LF ,"1 rtxt
    lin=. lin,rlin,(0<#rlin)#LF
  end.
end.

NB. ---------------------------------------------------------
pbuf wraptext txt
pbuf rlin
)

NB. =========================================================
NB. pdf_text
NB.
NB. single alignment, single font
pdf_text=: 4 : 0
0 pdf_text y  NB. x  1=use cid font
:
'fnt clr txt pos align rot und'=. y

clr=. pdf_color clr

txt=. ,each boxopen txt
if. und +. align e. iCENTER, iRIGHT do.
  len=. fnt pgetstringlen txt
end.
if. rot do.
  select. align
  case. iCENTER do.
    pos=. pos -"1 [ 0,.-:len
  case. iRIGHT do.
    pos=. pos -"1 [ 0,.len
  end.
  if. x do. txt=. toucode1@(7&u:) each txt end.  NB. convert utf8 to ucs2, then big endian encoding
  txt=. pdfesc each txt
  txt=. (<' Tm (') ,each txt ,each <') Tj '
  res=. clr,(<"1 '0 1 -1 0 ' ,"1 pfmt pos >. 0) ,&> txt
else.
  select. align
  case. iCENTER do.
    pos=. pos -"1 (-:len),.0
  case. iRIGHT do.
    pos=. pos -"1 len,.0
  end.
  if. x do. txt=. toucode1@(7&u:) each txt end.  NB. convert utf8 to ucs2, then big endian encoding
  txt=. pdfesc each txt
  txt=. (<' Tm (') ,each txt ,each <') Tj '
  res=. clr,(<"1 '1 0 0 1 ' ,"1 pfmt pos >. 0) ,&> txt
end.

if. -. und do. res;'' return. end.

NB. ---------------------------------------------------------
NB. underline
pos=. citemize pos
len=. , len

'off lwd'=. getunderline fnt
lin=. clr,' ',(":lwd) ,' w '

if. rot do.
  bgn=. 0 >. pos -"1 off,.0
  end=. bgn + 0,.len
else.
  bgn=. 0 >. pos -"1 [ 0,.-off
  end=. bgn + len,.0
end.

lin=. lin,(pdf_makelines bgn,.end) ,"1 ' b'
res;lin

)