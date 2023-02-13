NB. util   - print utilities
NB.
NB. TAGS               HTML tags
NB. TAGIDS             tag ids
NB.
NB. boxfont            box font
NB. changefont         change font
NB. changetag          change font using HTML tags
NB. cleanup            flatten array and remove control chars
NB. deb                delete extra blanks
NB. defaults           set default values
NB. detab              detab line
NB. dlb                delete leading blanks
NB. dltb               delete leading and trailing blanks
NB. dtb                delete trailing blanks
NB. flatten            flatten array to char string
NB. fitchars           fit characters to given width
NB. fitline            fit text to line
NB. fitwords           fit words to given width
NB. getfile            get file name (respects short names)
NB. getframe           convert frame definitions inches to twips
NB. getpos             convert frame position in inches to twips
NB. getprintpage       defines PRINTPAGE
NB. preview            preview page
NB. printers           list all printers
NB. printerspecs       list printer specs
NB. removetag          remove tags from text
NB. round              round to nearest x
NB. rnd0               round to nearest integer
NB. vtextcolor         set fore color
NB. vfont              set font
NB. stamp              stamp page with time and page number
NB. taketag            separate tags from text
NB. tolist             convert boxed list to character string
NB. topara             convert text to paragraphs
NB. tstamp             timestamp
NB. xtab               remove tabs
NB. xtabline           remove tabs from single line
NB. wrappara           wrap fitted paragraph (no LF)
NB. wraptext           wrap fitted text (may contain LF)

NB. getcf              get correction factor for glzqextent

TAB=: 9 { a.
TAGS=: '<b>';'</b>';'<i>';'</i>'
TAGIDS=: ;:'bold nobold italic noitalic'
BLACK=: 0
WHITE=: <:2^24

deb=: #~ (+. 1: |. (> </\))@(' '&~:)
dlb=: }.~ =&' ' i. 0:
dltb=: #~ [: (+./\ *. +./\.) ' '&~:
dtb=: #~ [: +./\. ' '&~:
round=: [ * [: <. 0.5"_ + %~
rnd0=: <.@(0.5&+)
tolist=: }.@;@:(LF&,@,@":&.>)

NB. =========================================================
NB. boxascii  - use ascii box-drawing characters
boxascii=: 3 : 0
y=. ": y
to=. '+++++++++|-'
fm=. 9!:6 ''
(to,a.) {~ (fm,a.) i. y
)

NB. =========================================================
unibox=: 3 : 0
fm=. (16+i.11) { a.
msk=. y e. fm
if. -. 1 e. msk do. utf8 y return. end.
to=. 4 u: 9484 9516 9488 9500 9532 9508 9492 9524 9496 9474 9472
y=. ucp y
msk=. y e. fm
un=. to {~ fm i. msk#y
utf8 un (I.msk) } y
)

NB. =========================================================
NB. boxfont    box fontspec
boxfont=: 3 : 0
font=. ' ',y
b=. (font=' ') > ~:/\font='"'
a: -.~ b <;._1 font
)

NB. =========================================================
NB. changefont    font changefont optlist
NB.
NB. optlist may contain:  bold    nobold
NB.                       italic  noitalic
NB.                       {number} = size in twips
NB.
NB. font should be: fontname size [bold] [italic]
NB.
NB. e.g. 'Arial 24' changefont 'bold';28
NB.
changefont=: 4 : 0
font=. ' ',x
b=. (font=' ') > ~:/\font='"'
font=. a: -.~ b <;._1 font
opt=. y
if. 0=L. opt do. opt=. cutopen ":opt end.
opt=. a: -.~ (-.&' ' @ ":) each opt
num=. _1 ~: _1 ". &> opt
if. 1 e. num do.
  font=. ({.num#opt) 1} font
  opt=. (-.num)#opt
end.
ayes=. ;:'bold italic'
noes=. ;:'nobold noitalic'
font=. font , opt -. noes
font=. font -. (noes e. opt)#ayes
}: ; ,&' ' each ~. font
)

NB. =========================================================
NB. changetag    font changetag tag
NB. supports <b> </b> <i> </i> for bold, italic
NB. calls changefont for given tag
changetag=: 4 : 0
x changefont TAGIDS {~ TAGS i. boxopen y
)

NB. =========================================================
NB. cleanup  (remove unwanted characters)
cleanup=: 3 : 0
y=. flatten y
toJ ' ' (I. y e. 27{a.) } y
)

NB. =========================================================
NB. cutpara text   - cut text into paragraphs
cutpara=: 3 : 0
txt=. topara y
txt=. txt,(LF ~: {:txt)#LF
b=. (}.b,0) < b=. txt=LF
b <;._2 txt
)

NB. =========================================================
NB. double quote
dq=: 3 : 0
y=. ": y
if. '"' ~: {. y do.
  '"',(y #~ >: y = '"'),'" '
else.
  y,' '
end.
)

NB. =========================================================
emptymatrix=: ,:`empty @. (0:=#)

NB. =========================================================
NB. fitchars   width fitchars chars
NB. fits characters to width
NB. result is #chars, length
fitchars=: 4 : 0

fit=. *&CF @ *&20 @ {. @ glzqextent @ ({.&y)
max=. #y
avg=. 20* 5{ glzqtextmetrics''

try=. max <. >. x % avg
if. x > fit try do.
  while.
    (max > try) *. x >: fit >: try
  do. try=. >: try end.
else.
  while.
    (0 < try) *. x < fit try
  do. try=. <: try end.
end.
try, fit try
)

NB. =========================================================
NB. fitline   width fitline chars
NB. fits line  (allows for tags)
NB. result is #chars (including tags), width
fitline=: 4 : 0
wid=. x
txt=. y
b=. +./ E.&txt &> TAGS

NB. if no tags just fitwords (or fitchars):
if. -. 1 e. b do.
  num=. wid fitwords txt
  if. 0={.num do.
    num=. wid fitchars txt
  end.
  return.
end.

NB. else step through tags:
tnum=. tlen=. 0

while. 1 do.
  ndx=. b i. 1

  if. ndx>0 do.
    'num len'=. wid fitwords ndx{.txt

    tnum=. tnum + num
    tlen=. tlen + len

    if. num<ndx do.
      if. 0=tnum do.
        wid fitchars txt
      else.
        tnum,tlen
      end.
      return.
    end.

    wid=. wid-len
    txt=. ndx}.txt

    if. (wid <: 0) +. 0 = #txt do. tnum,tlen return. end.
  end.

  'tag txt'=. taketag txt
  tnum=. tnum + #;tag

  TFONT=: TFONT changetag tag
  glzfont TFONT

  if. 0=#txt do. tnum,tlen return. end.

  b=. +./ E.&txt &> TAGS

end.
)

NB. =========================================================
NB. fitwords   width fitwords chars
NB. fits words to width
NB. words are delimited by blanks; if none, cut on any character
NB. result is #chars, length
fitwords=: 4 : 0
ndx=. 0, I. (y=' '),1 1
fit=. *&CF @ *&20 @ {. @ glzqextent @ ({.&y) @ ({&ndx)
max=. _2+#ndx
avg=. 20* 5{ glzqtextmetrics''

try=. max <. 1 i.~ ndx >: x % avg

if. x > len=. fit try do.
  while.
    (max > try) *. x >: trylen=. fit >: try
  do. len=. trylen [ try=. >: try end.

else.
  while.
    (0 < try) *. x < len=. fit try
  do. try=. <: try end.
end.
(try{ndx) , len

)

NB. =========================================================
NB. flatten
flatten=: 3 : 0
dat=. ": y
if. 2 > #$dat do. return. end.
dat=. 1 1}. _1 _1}. ": <dat
}: (,|."1 [ 1,.-. *./\"1 |."1 dat=' ')#,dat,.LF
)

NB. =========================================================
NB. fold
NB. Syntax: width fold text
NB. argument is text string, result is matrix of given width
fold=: 4 : 0
dat=. toJ y
dat=. <;._2 dat,LF #~ LF ~: {: dat
dat=. ({.!.' '~ 1&>.@#) &.> dat
> ,&.> / (-x) (x&{.) \ &.> dat
)

NB. =========================================================
getdevmode=: 3 : 0
NB. wd 'pc qdevmode'
NB. wd 'cc g isigraph'
NB. r=. glzqdevmode''
NB. wd 'pclose'
NB. r
''
)

NB. =========================================================
getfile=: 3 : 0
try. {."1 getscripts_j_ y
catch. <^:(< -: {:@;~) y
end.
)

NB. =========================================================
NB. opt getframe xywh
NB.
NB. opt=0  =  from topleft, width, height  (in inches)
NB.    returns xywh for frame in twips, where xy is relative
NB.    to the printable area and is the bottom left point.
NB.    if wh <: 0, calculate from far margins
NB. NB. opt=1  =  convert back to inches
NB. e.g. getframe 0 0 0 0 = entire printable area
NB.        getframe 1 2 2 4 = topleft=1 2, size=2 by 4
getframe=: 3 : 0
'px py pw ph j j wid hit'=. ,PRINTPAGE
'x y w h'=. 1440 * y
x=. 0 >. x - px
if. w <: 0 do. w=. wid + w - 0 >. x - px end.
w=. w <. pw - x
y=. 0 >. y - py
if. h <: 0 do. h=. hit + h - 0 >. y - py end.
h=. h <. ph - y
x,y,w,h
)

NB. =========================================================
NB. opt getpos xy
NB.
NB. opt=0  =  from topleft (in inches)
NB.    returns xy for frame in twips, where xy is relative
NB.    to the printable area and is the bottom left point.
NB.    if xy < 0, calculate from far margins
NB. opt=1  =  convert back to inches
NB. e.g. getbox 0 0 = top left corner
NB.      getbox _ _ = bottom right corner
getpos=: 3 : 0
0 getpos y
:
'px py pw ph j j wid hit'=. ,PRINTPAGE
if. x=0 do.
  'x y'=. 1440 * y
  if. x >: 0 do.
    x=. pw <. 0 >. x - px
  else.
    x=. 0 >. wid + x - px
  end.
  if. y >: 0 do.
    y=. 0 >. ph - 0 >. y - py
  else.
    y=. ph - 0 >. hit + y - py
  end.
  x,y
else.
  'x y'=. y
  x=. px + x
  y=. py + ph - y + h
  1440 %~ x,y
end.
)

NB. =========================================================
NB. getprintfiles
NB.
NB. reads files and stores in PRINTFILES
getprintfiles=: 3 : 0
y=. getfile y
for_f. y do.
  try. 1!:1 f
  catch.
    empty sminfo 'print' ; 'file not found: ' , >f return.
  end.
  PRINTFILES=: PRINTFILES,y
end.
empty ''
)

NB. =========================================================
NB. getprintpage
NB.
NB. defines PRINTPAGE, a 2 row matrix:
NB.   0{PRINTPAGE = x y w h for printable area
NB.   1{PRINTPAGE = 0 0, pagewidth, pageheight
getprintpage=: 3 : 0
'w h'=. <. 1440 * glzqwh 2
'l t r b'=. <. 1440 * glzqmargins 2
PRINTPAGE=: (l,t,(w-l+r),(h-t+b)),:0 0,w,h
)

NB. =========================================================
preview=: 3 : 0
glwindowext (<0;2 3){PRINTPAGE
wd'pshow'
glpaint ''
)

NB. =========================================================
NB. printers      - list all printers
printers=: }: @ wdqprinters

NB. =========================================================
NB. removetag text   - remove tags from text
removetag=: 3 : 0
r=. ''
while. 1 e. b=. +./ E.&y &> TAGS do.
  ndx=. b i. 1
  r=. r,ndx{.y
  y=. ndx}.y
  y=. (>:y i.'>')}.y
end.
r=. r,y
)


NB. =========================================================
stamp=: 4 : 0
x,'  Page ',":y
)

NB. =========================================================
NB. taketag text   - return tag(s);text from text
taketag=: 3 : 0
tag=. ''
txt=. y
while. '<' = 1{.txt do.
  ind=. >:txt i.'>'
  tag=. tag,<ind {.txt
  txt=. ind }. txt
end.
tag;txt
)

NB. =========================================================
NB. topara text   - convert text to paragraphs
NB. replaces single LFs not followed by blanks by spaces.
topara=: 3 : 0
if. 0=#y do. '' return. end.
if. 1<#$y do. y return. end.
txt=. toJ y
b=. txt=LF
c=. b +. txt=' '
b=. b > (0,}:b) +. }.c,0
txt=. ' ' (b#i.#b) } txt
return.
b=. b *: 0,}:b=. txt=LF
txt=. b#txt
)

NB. =========================================================
tstamp=: 3 : 0
y=. <.y,(0=#y)#6!:0 ''
'y m d h n s'=. 6{.y
mth=. _3[\'   JanFebMarAprMayJunJulAugSepOctNovDec'
f=. _2: {. '0'&,@":
t=. (2":d),(m{mth),(":y),;f&.>h,n,s
r=. 'xx xxx xxxx xx:xx:xx'
t (I. r='x') } r
)

NB. =========================================================
NB. xtabline v remove tab stops
NB. remove tabs from single line
xtabline=: 4 : 0
r=. y
while.
  i=. >: r i. TAB
  i <: #r
do.
  r=. ((x * >. i % x){.!.' ' }:i{.r) , i}.r
end.
)

NB. =========================================================
NB. xtab v remove tab stops from character string
xtab=: 4 : 0
if. -. TAB e. y do. y return. end.
y=. <;._2 y,(LF ~: {:y)#LF
b=. TAB e.&> y
tolist (x xtabline each b#y) (I. b)} y
)

NB. =========================================================
NB. width wrappara text   - wrap paragraph
NB. return boxed list of lines
wrappara=: 4 : 0
if. 0=#y do. <a: return. end.
r=. ''
txt=. y
while. #txt do.
  len=. {.x fitline txt
  line=. len{.txt
  txt=. len}.txt
  txt=. (' '=1{.txt)}.txt
  r=. r,<line
end.
<r
)

NB. =========================================================
NB. width wraptext text
NB. return boxed list of lines
NB. assumes paras delimited by LF
NB. if text is a matrix, just return the boxed rows
wraptext=: 4 : 0
if. 0 e. $y do. '' return. end.
if. 2=#$y do. ;/y return. end.
txt=. toJ y
if. -. LF e. txt do. >x wrappara txt return. end.
txt=. txt,(LF~:{:txt)#LF
txt=. ;x&wrappara ;._2 txt
)


NB. =========================================================
NB. kludge
NB. get correct factor for glzqextent
getcf=: 3 : 0
glzfont CFFONT
CF=: 72% {. glzqextent 10#'m'
)

