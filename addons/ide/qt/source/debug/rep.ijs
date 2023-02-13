NB. boxed representation
NB.
NB. returns boxed list of lines

EX2=: '1234' ;&,&> ':'
EX0=: EX2 ,. < ,'0'
EX1=: EX2 ,. < ,'('

NB. =========================================================
NB.*jdb_boxrep v representation as boxed list of:
NB.
NB.   class ; monad ; dyad
NB.
NB. class is known class: 1 2 3 4 or _1 if unknown
NB.
NB. x is tacit, nameclass
jdb_boxrep=: 4 : 0

'tac nmc'=. x
if. tac do.
  rep=. SUBTC (I.y=LF) } y
  nmc;2$<<rep return.
end.

NB. ---------------------------------------------------------
NB. following does not use nmc, but recalculates it, for
NB. historical reasons. Could they differ?
hdr=. ;: LF jdb_taketo y
if. 1 e. , b=. EX0 E."1 hdr do.
  cls=. >: (+./"1 b) i. 1
  rep=. }. }: <;._2 y,LF
elseif. 1 e. , b=. EX1 E."1 hdr do.
  cls=. >: (+./"1 b) i. 1
  bgn=. 3 + 1 i.~ +./ b
  hdr=. bgn }. hdr
  hdr=. ; (hdr i. <,')') {. hdr
  try.
    rep=. ". hdr
  catch.
    rep=. hdr
  end.
elseif. 1 e. , b=. EX2 E."1 hdr do.
  cls=. >: (+./"1 b) i. 1
  ndx=. 2 + 1 i.~ +./ b
  try.
    rep=. ". ndx >@{ hdr
  catch.
    rep=. }. }: ndx >@{ hdr
  end.
elseif. do.
  cls=. _1
  rep=. y
end.
rep=. jdb_boxxopen rep
ind=. rep i. < ,':'
if. ind < #rep do.
  cls ; (ind {. rep) ; < (1+ind) }. rep
else.
  cls ; rep ; < rep
end.
)

NB. =========================================================
NB. jdb_curtail     (truncates only)
j=. SHOWWID & {.
jdb_curtail=: ]`(j f.) @. (jdb_vSHOWWID < #)

NB. =========================================================
NB. jdb_curtailed   (also adds dots)
j=. (SHOWWID-3) & {. , '...'"_
jdb_curtailed=: ]`(j f.) @. (jdb_vSHOWWID < #)

NB. =========================================================
NB. jdb_getdrep
NB. jdb_getdrep name;locale
NB. representation of defined verb/adverb/conjunction
NB. returns: rep or '' if not found
jdb_getdrep=: 3 : 0
'name loc'=. y

if. 0 e. $name do. '' return. end.

bloc=. <loc

if. 1 e. '__' E. }: name do.
  j=. jdb_splitind name
  if. 2 ~: #j do. '' return. end.
  'a b'=. j
  if. 0 ~: nc <b do. '' return. end.
  c=. (b,'_',loc,'_')~
  if. 1 ~: L. c do. '' return. end.
  18!:4 c
  nc=. 4!:0 :: _2: <a
  18!:4 <'jdebug'
  if. -. nc e. 1 2 3 do. '' return. end.
else.
  18!:4 bloc
  nc=. 4!:0 :: _2: <name
  18!:4 <'jdebug'
  if. -. nc e. 1 2 3 do. '' return. end.
end.

18!:4 bloc
def=. 5!:5 <name
18!:4 <'jdebug'

def
)

NB. =========================================================
NB. fix the definition of a local name.  x is the name, y is the value
NB. Use LOCALTYPES to define the type of the name, or noun if unknown
jdb_fixlocal=: 4 : 0
if. 0=#x do. '' return. end.  NB. Ignore empty name (happens if there are no names)
if. 0 = #LOCALTYPES do.
  jdb_fixnoun y   NB. If no names known, just assume noun
else.
  class =. (0 ,~  > {: LOCALTYPES) {~ ({. LOCALTYPES) i. <x
  if. 0 = class do. jdb_fixnoun y
  else. class jdb_fixdef y
  end.
end.
)

NB. =========================================================
NB. fix the verb/adverb/conjunction definition (boxed argument)
jdb_fixdef=: 4 : 0
type=. 'acvu' {~ 1 2 3 i. x
type,' ',jdb_subchars y
)

NB. =========================================================
NB. fix the noun representation
jdb_fixnoun=: 3 : 0

shape=. $y
len=. */shape

if. 0 = L. y do.
  y=. jdb_fixopen y

else.

  if. 1 = L. y do.
    if. 1 = len do.
      y=. '<',jdb_fixopen >{.y
    else.
      y=. jdb_curtail ,y
      ben=. */ @ $ S: 0 y
      if. 1000 < +/ ben do.
        y=. '{boxed}'
      else.
        y=. }. ; (',(<'&, @ (,&')')) &.> jdb_fixopen &.> y
      end.
    end.
  else.
    y=. '{boxed}'
  end.
  y=. (jdb_repshape shape), y

end.

r=. jdb_curtailed 'n ',jdb_subchars y

)

NB. =========================================================
NB. fix jdb_open noun
jdb_fixopen=: 3 : 0

shape=. $y
len=. */shape
rsh=. jdb_repshape shape

if. jdb_issparse y do.
  if. 1000 < len do.
    rsh, '{sparse}' return.
  else.
    t=. $. ^:_1 y
  end.
else.
  t=. y
end.

if. 0=#shape do.
  ":t
else.
  t=. jdb_curtail ,t
  jdb_curtailed rsh,jdb_quoteme t
end.
)

NB. =========================================================
NB. get boxed jdb_leaves
jdb_leaves=: ([: ; <@":@, S: 0) ^: (L. > 0:)

NB. =========================================================
NB.*jdb_quote v jdb_quote text
NB. jdb_quote 'Pete''s Place'
a=. ''''
jdb_quote=: (a&,@(,&a))@ (#~ >:@(=&a))

NB. =========================================================
NB. jdb_quoteme   jdb_quote if character
jdb_quoteme=: ":`jdb_quote @. (2&=@(3!:0))

NB. =========================================================
NB. return shape
jdb_repshape=: (0: < #) # ": , '$'"_

NB. =========================================================
NB. substitute terminal control characters:
SUBTC=: 1{a.
jdb_subtc=: SUBTC & (I. @ (e.&(9 10 12 13{a.)) @] })

NB. =========================================================
NB. remove ascii zero:
jdb_remzero=: -. & ({.a.)

NB. =========================================================
NB. jdb_subchars
jdb_subchars=: jdb_remzero @: jdb_subtc

NB. =========================================================
NB. jdb_viewname
jdb_viewname=: 4 : 0
max=. 50000
shape=. $y
scalar=. 0=#shape
type=. jdb_datatype y

dat=. jdb_flatten y
if. max < #dat do.
  dat=. (max {. dat),LF,'...'
end.

tag=. type
tag=. tag, scalar >@{ (' shape ',":shape);' scalar'

if. type -: 'boxed' do.
  tag=. tag, ' depth ',":L. y
end.

dat=. x,LF,LF,tag,LF,LF,dat
s=. 1{a.
jdb_wd 'textview *',s,'view',s,s,dat
)
