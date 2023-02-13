NB. util

cocurrent 'z'

bk=: '[' , ']' ,~ ]
fmt=: ,@(8!:2)
sep=: }.@;@:(','&,each)
sepfmt=: ' ' -.~ }.@,@(',' ,. >@{.@(8!:1)@,.)
isboxed=: 0 < L.
ischar=: 2=3!:0
isscalar=: 0 = #@$

NB. =========================================================
cutcommas=: 3 : 0
y=. ',',y
m=. ~:/\y='"'
m=. *./ (m < y=','), 0 = _2 +/\ @ (-/)\ m <"1 '{}[]'=/y
m <@dltb;._1 y
)

NB. =========================================================
dec=: 3 : 0
if. '[' ~: {.y do.
  0 ". ' ' (I.y=',')} y return.
end.
y=. }.}:y
if. '[' e. y do.
  dec each cutcommas y
else.
  dec y
end.
)

NB. =========================================================
enc=: 3 : 0
if. isboxed y do.
  bk sep enc each y
elseif. ischar y do.
  dquote y
elseif. do.
  bk@sepfmt`fmt @. isscalar y
end.
)

NB. =========================================================
NB. for development
reloadJ_z_=: 3 : 0
dat=. freads '~addons/net/websocket/demo4/run.ijs'
0!:100 dat {.~ ('load ''net/websocket''' E. dat) i: 1
)
