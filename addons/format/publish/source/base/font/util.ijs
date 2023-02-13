NB. util

NB. =========================================================
fontascender=: 3 : 0
loc=. y { AFMloc
AscenderP__loc
)

NB. =========================================================
NB. return index for bold version of font
fontbold=: 3 : 0
loc=. y { AFMloc
'fam sty'=. fontfs Name__loc
sty=. sty + sty e. 0 2
fontindex1 (4 #. fam,sty),Size__loc
)

NB. =========================================================
NB. fontindex
NB.
NB. return index into AFM directories for given font
NB.
NB. font is a name + size in either J wd format, or
NB. postscript1 format, e.g.
NB.
NB.    Arial 10 bold
NB.    Helvetica-Bold 10
fontindex=: 3 : 0
'fnt sty size ang und'=. getfont_jafm_ y
fontindex1 (4 #. fnt,sty),size
)

NB. =========================================================
fontindex1=: 3 : 0
ndx=. AFMdir i. y
if. ndx = #AFMdir do.
  loc=. y newinstance 'jafm'
  AFMloc__locS=: AFMloc,loc
  AFMdir__locS=: AFMdir,y
  AFMffi__locS=: AFMffi,1 + (~.{."1 AFMdir) i. {.y
  ndx
end.
)

NB. =========================================================
NB. return font family and style
fontfs=: 3 : '0 4 #: PSFONTNAMES_jafm_ i. <y'

NB. =========================================================
NB. fontffi
NB.
NB. get font family index for given font (used by plot)
fontffi=: 3 : 0
ndx=. fontindex y,' 10'
ndx { AFMffi
)

NB. =========================================================
fontheight=: 3 : 0
loc=. y { AFMloc
Size__loc
)

NB. =========================================================
fontitalic=: 3 : 0
loc=. y { AFMloc
'fam sty'=. fontfs Name__loc
sty=. sty + 2 * sty < 2
fontindex1 (4 #. fam,sty),Size__loc
)

NB. =========================================================
fontloc=: 3 : '(fontindex y) { AFMloc'

NB. =========================================================
fontcharwidth=: 4 : 0
loc=. x { AFMloc
getcharlen__loc y
)

NB. =========================================================
fontscale=: 4 : 0
(0.1 round x * getfontsize y) setfontsize y
)

NB. =========================================================
fontwidth=: 4 : 0
loc=. x { AFMloc
getstrlen__loc y
)

NB. =========================================================
fontwidthboxed=: 4 : 0
loc=. x { AFMloc
getstrlen__loc &> y
)

NB. =========================================================
fontwidthboxedm=: 4 : 0
loc=. x { AFMloc
getstrwid__loc &> y
)

NB. =========================================================
fontwidths=: 4 : 0
loc=. x { AFMloc
getstrlens__loc y
)
