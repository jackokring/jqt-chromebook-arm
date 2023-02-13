NB. cmd

NB. =========================================================
vfont=: 3 : 0
glzfont TFONT=: y
buf 'glzfont';TFONT
)

NB. =========================================================
vlines=: 3 : 0
buf 'glzlines';<. , SCALE * OFFSET + _2]\y
)

NB. =========================================================
vpage=: 3 : 0
buf 'page'
)

NB. =========================================================
vpen=: 3 : 0
buf 'glzpen';y
)

NB. =========================================================
vtext=: 3 : 0
buf 'glztext';unibox y
)

NB. =========================================================
NB. vtextcolor
vtextcolor=: 3 : 0
if. #y do.
  clr=. 256 256 256 #: y
else.
  clr=. 0 0 0
end.
buf 'glzrgb';clr
buf 'glztextcolor';''
)

NB. =========================================================
vtextxy=: 3 : 0
buf 'glztextxy';<. SCALE * OFFSET + y
)
