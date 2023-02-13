NB. utils

jdb_deb=: #~ (+. (1: |. (> </\)))@(' '&~:)
jdb_dlb=: }.~ =&' ' i. 0:
jdb_dtb=: #~ ([: +./\. ' '&~:)
jdb_isexplicit=: (<,':')"_ -: {.@>@(5!:1)@<
jdb_issparse=: 512&[ < 3!:0
jdb_splitind=: ('__'&E. i. 1:) ({. ; 2: }. }.) ]
jdb_takeafter=: [: ] (#@[ + E. i. 1:) }. ]
jdb_taketo=: [: ] (E. i. 1:) {. ]
jdb_tolist=: }.@;@:((10{a.)&,@,@":&.>)
jdb_toDEL=: [: ; ' "'&, @ (,&'"') &.>

jdb_boxopen=: boxopen f.
jdb_boxxopen=: boxxopen f.
jdb_empty=: empty f.
jdb_expand=: expand f.
jdb_isparent=: 0:`wdisparent@.IFQT f.
jdb_datatype=: datatype f.
jdb_getactive=: jdb_wd bind 'sm get active'
jdb_setactive=: jdb_wd @ ('sm focus '&,)
jdb_smact=: jdb_setactive @ jdb_getactive
jdb_smoutput=: 0 0&$@(1!:2&2)
jdb_wdforms=: <;._2;._2@jdb_wd@('qpx'"_)
jdb_wd1=: 0:`wd1@.IFQT f.

NB. =========================================================
jdb_dbs=: 13!:1
jdb_dbsq=: 13!:2
jdb_dbss=: 13!:3
jdb_dbsig=: 13!:8
jdb_dberm=: 13!:12
jdb_dbstk=: 13!:13
jdb_dbtrace=: 13!:16

jdb_imxq=: 9!:26        NB. imx query
jdb_imxs=: 9!:27        NB. imx set
jdb_imxsq=: 9!:28       NB. imx state query
jdb_imxss=: 9!:29       NB. imx state set

NB. =========================================================
NAMECHRS=: '_',a.{~(,(i.10)+a.i.'0'),,(i.26) +/ a.i.'Aa'
jdb_getleftsepndx=: 0: i.~ e. & NAMECHRS
jdb_getrightsepndx=: 0: i.~ e. & (NAMECHRS,'.:')

NB. =========================================================
NB.*jdb_codelines v lines of code from boxed rep
jdb_codelines=: [: I. ('NB.'&-: @ (3&{.) +: [: *./ ' '&=)&>

NB. =========================================================
jdb_cutopen=: 3 : 0
y jdb_cutopen~ (' ',LF) {~ LF e. ,y
:
if. L. y do. y return. end.
if. 1 < #$y do. <"_1 y return. end.
(<'') -.~ (y e.x) <;._2 y=. y,1{.x
)

NB. =========================================================
NB.*jdb_default v set default value
NB. name default value
NB. set global name to value if not already defined
jdb_default=: 4 : 0
if. _1 = 4!:0 <x do.
  ".x,'=: y'
end.
empty''
)

NB. =========================================================
jdb_edit=: 3 : 0
jdb_lxsoff''
jdb_stopread''
jdb_dbss''
if. 0 -: edit_z_ :: 0: y do.
  jdb_info 'Unable to open definition of ',":>y
end.
jdb_stopwrite''
jdb_lxson''
)

NB. =========================================================
NB.*flatten v flatten array to a character string
NB. flattens array to a character string with same display
jdb_flatten=: 3 : 0
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
NB. locale jdb_fullname name
NB. return: name;locale
NB. name is unqualified, unless indirect
NB. default locale is LOCALE
jdb_fullname=: 3 : 0
LOCALE jdb_fullname y
:

NB. exit if already a fullname:
if. 2=#jdb_boxopen y do. y return. end.

x=. > x
y=. > y

if. '_' = {: y do.
  ndx=. (}:y) i: '_'
  j=. (ndx+1) }. }: y
  loc=. j, (0=#j) # 'base'
  (ndx {. y) ; loc
else.
  y ; x
end.
)

NB. =========================================================
NB.*jdb_getcursorline v  get cursor line
NB. returns selection;name or '';'' if none
jdb_getcursorline=: 3 : '+/ LF = ({. 0 ". lines_select) {. lines'

NB. =========================================================
NB. get defined names from line of code:
jdb_getdefs=: (#~ _2: < 4!:0) @ ;:

NB. =========================================================
NB. following avoids problem with indirect references
NB. by accepting any such...
jdb_getdefs=: 3 : 0
y=. ;: y
if. 1 e. msk=. (1: e. '__'&E.) &> y do.
  bal=. (-.msk) # y
  msk=. (_2 < 4!:0 bal) (I. -.msk)} msk
  msk # y
else.
  y #~ _2 < 4!:0 y
end.
)

NB. =========================================================
NB.*jdb_getnameat v  selection jdb_getnameat text
NB. returns selection;name or '';'' if none
jdb_getnameat=: 4 : 0

txt=. y
sel=. x

'px py'=. sel

rtx=. |. px{.txt
rnd=. jdb_getleftsepndx rtx
beg=. |. rnd {. rtx
bps=. px - rnd
mid=. (py-px) {. px }. txt
etx=. py }. txt

end=. jdb_getrightsepndx etx
bit=. beg, mid, end {. etx

if. 0=#bit-.' ' do.
  name=. ''
else.
  wds=. ;:bit
  len=. # &> }:wds
  ndx=. 0 i.~ (#beg) >: +/\ len
  name=. ndx >@{ wds
  off=. +/ ; ndx {. len
  fnd=. 1 i.~ name E. off }. bit
  sel=. bps+off+fnd
end.

name=. jdb_validname name

if. #name do.
  hit=. {.sel
  ndx=. hit + 0, #name
  ndx;name
else.
  '';''
end.
)

NB. =========================================================
NB.*jdb_getnamesat v  selection jdb_getnamesat text
NB. returns selection;names or '';'' if none
jdb_getnamesat=: 4 : 0
'bgn end'=. x
txt=. bgn }. end {. y
nms=. jdb_getdefs txt
nms=. nms -. MNUVXY
if. #nms do.
  bgn=. bgn + 2 + txt i. ']'
  (bgn,end) ; < nms
else.
  '';''
end.
)

NB. =========================================================
NB. obsolete jdb_getstack=: (}.~ 0 i.~ 0 = [: > 1 {"1 ]) @ (13!:13)
jdb_getstack=: (}.~ ('*' i.~ [: > 8 {"1 ]))@(13!:13)

NB. =========================================================
jdb_getwincolor=: 3 : 0
NB. ???
0 0 0
)

NB. =========================================================
jdb_indices=: '['"_ , ": , '] '"_
jdb_indexit=: ([: jdb_indices &.> [: i. #) ,&.> ]

NB. =========================================================
jdb_info=: 3 : 0
'a b'=. _2 {. jdb_boxopen y
if. 0 = #a do. a=. 'Debug' end.
if. 2=#$b=. ":b do. b=. }.,LF,.b end.
f=. DEL&, @ (,&DEL) @ -.&(0 127{a.)
empty jdb_wd 'mb info ',(f a),' ',(f b)
)

NB. =========================================================
jdb_isgui=: 3 : 0
if. 0 e. $HWNDP do. 0 return. end.
f=. jdb_wdforms''
if. 0 e. $f do. 0 return. end.
(<HWNDP) e. 1{"1 f
)

NB. =========================================================
NB. list boxed array
jdb_listboxed=: }. @; @: (LF&, &.>)

NB. =========================================================
NB. list matrix:
jdb_listmatrix=: [: }. [: , LF&,.

NB. =========================================================
jdb_lxsoff=: 13!:15 @ (''"_)

cocurrent 'jdebugnopath'
copath ''  NB. no path, so we get only local names
NB. The verb z458095869 returns a table of defined local names.
NB. It is a table of (names,:(types from 4!:0))
z458095869 =: (,: <@(4!:0)) @ ((<'z458095869') -.~ 4!:1@i.@4:)
cocurrent 'jdebug'

NB. =========================================================

jdb_lxson=: 3 : 0
13!:15 '(z458095869_jdebugnopath_$0) jdb_debug_jdebug_ (coname$0)'
if. 0 = 13!:17'' do. 13!:0 [ 1 end.
i. 0 0
)

NB. =========================================================
jdb_minsize=: 3 : 0
a=. 0 ". jdb_wd 'qform'
a=. a >. 0 0,MINWIDTH,MINHEIGHT
jdb_wd 'pmove ', ": a
)

NB. =========================================================
NB. jdb_pack
jdb_pack=: [: /:~ [: (, ,&< ".) &> ;: ::]

NB. =========================================================
NB.*jdb_nextline v move to jdb_next line
NB. argument is +1 0 -1
NB. if 0, adjust MOVELINE to nearest codeline
jdb_nextline=: 3 : 0
if. 0 e. #CODELINES do. 0 return. end.
if. y=0 do.
  ((i.<./) |CODELINES - MOVELINE) { CODELINES
else.
  ndx=. CODELINES i. MOVELINE
  ndx=. 0 >. (_1 + #CODELINES) <. ndx + y
  ndx { CODELINES
end.
)

NB. =========================================================
NB. ppget get last active parent (not debug window)
jdb_ppget=: 3 : 0
h=. jdb_wd :: ] 'qhwndp'
jdb_empty HWNDPX=: (-. h-:HWNDP)#h
)

NB. =========================================================
jdb_ppset=: 3 : 0
if. #HWNDPX do. jdb_wd :: ] 'psel ', HWNDPX end.
jdb_empty''
)

NB. =========================================================
NB. form: [opt] jdb_query [title;] message
NB.   opt has two or more elements:
NB.  0 mb_ok
NB.  1 mb_cancel
NB.  2 mb_yes
NB.  3 mb_no
NB.  4 mb_save
NB.  5 mb_discard
NB. result is the numeric value of button (not positional index!)
jdb_query=: 3 : 0
0 3 wdquery y
:
msg=. ' mb_'&,&.> res=. ;:'ok cancel yes no save discard'
t=. x [ 'a b'=. _2{. boxopen y
if. 2=#$b=. ":b do. b=. }.,LF,.b end.
f=. 8 u: DEL&, @ (,&DEL) @ -.&(0 127{a.)
m=. 'mb query', (;t{msg), ' ', (f a),' ',(f b)
res i. <jdb_wd m
)

NB. =========================================================
NB. jdb_selstack v select name from stack
jdb_selstack=: 3 : 0
a=. 2 }. jdb_dbstk''
if. 0=#a do. return. end.
b=. ({."1 a) i. jdb_boxopen y
if. b=#a do. return. end.
b { a
)

NB. =========================================================
NB. jdb_shortname name
NB. returns: name with no locale reference
jdb_shortname=: 3 : 0
if. '_' = {: y do.
  y {.~ (}:y) i: '_'
else.
  y
end.
)

NB. =========================================================
NB. check we have a valid name, else return jdb_empty
jdb_validname=: 3 : 0
if. 0=#y do. '' return. end.
if. 1 e. b=. '__' E. }: y do.
  if. 1 ~: +/b do.
    '' return.
  else.
    ndx=. I. b
  end.
  if. _2 e. 4!:0 (ndx{.y);(ndx+2)}.y do.
    ''
  else.
    y
  end.
else.
  if. _2 = 4!:0 <y do.
    ''
  else.
    y
  end.
end.
)

NB. =========================================================
jdb_wd=: 3 : 0"1
'r c l p n'=. jdb_wd1 (,y);(#,y);(,2);(,0)
select. r
case. 0 do.
  EMPTY
case. _1 do.
  (15!:1) p,0,n
case. _2 do.
  _2 [\ <;._2 (15!:1) p,0,n
case. do.
  (jdb_wd ::(''"_) 'qer') (13!:8) 3
end.
)
