NB. show

NB. =========================================================
TIDS=: ' ' ,. 'nacvd' ,. ' '

NB. =========================================================
jdb_addlocale=: 4 : 0
if. ('_' ~: _1 {. y) > 1 e. '__' E. y do.
  if. '_' ~: _1 {. x do.
    t=. '_',(>x),'_'
  else.
    t=. x
  end.
  y,t
else.
  y
end.
)

NB. =========================================================
NB. show globals
jdb_showglobals=: 4 : 0
if. 0 e. $y do. '' return. end.

ind=. (1: e. '__'&E.) @: }: &> y

NB. get name class:
18!:4 x
nmc=. 4!:0 :: _2: "0 y
18!:4 <'jdebug'

NB. set nameclass of undefined indirect
NB. references to unknown:
nmc=. nmc - ind *. nmc=_1

msk=. nmc = 0
val=. msk # y
med=. nmc > 0
def=. med # y
GDEFS=: GDEFS, def

18!:4 x
if. #val do. val=. ". &.> val end.
if. #def do. def=. <@(5!:5) "0 def end.
18!:4 <'jdebug'

val=. jdb_fixnoun &.> val
def=. (med # nmc) jdb_fixdef &.> def

res=. (#msk) # <'{undefined}'
res=. (<'{unknown}') (I. nmc=_2)} res
res=. val (I. msk)} res
res=. def (I. med)} res
)
