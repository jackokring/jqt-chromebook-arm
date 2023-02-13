NB. place

NB. =========================================================
NB. place      - place paragraph
NB.
NB.   dat has 7 elements:
NB.      justification;xywh;font;forecolor;dummy;linespace;text
NB.
NB. text is a boxed list of lines, and may contain tags
NB.
NB. returns: (xywh remaining);(text remaining)
NB.
NB. positions are in twips, measured from top left
NB.
NB. justification:  0=left 1=right 2=both 3=centered
place=: 3 : 0

'just xywh font foreclr dummy lspace txt'=. y

rws=. #txt
if. 0=rws do. return. end.

if. #font do.
  vfont font
end.

vtextcolor foreclr

NB. ---------------------------------------------------------
'x y width height'=. xywh
lspace=. {.lspace,1

hite=. 20* lspace*{.glzqtextmetrics''

len=. <.height%hite
NB. pos=. x,y + height
pos=. x,y

rws=. rws <. len
res=. (<x,y,width,height-hite*rws) , <len }. txt
txt=. len {. txt

while. #txt do.

  line=. ,0 pick txt
  txt=. }.txt

  if. 0=#line do.
NB.     pos=. pos-0,hite
    pos=. pos+0,hite
    continue.
  end.

NB. ---------------------------------------------------------
NB. output line with no font change:
  if. -. 1 e. , E.&line &> TAGS do.

    if. just=0 do.
      vtextxy rnd0 pos
      vtext line

    elseif. just=1 do.
      wid=. 20* {. glzqextent line
      vtextxy rnd0 pos+(width-wid),0
      vtext line

    elseif. just=2 do.

NB. !!! fixme
NB. NB.       blk=. +/line=' '
NB. NB.       wid=. {. glzqextent line
NB. NB.       if. (1<blk) *. (wid >: width*4r5) *. ' ' ~: 1{.line do.
NB. NB.         glztextjustify rnd0 (width-wid),blk
NB. NB.       end.
NB. NB.
NB. NB.       glztextxy rnd0 pos
NB. NB.       glztext line
NB. NB.       glztextjustify 0 0

    elseif. just=3 do.
      wid=. 20* {. glzqextent line
      vtextxy rnd0 pos+-:(width-wid),0
      vtext line
    end.

NB. ---------------------------------------------------------
NB. output line with font change:
  else.
    'num wid'=. width fitline line
    vfont TFONT

NB. should be?
NB.     curfont=. TFONT
NB.     'num wid'=. width fitline line
NB.     vfont curfont

    if. just=0 do.
      placeline pos;line

    elseif. just=1 do.

      placeline (pos+(width-wid),0);line

    elseif. just=2 do.
      blk=. +/line=' '

      if. (1<blk) *. wid >: width*3r4 do.
        opt=. (width-wid),blk
        opt placeline pos;line
      else.
        placeline pos;line
      end.

    elseif. just=3 do.
      placeline (pos+-:(width-wid),0);line

    end.

  end.

NB.   pos=. pos-0,hite
  pos=. pos+0,hite

end.

vtextcolor''
res
)

NB. =========================================================
placeline=: 3 : 0
0 0 placeline y
:
'pos txt'=. y
'pad blk'=. x

while. #txt do.
  b=. +./ E.&txt &> TAGS
  ndx=. b i. 1
  bit=. ndx{.txt
  if. blk do.
    num=. +/bit=' '
    space=. >.pad*num%blk
    pad=. pad-space
    blk=. blk-num
  else.
    space=. 0
  end.

  vtextxy rnd0 pos
  vtext bit
  pos=. pos + 2{. space + 20* {. glzqextent bit

  txt=. ndx}.txt
  if. 0=#txt do. break. end.

  'tag txt'=. taketag txt

  vfont TFONT changetag tag
  b=. +./ E.&txt &> TAGS

end.
)

