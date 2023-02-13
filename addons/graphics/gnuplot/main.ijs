NB. gplot main functions

NB. =========================================================
NB. gnuplot      - main plotting function
gnuplot=: 4 : 0
'cmd dat'=. y

NB. ---------------------------------------------------------
if. IFWIN do.
  'exe ini'=. getbinfiles''
else.
  exe=. 'gnuplot'
  ini=. ''
end.

NB. ---------------------------------------------------------
NB. files:
pfx=. fslash GNUPLOTOUT,'gnu'
fdat=. pfx,'.dat'
fplt=. pfx,'.plt'

NB. ---------------------------------------------------------
dat=. x getdata dat
shp=. $dat

dat gpwrite fdat

NB. ---------------------------------------------------------
if. #ini do.
  txt=. 'load "',(fslash ini),'"',LF
else.
  txt=. ''
end.
txt=. txt, gpsetcommand''
txt=. txt, x gpcommand cmd;shp;fdat
txt 1!:2 <fplt

NB. ---------------------------------------------------------
if. IFWIN *. 0 < #exe do.
  fork_jtask_ '"',exe,'" "',fplt,'" -'
else.
  gphost exe,' "',fplt,'" -'
end.

empty''
)

NB. =========================================================
NB. gpcommand
NB. returns gplot command
gpcommand=: 4 : 0
'cmd shp file'=. y

file=. '"',file,'"'
cmd=. cutstring cmd
spl=. 's' e. x

NB. assume only 1 data set if surface
cls=. spl { (<:{:shp), 1

msk=. #~ -.@(+. ~:/\)@(e.&'''"')
txt=. msk each cmd

if. '[' e. j=. >{.txt do.
  b=. +./\.j=']'
  range=. b#first=. >{.cmd
  cmd=. (<(-.b)#first),}.cmd
else.
  range=. ''
end.

NB. ---------------------------------------------------------
if. #cmd do.
  b=. (1: e. 'title'&E.) &> txt
  cmd=. (b{'notitle ';'') ,each cmd
  cmd=. ' ' ,each cmd
else.
  cmd=. <' notitle'
end.

NB. ---------------------------------------------------------
if. 's' e. x do.
  cmd=. ; cmd
  def=. file
else.
  cmd=. cls {. cmd, cls $ {: cmd
  cmd=. cmd ,&> <',\',LF
  def=. (file,"1 ' using 1:')&, &> ": each 2 + i.cls
end.

NB. ---------------------------------------------------------
x,'plot ',range, ' ', _3 }. ,def ,"1 cmd
)

NB. =========================================================
NB. gset
NB. build set arguments in SETBUFFER
NB. if y is empty, return and reset buffer
gset=: 3 : 0
r=. empty ''
if. #y do.
  y=. y, ';' -. {: y   NB. ensure trailing ;
  SETBUFFER=: SETBUFFER,y
else.
  if. 0=4!:0 <'SETBUFFER' do.
    r=. SETBUFFER
  end.
  SETBUFFER=: ''
end.
r
)

NB. =========================================================
gpsetcommand=: 3 : 0
;< @ ('set '&, @ (,&LF)) ;._2 gset''
)

NB. =========================================================
NB. gpwrite   - write data to file as text
NB. dat gpwrite file
gpwrite=: 4 : 0
dat=. gpflatten x
dat=. '-' (I. dat='_') } dat
dat 1!:2 boxopen y
)
