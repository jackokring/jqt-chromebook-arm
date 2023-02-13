NB. winlib

cocurrent IFQT{'jqtide';'z'

NB. =========================================================
NB. *wd v           main window driver
wd=: 3 : 0"1
'r c l p n'=. wd1 (,y);(#,y);(,2);(,0)
select. r
case. 0 do.
  EMPTY
case. _1 do.
  memr p,0,n
case. _2 do.
  _2 [\ <;._2 memr p,0,n
case. do.
NB. echo all errors
  (LF,~wd ::(''"_)'qer') (13!:8) 3
end.
)

wd1=: ('"',libjqt,'" wd ', (IFWIN#'+'),' i *c i *x *i') & cd f.

NB. =========================================================
NB.*wdhandler v wd handler
NB. runs in form locale
NB. sets global event data: wdq
NB. runs first found of: form_handler, form_event, form_default,
NB. with global event variables from wdq
NB. if debug is off, wraps event handler in try. catch.
NB. catch exits if error message is the last picked up by debug.
wdhandler_0=: 3 : 0
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
      wd_err=. LF,,LF,.(}.^:('|'e.~{.));._2 ,&LF^:(LF~:{:) wd_err
      wdinfo 'wdhandler';'error in: ',wd_fn,wd_err
    end.
  end.
end.
i.0 0
)

NB. =========================================================
NB. wdhandler - exactly like the system handler except the value returned from wd_fn is passed through in debug
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
      wd_err=. LF,,LF,.(}.^:('|'e.~{.));._2 ,&LF^:(LF~:{:) wd_err
      wdinfo 'wdhandler';'error in: ',wd_fn,wd_err
    end.
  i.0 0
  end.
else. i. 0 0
end.
)

NB. =========================================================
NB. called when J is suspended
NB. first checks that locale is valid
wdhandlerx=: 3 : 0
loc=. <,y
if. 0 <: 18!:0 loc do.
  wdhandler__loc''
else.
  msg=. 'no locale for event handler: ',>loc
  if. #wdq=. wd 'q' do.
    msg=. msg, ', event: ',(<1 1) pick wdq
  end.
  smoutput msg
end.
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
wdqprinters=: (wd bind 'qprinters') :: (''"_)
wdqpx=: (wd bind 'qpx') :: (''"_)
wdqscreen=: (0 ". wd bind 'qscreen') :: (264 211 800 600 96 96 32 1 _1 36 36 51"_)
wdqwd=: (wd bind 'qwd') :: ('jqt'"_)

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
NB.  1 handle
NB.  2 locale
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
NB.   opt has two or more elements:
NB.  0 mb_ok
NB.  1 mb_cancel
NB.  2 mb_yes
NB.  3 mb_no
NB.  4 mb_save
NB.  5 mb_discard
NB. result is the numeric value of button (not positional index!)
wdquery=: 3 : 0
0 3 wdquery y
:
msg=. ' mb_'&,&.> res=. ;:'ok cancel yes no save discard'
t=. x [ 'a b'=. _2{. boxopen y
if. 2=#$b=. ":b do. b=. }.,LF,.b end.
f=. 8 u: DEL&, @ (,&DEL) @ -.&(0 127{a.)
m=. 'mb query', (;t{msg), ' ', (f a),' ',(f b)
res i. <wd m
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
