NB. set
NB.
NB. Fxywh = frame
NB. Dxywh = drawing region (within frame)

NB. =========================================================
setframe=: 3 : 0
'Fx Fy Fw Fh'=: Fxywh=: y
)

NB. =========================================================
setdraw=: 3 : 0
'Dx Dy Dw Dh'=: Dxywh=: y
)

NB. =========================================================
setnewpage=: 3 : 0
PNum__locS=: PNum + 1
setsxywh Dxywh
)

NB. =========================================================
setnewpageP=: 3 : 0
PNum__locS=: PNum + 1
setsxywhP Dxywh
)

NB. =========================================================
NB. Sxywh is the section drawing area
NB. each object may update this.
NB. (at some stage, Sxywh should be a set of frames)
NB. on new page, Sxywh is restored
setsxywh=: 3 : 0
'Sx Sy Sw Sh'=: Sxywh=: 0 >. y
)

NB. =========================================================
setsxywhP=: 3 : 'setsxywh__locP y'

NB. =========================================================
NB. subwindow
NB. Publish windows
NB.
NB. A window parameter is 4 numbers in points (1/72 inch):
NB.   top left corner, width and height
NB. This may be relative to an existing window.
NB. 0 0 is the top left (PDF has 0 0 as bottom left).
NB. A negative top left corner counts from the end, so that
NB.   -100 -200 100 200 is the 100 x 200 points at the bottom right
NB. A negative size is a reduction of the size available.
subwindow=: 4 : 0
'px py pw ph'=. x
'sx sy sw sh'=. y
if. sx < 0 do.
  sx=. px + pw - sx
else.
  sx=. px + sx
end.
if. sy < 0 do.
  sy=. py + ph - sy
else.
  sy=. py + sy
end.
if. sw < 0 do.
  sw=. px + pw + sw - sx
end.
sw=. 0 >. sw <. px + pw - sx
if. sh < 0 do.
  sh=. py + ph + sh - sy
end.
sh=. 0 >. sh <. py + ph - sy
sx,sy,sw,sh
)
