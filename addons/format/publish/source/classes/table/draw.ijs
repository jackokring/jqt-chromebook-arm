NB. table draw

NB. =========================================================
NB. draw
NB.
NB. sets standard pre and post spacing
NB. sets standard align and color
NB. calls the table draw verb
draw=: 3 : 0

if. (NewPage=0) *. y=0 do.
  drawtable'' return.
end.

NB. ---------------------------------------------------------
NewPage=: 0

NB. ---------------------------------------------------------
Align=: setalign''
Gridh=: setgridh''
Gridv=: setgridv''
Thigh=: sethigh''
FONTTHSIZE=: getfontsize FONTTH

'Font F0 F1'=: setfont''

NB. ---------------------------------------------------------
RowPos=: 0 NB. position of cells to be printed next
Textf=: Textc=: _1

NB. ---------------------------------------------------------
space=. _4 {. prnd PARASPACE * fontheight F0
setsxywhP Sxywh - space
res=. ('draw_',tolower CLASS)~''
setsxywhP Sxywh - space

res
)

NB. =========================================================
drawit=: 3 : 0

NB. ---------------------------------------------------------
NB. get sizes:
while. 1 do.
  Fh0=: prnd Leading * fontheight F0
  Fh1=: prnd Leading * fontheight F1
  Fh1m=: prnd Leadingm * fontheight F1
  hrw=. F0 fontwidthboxed Row
  hcw=. F0 fontwidthboxed Col
  htw=. F0 fontwidthboxed Top
  if. IfMulti do.
    dtx=: F1 fontwidthboxed DataX
    dtw=. (Crws,Ccls)$DataM >./;.1 dtx
    Twx=: dtx - CDlen#,dtw
  else.
    dtw=. F1 fontwidthboxed (Crws,Ccls)$Data
  end.
  Tw=: (htw,.hcw),hrw,.dtw

NB. ---------------------------------------------------------
NB. width of row labels:
  rlw=. IfRow * MinLabelWid >. PadLabel + >./htw,hrw

NB. ---------------------------------------------------------
NB. width of data columns:
  dcw=. MinCellWid >. PadCell + >./ hcw,dtw

NB. ---------------------------------------------------------
NB. col indices (increasing from left)
  Dw=: rlw, dcw
  Dx=: Sx + +/\ 0, Dw

  if. Sw >: +/ Dw do. break. end.

NB. ---------------------------------------------------------
NB.     select. STATE
NB.     case. 0 do.
NB.       k=. 0.5
NB.       inc=. 0.01
NB.       while. k < 1 do.
NB.         t=. k + inc
NB.         rlw=. IfRow * (t*MinLabelWid) >. (t*PadLabel) + >./htw,hrw
NB.         dcw=. (t*MinCellWid) >. (t*PadCell) + >./ hcw,dtw
NB.         if. Sw < +/ rlw,dcw do. break. end.
NB.         k=. t
NB.       end.
NB.       scalemargins k
NB.       STATE=: 1
NB.     case. 1 do.
NB.       if. (-: FONTTHSIZE) >: getfontsize FONTTH do.
NB.         STATE=: 2
NB.       else.
NB.         FONTTH=: 0.99 fontscale FONTTH
NB.         FONTTC=: 0.99 fontscale FONTTC
NB.         'Font F0 F1'=: setfont''
NB.       end.
NB.     case. 2 do.
NB.       break.
NB.     end.

  if. STATE=0 do.
    k=. 0.5
    inc=. 0.01
    while. k < 1 do.
      t=. k + inc
      rlw=. IfRow * (t*MinLabelWid) >. (t*PadLabel) + >./htw,hrw
      dcw=. (t*MinCellWid) >. (t*PadCell) + >./ hcw,dtw
      if. Sw < +/ rlw,dcw do. break. end.
      k=. t
    end.
    scalemargins k
    STATE=: 1
  elseif. STATE=1 do.
    if. (-: FONTTHSIZE) >: getfontsize FONTTH do.
      STATE=: 2
    else.
      FONTTH=: 0.99 fontscale FONTTH
      FONTTC=: 0.99 fontscale FONTTC
      'Font F0 F1'=: setfont''
    end.
  elseif. do.
    break.
  end.
end.

NB. ---------------------------------------------------------
NB. row indices (from top down)
NB. Dh0 is height of each row, excluding separator
NB. Dh is height including separator
if. IfCol do.
  hch=. (Hrws$Fh0) + Hrws{.PadHeader
else.
  hch=. 0
end.
Dh0=: hch, (Fh0>.Fh1) + Fh1m * CRlen-1
Dh=: Dh0 + (#Dh0){.(-Hrws*IfCol){.SepHdrCell
Dy=: Sy + Sh - +/\ 0,Dh

NB. ---------------------------------------------------------
drawtable''
)

NB. =========================================================
scalemargins=: 3 : 0
MinLabelWid=: y*MinLabelWid
PadLabel=: y*PadLabel
MinCellWid=: y*MinCellWid
PadCell=: y*PadCell
)
