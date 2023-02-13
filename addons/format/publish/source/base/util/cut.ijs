NB. cut

NB. =========================================================
NB. cutlist
NB. replaces any LF not in "" with blank
NB. removes any extra blanks
NB. cuts on blank, comma and LF
NB.    cutlist  '  abc ,,   def "qwe 123", qwe'
NB. +---++---+-------+---+
NB. |abc||def|qwe 123|qwe|
NB. +---++---+-------+---+
cutlist=: 3 : 0
txt=. trimWS y
msk=. (txt = LF) > ~: /\ txt = '"'
txt=. ' ' (I. msk) } txt
txt=. deb txt
if. 0=#txt do. '' return. end.
txt=. ',', txt
a=. (txt ~: ' ') +. ~: /\ txt = '"'
b=. (a # txt) e. ','
c=. b +. }. b, 1
d=. ~: /\ a #^:_1 c ~: }: 0, c
txt=. (a >: d) # txt
msk=. txt = '"'
com=. (txt e. ' ,') > ~: /\ msk
msk=. (msk *. ~:/\msk) < msk <: 1 |. msk
deb each (msk # com) <;._1 msk # txt
)

NB. =========================================================
NB. cut parameters into name, value table
NB.    cutparms 'id = first, , name = "max head", age=15'
NB. +-----+--------+
NB. |ID   |first   |
NB. +-----+--------+
NB. |NAME |max head|
NB. +-----+--------+
NB. |AGE  |15      |
NB. +-----+--------+
cutparms=: 3 : 0
txt=. deb y
if. 0 = #txt do. i.0 2 return. end.
txt=. txt, ','
msk=. txt = '"'
com=. (txt = ',') > ~: /\ msk
msk=. (msk *. ~:/\msk) < msk <: 1 |. msk
txt=. a: -.~ deb each (msk # com) <;._2 msk # txt
ndx=. txt i.&> '='
(toupper each ndx{.each txt),.deb each (ndx+1)}.each txt
)

NB. =========================================================
cutpages=: 3 : 0
txt=. '<newpage/>',txt
10 }.each ('<newpage/>' E. txt) <;.1 txt
)

NB. =========================================================
cutparas=: 3 : 0
txt=. y,LF,LF
msk=. (LF,LF) E. txt
msk=. msk +. 0,}:msk
ndx=. I. msk < txt=LF
txt=. ' ' ndx } txt
msk=. msk > 0 ,~ }.msk
txt=. msk <;._2 txt
ndx=. txt i.&> LF
txt=. ndx {.each txt
txt=. deb each txt
txt -. a:
)
