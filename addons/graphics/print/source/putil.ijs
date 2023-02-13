NB. putil

NB. =========================================================
pfsize=: 3 : 0
}. ;',' , each |. _3 <@|.\ |. ":fsize y
)

NB. =========================================================
pfstamp=: 3 : 0
'y r'=. split fstamp y
y=. (":y) , ;_2&{.@('0'&,)@":&> r
n=. 'xxxx-xx-xx xx:xx:xx'
y (I. n = 'x') } n
)

NB. =========================================================
NB. return print options or empty if error
NB. options given are:
NB.   ascii cols filename fit font fontsize header footer
NB.   land|landscape ruler tab
printopts=: 4 : 0

std=. PRINTOPT
y=. std,((0<#std)#';'),y

if. x do.
  font=. P2UPFONT
else.
  font=. PRINTERFONT
end.

filename=: ''
printer=: ''
printfile=: ''
header=. ''
footer=. ''
cols=. 80
tab=. 4

def=. 0: = 4!:0@<

if. #y do.
  opts=. dltb each ';' cutopen y
  opts=. ((tolower@{. ; }.@}.)~ i.&' ')&> opts
  try. ({."1 opts)=. {:"1 opts
  catch.
    sminfo 'Print';'Error in print options' return.
  end.
end.

fit=. def 'fit'
ruler=. def 'ruler'

if. def 'ascii' do.
  ascii=. {. 1 ". ascii,' 1'
else.
  ascii=. 0
end.

if. 2 = 3!:0 cols do.
  cols=. {. 80 ". cols
end.

if. 2 = 3!:0 tab do.
  tab=. {. 4 ". tab
end.

if. P2UP do.
  orient=. 2
else.
  if. +./ def&> 'port' ; 'portrait' do.
    orient=. 1
  elseif. +./ def&> 'land' ; 'landscape' do.
    orient=. 2
  elseif. 1 do.
    orient=. 0
  end.
end.

if. def 'fontsize' do.
  defsize=. ". >1 { boxfont font
  font=. font changefont defsize ". fontsize
end.

ascii ; cols ; filename ; fit ; font ; header ; footer ; orient ; ruler ; tab ; printer ; printfile
)

NB. =========================================================
NB. printruler
printruler=: 3 : 0
j=. >.0.2 * len=. y
'a b c'=. 1 4 7 { , 9!:6 ''
r=. len #"1 ,. c , ' ' , a
i=. }.5 * i.j
r=. b (<0 2 ; 0 , i) } r
r=. '0' (<1 ; 0) } r
if. len > 5 do.
  r=. (3 ": ,.i) (<1 ; i -/ 2 1 0) } r
end.
<"1 r
)

NB. =========================================================
NB. printfilename
NB. returns filename and filename2 to fit
NB.
printfilename=: 4 : 0
f=. y
f2=. ''
tag=. '...'
if. x printnofit f do.
  ndx=. (_21 }. f) i: ' '
  f2=. (ndx + 1) }. f
  f=. dltb ndx {. f
  while. x printnofit f do.
    f=. (3 * tag -: 3 {. f) }. f
    f=. (PATHSEP = {.f) }. f
    f=. tag , f }.~ f i. PATHSEP
  end.
end.
f ; f2
)

NB. =========================================================
printnofit=: 4 : 0
if. x do. w=. {.x fitline y else. w=. Cols end.
w < #y
)

NB. =========================================================
NB. printheader
NB. return print header as boxed list
NB. width printheader header;filename
printheader=: 4 : 0
'hdr fnm'=. y
'fnm fnm2'=. x printfilename fnm
r=. ''
if. #hdr do. r=. hdr ; '' end.
r , (boxxopen fnm) , (boxxopen fnm2) , boxxopen (0 < #fnm) # ' '
)

