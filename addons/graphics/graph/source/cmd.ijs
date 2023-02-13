NB. commands

NB. =========================================================
vcolor=: 3 : 0
BRUSHCOLOR=: vrgb y
glbrush glrgb BRUSHCOLOR
)

NB. =========================================================
vfont=: 3 : 0
FONT=: y
)

NB. =========================================================
vpen=: 3 : 0
PEN=: 2 {. y
glrgb PENCOLOR
glpen PEN
)

NB. =========================================================
vpencolor=: 3 : 0
PENCOLOR=: vrgb y
glrgb PENCOLOR
glpen PEN
)

NB. =========================================================
vtextcolor=: 3 : 0
TEXTCOLOR=: vrgb y
)

NB. =========================================================
vrgb=: 3 : 0
clr=. y
if. 1=#clr do.
  |. 256 256 256 #: {.clr
end.
)

NB. =========================================================
vtext=: 3 : 0
'p a t'=. y
vtextdo (scalexy p);a;t
)

NB. =========================================================
vtext01=: 3 : 0
'p a t'=. y
vtextdo (scalexy01 p);a;t
)

NB. =========================================================
vtextdo=: 3 : 0
'p a t'=. y
glfont FONT
glrgb TEXTCOLOR
gltextcolor ''
'w h'=. glqextent t
gltextxy p - (w * a%2),h%2
gltext t
glrgb PENCOLOR
)

NB. =========================================================
varc=: glarc @: scalexy
vchord=: glchord @: scalexy
vellipse=: glellipse @: scalerect
vlines=: gllines @: scalexy
vpie=: glpie @: scalexy
vpixel=: glpixel @: scalexy
vpolygon=: glpolygon @: scalexy
vrect=: glrect @: scalerect
vroundr=: glroundr @: scalerect

varc01=: glarc @: scalexy01
vchord01=: glchord @: scalexy01
vellipse01=: glellipse @: scalerect01
vlines01=: gllines @: scalexy01
vpie01=: glpie @: scalexy01
vpixel01=: glpixel @: scalexy01
vpolygon01=: glpolygon & scalexy01
vrect01=: glrect @: scalerect01
vroundr01=: glroundr @: scalerect01
