NB. util

deb=: #~ (+. 1: |. (> </\))@(' '&~:)

dist=: +/ &. (*:"_)

info=: sminfo @ (SYSNAME&;)

int01=: i.@>: % ]

iscomplex=: -.@(-: +)
isnumeric=: 3!:0 e. 1 4 8 16 64 128"_

log10=: 10&^.
mp=: +/ . *

fp=: x:^:_1

pow10=: 10&^

rnd=: [ * [: <. 0.5"_ + %~
rnd0=: <.@:+&0.5
rnddn=: [ * [: <. %~
rndup=: [ * [: >. %~
rndint=: <.@(0.5&+)

setcolor=: glbrush @ glrgb

tolist=: }.@;@:((10{a.)&,@,@":&.>)
tomatrix=: (_2 {. 1 1 , $) $ ,
tominus=: '-'&(I. @(e.&'_')@]})
unitvec=: % dist

wdpclose=: [: wd :: empty 'psel ' , ';pclose' ,~ ":

addLF=: tominus @ }. @ , @ (LF&,.) @ ":

NB. =========================================================
cleanit=: 3 : 0
1e_7 cleanit y
:
if. 16 ~: 3!:0 y do.
  y * x <: |y
else.
  j./"1 y * x <: | y=. +.y
end.
)

NB. =========================================================
NB. getfontsize
getfontsize=: 13 : '{.1{._1 -.~ _1 ". y'

NB. =========================================================
NB. setfontsize
NB. size setfontsize fontdescription
setfontsize=: 4 : 0
b=. ~: /\ y='"'
nam=. b#y
txt=. ;:(-.b)#y
ndx=. 1 i.~ ([: *./ e.&'0123456789.') &> txt
nam, ; ,&' ' &.> (<fmt x) ndx } txt
)
