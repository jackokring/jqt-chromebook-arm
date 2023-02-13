NB. util

NB. =========================================================
NB. convert strings with J box chars to utf8
NB. rank < 2
boxj2utf8=: 3 : 0
if. 1 < #$y do. y return. end.
b=. (16+i.11) { a.
if. -. 1 e. b e. y do. y return. end.
y=. ucp y
a=. ucp '┌┬┐├┼┤└┴┘│─'
x=. I. y e. b
utf8 (a {~ b i. x { y) x } y
)

NB. =========================================================
clipread=: wd@('clippaste'"_)

NB. =========================================================
clipwrite=: 3 : 0
txt=. boxj2utf8 flatten ":y
wd 'clipcopy *',txt
#txt
)

NB. =========================================================
NB.*dbjc v turn debugging window on/off
dbjc=: 3 : 0
if. y do.
  if. _1 = 4!:0 <'jdb_open_jdebug_' do.
    0!:0 <jpath '~addons/ide/ja/debugs.ijs'
  end.
  jdb_open_jdebug_''
else.
  jdb_close_jdebug_ :: ] ''
end.
)

NB. =========================================================
NB.*flatten v flatten array to a character string
NB. flattens array to a character string with same display
flatten=: 3 : 0
dat=. ": y
select. # $ dat
case. 1 do.
case. 2 do.
  }. , LF ,. dat
case. do.
  dat=. 1 1}. _1 _1}. ": < dat
  }: (,|."1 [ 1,.-. *./\"1 |."1 dat=' ')#,dat,.LF
end.
)

NB. =========================================================
NB. preserved for compatibility
getsha1=: 3 : 0
gethash 'sha1';y
)

NB. =========================================================
gethash=: 3 : 0
't m'=. y
t gethash m
:
m=. ,y
c=. '"',libjqt,'" gethash i *c *c i * *i'
'r t m w p n'=. c cd (tolower x);m;(#m);(,2);,0
res=. memr p,0,n
if. r do.
  res (13!:8) 3
end.
res
)

NB. =========================================================
NB. for isigrid control
gridindex=: 3 : 0
'rws cls sel ndx shp'=. y
d=. (sel,rws,cls) |: i.shp
r=. (sel{shp),(*/rws{shp),*/cls{shp
,(<ndx) { r ($,) d
)

NB. =========================================================
NB. for debug android standalone app
logcat=: empty @: (('"',libjqt,'" logcat n *c') cd <@,)

NB. =========================================================
NB. show wd events
NB. 0=none
NB. 1=sysevent
NB. 2=wdq
NB. 3=sysevent except mmove
NB. 4=wdq except mmove
showevents=: 3 : 0
select. {. y,1
case. 0 do.
  4!:55 <'wdhandler_debug_z_'
case. 1 do.
  wdhandler_debug_z_=: 3 : 'smoutput sysevent'
case. 2 do.
  wdhandler_debug_z_=: 3 : 'smoutput wdq'
case. 3 do.
  wdhandler_debug_z_=: 3 : 'if. -. ''_mmove''-:_6{.sysevent do. smoutput sysevent end.'
case. 4 do.
  wdhandler_debug_z_=: 3 : 'if. -. ''_mmove''-:_6{.sysevent do. smoutput wdq end.'
end.
EMPTY
)

NB. =========================================================
textview=: 3 : 0
if. 2=#p=. boxopen y do.
  p=. 1 0 1 #^:_1 p
end.
'title caption text'=. _3 {. p
wd 'textview *;',title,';',caption,';',flatten text
)

NB. =========================================================
NB. called when J is suspended
NB. first check that locale is valid
NB. wrap operation to ensure no second entry to suspension
wdhandlerx=: 3 : 0
try.
  loc=. <,y
  if. 0 <: 18!:0 loc do. wdhandler__loc'' end.
catch.
  smoutput 'error in handler for event: ',sysevent__loc
end.
EMPTY
)
