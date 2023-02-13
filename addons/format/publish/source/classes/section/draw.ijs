NB. section draw

NB. =========================================================
NB. draw
NB.
NB. draw called in locales with 1=new, 0=continue
draw=: 3 : 0
newpage=. 1=#Level
page=. ''
if. y do.
  setsxywh Sxywh__locP
end.
res=. i.0 3

NB. ---------------------------------------------------------
for_loc. Locs do.
  if. ShowFrames do. page=. page,LF,RED drawboxc Sxywh end.
  lox=. loc_index { Locx
  r=. draw__loc 1

NB. ---------------------------------------------------------
  if. lox = iSECTION do.
    if. #page do.
      res=. res, Level;newpage;page
      newpage=. 0
      page=. ''
    end.
    res=. res, r continue.
  end.

NB. ---------------------------------------------------------
  while.
    'rc dat'=. r
    page=. page,dat
    rc do.
    if. #page do.
      res=. res, Level;newpage;page
      page=. ''
    end.
    newpage=. 1
    setnewpage''
    r=. draw__loc 0
  end.
end.

NB. ---------------------------------------------------------
setsxywhP Sxywh
res=. res, Level;newpage;page
res
)
