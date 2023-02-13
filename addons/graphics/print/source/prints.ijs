NB. print methods

NB. =========================================================
NB. returns 0=OK, 1=fail or nothing to print
printinit1=: 3 : 0
if. #PRINTFILE do.
  Filename=: PRINTFILE , ' ' , (pfsize PRINTFILE) ,' ' , pfstamp PRINTFILE
  PRINTTXT=: fread PRINTFILE
end.

txt=. cleanup PRINTTXT
if. 0 e. $txt do. 1 return. end.

NB. ---------------------------------------------------------
fascii=. boxascii ^: Ascii
vfont Font

getprintpage''
'x y width height'=. getframe LEFTM , TOPM , (-RIGHTM) , -FOOTM

HEADER=: > width printheader Header ; Filename

hite=. 20* {.glzqtextmetrics ''

fb=. 1440 * BOTM - FOOTM
headhite=. hite * #HEADER
texthite=. height - fb + headhite
HEADBOX=: x , y , width , headhite
TEXTBOX=: x , (y + headhite) , width , texthite
FOOTBOX=: x , (y + height - fb), width , hite

NB. ---------------------------------------------------------
txt=. fascii txt
txt=. Tab xtab txt
if. Fit do. txt=. topara txt end.
txt=. FF cutopen txt
TEXT=: width wraptext each txt
TEXTP=: ''

NB. ---------------------------------------------------------
if. Ruler do.
  if. (2 = 3!:0 y) *. 1 < # $y do.
    cls=. {: $y
  else.
    cls=. >./ ; #&> each TEXT
  end.
  RULE=: fascii each printruler cls
  RULEBOX=: x , (y + headhite), width , 3 * hite
  TEXTBOX=: x , (y + headhite + 3 * hite) , width , texthite - 3 * hite
else.
  RULE=: RULEBOX=: ''
end.

NB. ---------------------------------------------------------
LFTR=: (-.0 e. $Footer) # < ,: ,Footer
rfoot=: [: < [: ,: (tstamp '')&stamp

NB. ---------------------------------------------------------
printpages''
0
)

NB. =========================================================
printpages=: 3 : 0
bufinit''
PAGE=: 0
while. (#TEXT) + #TEXTP do.
  PAGE=: >: PAGE
  if. #TEXTP do.
    printpage''
  else.
    if. #TEXT do.
      TEXTP=: 0 pick TEXT
      TEXT=: }.TEXT
      printpage''
    end.
  end.
end.
0
)

NB. =========================================================
printpage=: 3 : 0
vfont TFONT
place 0 ; HEADBOX ; '' ; '' ; '' ; 1 ; <HEADER
place 0 ; RULEBOX ; '' ; '' ; '' ; 1 ; <RULE
'pos p1'=. place 0 ; TEXTBOX ; '' ; '' ; '' ; 1 ; <TEXTP
place 0 ; FOOTBOX ; '' ; '' ; '' ; 1 ; <LFTR
place 1 ; FOOTBOX ; '' ; '' ; '' ; 1 ; <rfoot PAGE
vpage ''
TEXTP=: p1
)
