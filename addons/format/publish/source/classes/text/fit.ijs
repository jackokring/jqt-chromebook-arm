NB. fit
NB.
NB. fit result:
NB.   line is a table of chunks
NB.   para is a list of lines
NB.   data is a table of paras

NB. =========================================================
NB. fit v width fit data
NB. result is a pair:
NB.  list of fitted lines
NB.  table of corresponding widths,heights
fit=: 4 : 0
wid=. x
dat=. y
txt=. u2a each 2{"1 dat
dat=. txt 2}"0 1 dat
fit=. ''
siz=. i.0 2
while. #dat do.
  'lin bal'=. wid fitline dat
  lin=. fitdtb lin
  fit=. fit,<lin
  len=. +/ ; 3 {"1 lin
  hit=. >./; 4 {"1 lin
  siz=. siz,len,hit
  if. bal -: dat do.
    throw '201 Problem in fit - unable to fit text in width'
  end.
  dat=. bal
end.
fit;siz
)

NB. =========================================================
NB. fitchars v width fitchars font;chars
NB. fits characters to width
NB. fitted chars;remaining chars;actual width
fitchars=: 4 : 0
'fnt txt'=. y
len=. fnt fontwidths txt
cnt=. (len > x) i. 1
(cnt{.txt);(cnt}.txt);cnt { 0,len
)

NB. =========================================================
NB. fitline v width fitline data
NB. result is: fitted data;remaining data
NB. fitted data is a table:
NB.    font;chars;actual width;actual height
fitline=: 4 : 0
res=. x fitline1 y
if. #0 pick res do. return. end.
cf=. 2 {.{:y
(cf,'';0;fontheight 1 pick cf);{:res
)

NB. =========================================================
fitline1=: 4 : 0
wid=. x
dat=. y
fit=. i. 0 5
bal=. i. 0 3

NB. ---------------------------------------------------------
while. #dat do.
  'clr fnt txt'=. top=. {.dat
  if. 0=#txt do. dat=. }.dat continue. end.
  if. txt -: ,LF do.
    dat=. }.dat
    fit;<dat,bal return.
  end.
  if. LF e. }: txt do.
    ndx=. txt i. LF
    rem=. (ndx+1) }. txt
    bal=. }.dat
    if. #rem do. bal=. (clr;fnt;rem),bal end.
    dat=. ,:clr;fnt;(ndx+1){.txt continue.
  end.
  'txt rem len hit'=. wid fitwords }. top
  if. len=0 do.
    fit;<dat,bal return.
  end.
  dat=. }. dat
  fit=. fit,clr;fnt;txt;len;hit
  if. #rem do.
    bal=. dat,bal
    if. -. rem -: ,LF do.
      bal=. (clr;fnt;rem),bal
    end.
    fit;<bal return.
  end.
  wid=. wid-len
end.
fit;<bal
)

NB. =========================================================
NB. fitwords v width fitwords font;chars
NB. fits words to width
NB. words are delimited by blanks
NB. if none, cut on hyphen, otherwise on any character
NB. returns:
NB.   fitted chars;remaining chars;actual width;actual height
NB.
NB. if any remaining characters, this forces a new line. The
NB. remaining characters may simply be a LF.
fitwords=: 4 : 0
wid=. x
'fnt str'=. y
b=. LF = {:str
tlf=. b#LF
txt=. (-b) }. str -. HYPHEN
if. LF e. txt do.
  throw '201 Problem in fitwords - text has a LF'
end.
hit=. fontheight fnt

NB. ---------------------------------------------------------
off=. +/\ 1 + str = HYPHEN
len=. 0, fnt fontwidths txt
cnt=. <: (len > wid) i. 1

NB. ---------------------------------------------------------
if. cnt = 0 do.
  '';str;0;hit return.
end.

NB. ---------------------------------------------------------
if. cnt = #txt do.
  txt;tlf;({:len);hit return.
end.

NB. ---------------------------------------------------------
if. ' ' = (cnt-1){txt do.
  cnt=. cnt-1
  bal=. (cnt{off)}.str
  (cnt{.txt);bal;(cnt{len);hit return.
end.

NB. ---------------------------------------------------------
if. ' ' = cnt{txt do.
  bal=. (cnt{off)}.str
  (cnt{.txt);bal;(cnt{len);hit return.
end.

NB. ---------------------------------------------------------
NB. test if blank or hyphen fits better:
pfx=. cnt {. txt
ndx=. pfx i: ' '
sel=. ndx { len
bal=. (ndx{off)}.str
res=. (ndx{.txt);bal;sel;hit

if. -. HYPHEN e. str do. res return. end.

NB. ---------------------------------------------------------
hlen=. {. fnt fontwidth '-'
hcnt=. <: (len > wid - hlen) i. 1
htxt=. (off i. hcnt) {. str
hndx=. htxt i: '~'
if. hndx = #htxt do. res return. end.
if. hndx <: ndx do. res return. end.

NB. ---------------------------------------------------------
pfx=. (hndx{.txt),'-'
sel=. hlen + hndx { len
bal=. (1+(hndx-1){off)}.str
pfx;bal;sel;hit
)
