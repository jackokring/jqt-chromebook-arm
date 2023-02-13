NB. font

NB. =========================================================
cidfont=: 4 : 0
txt=. LF;<;.2 ". toupper y -. '-'
msk=. 1 = #&> txt
txt=. msk<@;;._1 txt
txt=. (<'<<',LF) ,each txt ,each <'>>',LF
'a b c'=. txt
prev=. x { 3 + 0 0, +/\PDFFontpages
b=. b rplc '%prev';":prev
c=. c rplc '%prev';":prev+1
c=. c rplc '/Name /F';'/Name /F',":x
a;b;c
)

NB. =========================================================
NB. fonts
NB.
NB. defines:
NB. PDFFonts = names of fonts used
NB. PDFFontpages = count of pages used for fonts
fonts=: 3 : 0

PDFFonts=: (~.{."1 AFMdir) { PSFONTNAMES_jafm_
PDFFontpages=: 1 + 2 * PDFFonts e. CIDfonts

hdr=. '<<',LF,'/Type /Font',LF,'/Subtype /Type1',LF,'/Name /F'
ftr=. LF,'/Encoding /WinAnsiEncoding',LF,'>>',LF
r=. ''
for_f. PDFFonts do.
  if. f e. CIDfonts do.
    r=. r, ( 1+f_index) cidfont >f
  else.
    fnt=. (": 1 + f_index),LF,'/BaseFont /', >f
    r=. r, <hdr, fnt, ftr
  end.
end.
r
)
