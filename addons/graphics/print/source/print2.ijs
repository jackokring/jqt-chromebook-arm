NB. print2 methods

NB. =========================================================
NB. print text in 2-up mode
NB. returns 0=OK, 1=fail or nothing to print
printinit2=: 3 : 0

if. #PRINTFILE do.
  Filename=: PRINTFILE , ' ' , (pfsize PRINTFILE) ,' ' , pfstamp PRINTFILE
  PRINTTXT=: fread PRINTFILE
end.

fascii=. boxascii^:Ascii

vfont Font

HEADER=: > 0 printheader Header ; Filename

'wid len'=. <. 1440* glzqwh 2
'hite width'=. 20* 0 6 { glzqtextmetrics ''

inlen=. len * 1 - TOPM2 + BOTM2
rws=. <. inlen % hite * 1.2
leftm0=. wid * LEFTM2
leftm1=. leftm0 + -:wid
ftrow=. len * 1 - FOOTM2
irws=. (len * TOPM2) + inlen * (i.rws) % rws
n=. #HEADER
rws=. rws - n

Cols=: <. width %~ -: wid * 1 - 3*LEFTM2
RULE=. fascii > printruler Cols

LHDR=: rnd0 leftm0 ,. n {. irws
RHDR=: rnd0 leftm1 ,. n {. irws
LTXT=: rnd0 leftm0 ,. n }. irws
RTXT=: rnd0 leftm1 ,. n }. irws
LFTR=: rnd0 leftm0 , ftrow
RFTR=: rnd0 leftm1 , ftrow
LINE=: rnd0 , (-:wid) ,. len * (1 - TOPM2) , FOOTM2

PAGE=: 0
foot=: (((Cols - 30) {.!.' ' Footer) , tstamp '')&stamp

dat=. cleanup PRINTTXT
dat=. fascii dat
dat=. Tab xtab dat
dat=. FF cutopen dat
dat=. Cols fold each ucp each dat
dat=. ((4 * Ruler) - rws)&(<\) each dat
TRWS=: rws
TCLS=: Cols
TEXT=: > ;dat
if. Ruler do.
  TEXT=: RULE ,"2 TEXT
end.

NB. ---------------------------------------------------------
print2pages''
0
)

NB. =========================================================
print2pages=: 3 : 0
bufinit''
PAGE=: 0
cmd=. (vtext@[ vtextxy)"1
while. #TEXT do.
  mat=. TRWS, TCLS
  vfont TFONT
  vpen 5 0
  vlines LINE
  if. #HEADER do. HEADER cmd LHDR end.
  (mat {. {.TEXT) cmd LTXT
  TEXT=: }.TEXT
  PAGE=: >:PAGE
  (foot PAGE) cmd LFTR
  if. #TEXT do.
    if. #HEADER do. HEADER cmd LHDR end.
    (mat {. {.TEXT) cmd RTXT
    TEXT=: }.TEXT
    PAGE=: >:PAGE
    (foot PAGE) cmd RFTR
  end.
  vpage''
end.
)
