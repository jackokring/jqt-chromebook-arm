NB. validate

NB. =========================================================
NB. j_valcheck
NB. checks directory + freelist
j_valcheck=: 3 : 0
'h o'=. j_open y
if. h=_1 do. 1 return. end.
'v s c l d f q'=. j_dir h
free=. j_read h;f
dir=. j_readdir v,h,c,d
r=. /:~ f,d,dir,free
p=. {.{.r
s=. p e. 256 512 1024
y=. p,+/"1 r
if. o do. jclose h end.
s *. y -: ({."1 r),l
)

NB. =========================================================
NB. j_validate
NB. use for testing only - set to ] in distributed system
j_validate=: 3 : 0
13!:8 (-.j_valcheck y) # 12
)

j_validate=: ]

