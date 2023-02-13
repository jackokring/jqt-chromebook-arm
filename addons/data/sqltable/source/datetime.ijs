NB. convert between datetiime formats

NB. =========================================================
NB. private verbs
NB.
NB. isodatenull
NB. isotime
NB. isotimenull
NB. isotimestampnull
NB. todatenull
NB. todatey2
NB. totime
NB. totimenull
NB. totimestampnull
NB. totimestampy2
NB. totimey2

NB. =========================================================
NB. totimestampy2
NB.
NB. convert datetime (yyyy mm dd hh MM ss.nnn) to jtype Y2 number
NB.
NB. this is called by sqltojtype
totimestampy2=: 3 : 0
+/@((10000 100 1, % 100 10000 1000000)&*) "1 y
)

NB. =========================================================
NB. todatey2
NB.
NB. convert datetime (yyyy mm dd [hh MM ss.nnn]) to jtype Y2 number
NB.
NB. time portion discarded
todatey2=: 3 : 0
+/@((10000 100 1)&*@:(3&{.)) "1 <. y
)

NB. =========================================================
NB. totimey2
NB.
NB. convert datetime (yyyy mm dd [hh MM ss.nnn]) to jtype Y2 number
NB.
NB. date portion discarded
totimey2=: 3 : 0
+/@((% 100 10000 1000000)&*@:(_3&{.)) "1 y
)

NB. =========================================================
NB. isotimestampnull
NB.
NB. convert datetime (yyyy mm dd [hh MM ss.nnn]) to iso timestamp yyyy-mm-dd hh:MM:ss[.nnn]
NB.
NB. return null as blank string
isotimestampnull=: 3 : 0
b=. y +./@e.("1) _ __
(23#' ') (I. b)}isotimestamp y
)

NB. =========================================================
NB. isodatenull
NB.
NB. convert datetime (yyyy mm dd [hh MM ss.nnn]) to iso date yyyy-mm-dd
NB.
NB. return null as blank string
isodatenull=: 3 : 0
b=. y +./@e.("1) _ __
(10#' ') (I. b)}(10 {."1 isotimestamp) y
)

NB. =========================================================
NB. isotimenull
NB.
NB. convert datetime (yyyy mm dd hh MM ss.nnn) to iso time hh:MM:ss[.nnn]
NB.
NB. return null as blank string
isotimenull=: 3 : 0
b=. y +./@e.("1) _ __
(12#' ') (I. b)}isotime y
)

NB. =========================================================
NB. isotime
NB.
NB. convert datetime (yyyy mm dd hh MM ss.nnn) to iso time hh:MM:ss[.nnn]
NB.
NB. assume data not null
isotime=: 3 : 0
d=. ($y)$ 0 (I.y1 e. _ __)}y1=. ,y
s=. $d=. (2 3 7j3) ": d
d=. , d
d=. s$'0'(I. ' '=d)}d
d=. ((#d)#,:'::') (<a:;2 5)} d
({:$d) {."0 1 d
)

NB. =========================================================
NB. totimestampnull
NB.
NB. return datetime in the format yyyy mm dd hh MM ss from sql datetime
NB.
NB.  null as 6$_
totimestampnull=: 3 : 0
r=. $$y
d=. todatenull@:<. y
t=. totimenull@:(((1&|) ::])"0) y
if. 0=r do.
  d,t
else.
  d,.t
end.
)

NB. =========================================================
NB. todatenull
NB.
NB. return date in the format yyyy mm dd from sql datetime
NB.
NB.  null as 3$_
todatenull=: 3 : 0
r=. $$y
b=. _ __ e.~ y=. <. ,y
z=. todate 0 (I.b)}y
if. 0=r do.
  (*+/b){z,:_ _ _
else.
  _ _ _ (I. b)}((#y),3)$,z
end.
)

NB. =========================================================
NB. totimenull
NB.
NB. return time in the format hh MM ss from sql datetime
NB.
NB.  null as 3$_
totimenull=: 3 : 0
r=. $$y
b=. _ __ e.~ y=. ,y
z=. totime 0 (I.b)}y
if. 0=r do.
  (*+/b){z,:_ _ _
else.
  _ _ _ (I. b)}((#y),3)$,z
end.
)

NB. =========================================================
NB. totime
NB.
NB. return time in the format hh MM ss from sql datetime
NB.
NB.  assume data not null
totime=: 3 : 0
r=. $$y
h=. <. a=. 24*(1&|) y
m=. <. a=. 60*a-h
s=. 60*a-m
if. 0=r do.
  h,m,s
else.
  h,.m,.s
end.
)
