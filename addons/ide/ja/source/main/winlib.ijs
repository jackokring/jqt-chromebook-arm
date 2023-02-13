NB. standard windows library
NB.
NB. These definitions are assumed available to other windows programs

18!:4 IFJA{'ja';'z'

NB. =========================================================
NB. *wd v           main window driver
wd=: 11!:0

NB. =========================================================
NB.*wdhandler v wd handler
NB. runs in form locale
NB. sets global event data: wdq
NB. runs first found of: form_handler, form_event, form_default,
NB. with global event variables from wdq
NB. if debug is off, wraps event handler in try. catch.
NB. catch exits if error message is the last picked up by debug.
wdhandler=: 3 : 0
wdq=: wd 'q'
wd_val=. {:"1 wdq
({."1 wdq)=: wd_val
if. 3=4!:0<'wdhandler_debug' do.
  try. wdhandler_debug'' catch. end.
end.
wd_ndx=. 1 i.~ 3 = 4!:0 [ 3 {. wd_val
if. 3 > wd_ndx do.
  wd_fn=. > wd_ndx { wd_val
  if. 13!:17'' do.
    wd_fn~''
  else.
    try. wd_fn~''
    catch.
      wd_err=. 13!:12''
      if. 0=4!:0 <'ERM_j_' do.
        wd_erm=. ERM_j_
        ERM_j_=: ''
        if. wd_erm -: wd_err do. i.0 0 return. end.
      end.
      wd_err=. LF,,LF,.(}.^:(':|'e.~{.));._2 LF,~ wd_err
      wdinfo 'wdhandler';'error in: ',wd_fn,wd_err
    end.
  end.
end.
i.0 0
)

NB. cover verbs for wd query cmds
wdclippaste=: (wd bind 'clippaste') :: (''"_)
wdqq=: (wd bind 'q') :: (''"_)
wdqchildxywh=: (0 ". [: wd 'qchildxywh ' , ]) :: (0 0 0 0"_)
wdqcolor=: (0 ". [: wd 'qcolor ' , ":) :: ( 0 0 0"_)
wdqd=: (wd bind 'qd') :: (''"_)
wdqer=: (wd bind 'qer') :: (''"_)
wdqform=: (0 ". wd bind 'qform') :: (0 0 800 600"_)
wdqhinst=: (0 ". wd bind 'qhinst') :: 0:
wdqhwndc=: (0 ". [: wd 'qhwndc ' , ]) :: 0:
wdqhwndp=: (0 ". wd bind 'qhwndp') :: 0:
wdqhwndx=: (0 ". wd bind 'qhwndx') :: 0:
wdqm=: (0 ". wd bind 'qm') :: (800 600 8 16 1 1 3 3 4 4 19 19 0 0 800 570"_)
wdqp=: (wd bind 'qp') :: (''"_)
wdqpx=: (wd bind 'qpx') :: (''"_)
wdqscreen=: (0 ". wd bind 'qscreen') :: (264 211 800 600 96 96 32 1 _1 36 36 51"_)
wdqwd=: (wd bind 'qwd')

NB. =========================================================
NB. These definitions are assumed available to other windows programs

NB. wdcenter      center form on another
NB. wdfit         ensure form fits in window
NB. wdforms       wd form info
NB. wdget         get values from matrix, e.g. wd'q'
NB. wdhandler     wd handler
NB. wdinfo        information box
NB. wdishandle    if a form handle
NB. wdisparent    if a parent window
NB. wdpclose      close parent window
NB. wdquery       query box
NB. wdreset       reset window driver
NB. mbopen        cover verb for jpathsep wd mbopen
NB. mbsave        cover verb for jpathsep wd mbsave

wdcenter=: 0:
wdfit=: 0:

wdreset=: wd bind 'reset'

NB. =========================================================
NB.*wdforms v info about all forms
NB.
NB. columns are:
NB.  0 name
NB. 1 HANDLE
NB. 2 LOCALE
NB.
NB. e.g.
NB.    wdforms''
NB. +-----------+---+--------+
NB. |jijs       |100|0       |
NB. +-----------+---+--------+
NB. |projectform|102|jproject|
NB. +-----------+---+--------+
NB. |jijs       |198|1       |
NB. +-----------+---+--------+
wdforms=: <;._2;._2 @ wd bind 'qpx'

NB. =========================================================
NB.*wdisparent v return 1 if a parent window
wdisparent=: (boxopen e. 0: {"1 wdforms) ::0:

NB. =========================================================
NB.*wdishandle v return 1 if a window handle
wdishandle=: (boxopen e. 1: {"1 wdforms) ::0:

NB. =========================================================
NB.*wdinfo v information box
NB. syntax: wdinfo [title;] message
wdinfo=: 3 : 0
'a b'=. _2{. boxopen y
if. 2=#$b=. ":b do. b=. }.,LF,.b end.
f=. 8 u: DEL&, @ (,&DEL) @ -.&(0 127{a.)
empty wd 'mb info ',(f a),' ',(f b)
)

NB. =========================================================
NB.*wdquery v query box
NB. form: [opt] wdquery [title;] message
NB.   opt has atmost 3 elements
wdquery=: 3 : 0
'yes no' wdquery y
:
t=. x [ 'a b'=. _2{. boxopen y
if. 32~:(3!:0) t do. t=. ;:t end.
t=. DEL&, @ (,&DEL) &.>t
if. 2=#$b=. ":b do. b=. }.,LF,.b end.
f=. 8 u: DEL&, @ (,&DEL) @ -.&(0 127{a.)
m=. 'mb query dialog ',(f a),' ',(f b),' ', ;x
wd m
)

NB. =========================================================
NB. mbopen        cover verb for jpathsep wd mbopen
mbopen=: 3 : 0
jpathsep wd 8 u: 'mb open1 ',y
)

NB. =========================================================
NB. mbsave        cover verb for jpathsep wd mbsave
mbsave=: 3 : 0
jpathsep wd 8 u: 'mb save ',y
)

NB. android_exec_host=: ('"',libjqt,'" android_exec_host >n *c *c *c i')&cd

NB. =========================================================
NB.*wdget v get values from matrix, e.g. wd'q'
NB. utility to index 2-column boxed array, e.g. result of wd 'q'
NB. form:  names wdget data
NB. returns items in second column indexed on names in first column
NB. result is boxed if left argument is boxed
NB. e.g. 'sysfocus' wdget wdq
wdget=: 4 : 0
nms=. {."1 y
vls=. {:"1 y
if. L. x do. vls {~ nms i. ,&.>x
else. > vls {~ nms i. <,x
end.
)

wdpclose=: [: wd :: empty 'psel ' , ';pclose' ,~ ":

NB. =========================================================
immexj_ja_=: [: wd 'immexj *'&,

NB. =========================================================
NB. websocket interface (reserved)
wbsk_ja_=: 11!:3050

NB. =========================================================
NB. reading file images to argb matrix
NB. y image file name
readimg_ja_=: 11!:3000

NB. =========================================================
NB. reading file images from memory to argb matrix
NB. y raw image data
getimg_ja_=: 11!:3001

NB. =========================================================
NB. writing argb matrix to file
NB. y data ; filename ; format ; quality
NB. format (case-insensitive) Jpeg Png
NB. optional quality requires 1 integer
writeimg_ja_=: 11!:3002

NB. =========================================================
NB. writing argb matrix to memory
NB. y data ; format ; quality
NB. format (case-insensitive) Jpeg Png
NB. optional quality requires 1 integer
putimg_ja_=: 11!:3003

NB. =========================================================
NB. clipboard image
clippasteimg_ja_=: 11!:3004
clipcopyimg_ja_=: 11!:3005

NB. =========================================================
NB. cryptography
gethash_ja_=: 11!:3100
getripemd160_ja_=: 11!:3101
getmd4_ja_=: 11!:3103
getmd5_ja_=: 11!:3104
getsha1_ja_=: 11!:3105
getsha224_ja_=: 11!:3106
getsha256_ja_=: 11!:3107
getsha384_ja_=: 11!:3108
getsha512_ja_=: 11!:3109
getsha3_224_ja_=: 11!:3110
getsha3_256_ja_=: 11!:3111
getsha3_384_ja_=: 11!:3112
getsha3_512_ja_=: 11!:3113

NB. other

3 : 0 IFJA

dirmatch=: 3 : 'wd ''dirmatch '', ; dquote&.> 2 {. boxopen y'
open=: 3 : 'wd ''openj *'' , > {. getscripts_j_ y'
smact=: wd bind 'smact'
immexj_z_=: immexj_ja_
wbsk_z_=: wbsk_ja_

getsha1_z_=: getsha1_ja_
gethash_z_=: gethash_ja_
textview_z_=: textview_ja_

EMPTY
)
