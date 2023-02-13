NB. eigenpicture window

EPD=: 0 : 0
pc epd closeok;
minwh 450 450;
cc g isidraw flush;
pas 0 0;
)

NB. =========================================================
epd_close=: 3 : 0
wd'pclose'
)

NB. =========================================================
epd_g_mmove=: 3 : 0
'x y w h'=. 4 {. 0 ". sysdata
y=. h - y
rim=. unitvec (x,y) - -: w,h
end=. rim + MATRIX mp rim
j=. (MX,MY) + rim * X1,Y1
pts=. flipypos 2 4$(MX,MY), j, j, (MX,MY) + end * X1,Y1
glsel 'g'
glclear''
drawframe ''
glpen 2 1
drawpin LASTPTS
setcolor EIGENCOLOR
glpen 2 1
drawpin pts
drawpic''
glpaint ''
LASTPTS=: pts
)

NB. =========================================================
epd_g_resize=: epdraw

NB. =========================================================
epd_cancel_button=: epd_close

NB. =========================================================
epdraw=: 3 : 0

if. opened=. 0=wdisparent 'epd' do.
  wd EPD
  wd 'pn *',SYSNAME
  wd 'pmove 600 50 -1 -1'
end.
wd'pshow'

wd 'psel epd'
glsel 'g'
'w h'=. glqwh''
CX=: CY=: w <. h

OFF=: rndint -: (w-CX), h-CY

glrgb BACKCOLOR
glpen 1 1 [ glbrush''
glrect 0 0,w,h

glrgb FORECOLOR
glbrush''
glpen 1 1
gltextcolor ''
drawframe''
genpic WID * _1 _1 2 2

if. opened do. wd'pshow' end.

drawpic''
)
