NB. toolbar definitions

NB. =========================================================
NB. toolbar enable
NB. main, stop, watch, none
j=. 0 : 0
run       1 0 0 0
stepinto  1 0 0 0
stepover  1 0 0 0
stepout   1 0 0 0
runcursor 1 0 0 0
cutback   1 0 0 0
back      1 0 0 0
refresh   1 0 0 0
forward   1 0 0 0
stopname  1 1 0 0
stopwin   1 1 1 1
watchwin  1 1 0 1
stack     1 1 1 1
dissectcurrent 1 1 0 0
dissecttoggleauto 1 1 1 1
clear     1 1 1 0
)

f=. (1 + i.&' ') ({.;".@}.) ]
j=. f ;._2 j
nms=. ';set tbar enable '&, &.> {."1 j
nms1=. jdb_deb &.> {."1 j
vls=. >{:"1 j

a=. }.;nms (,":) &.> 0 {"1 vls
b=. }.;nms (,":) &.> 1 {"1 vls
c=. }.;nms (,":) &.> 2 {"1 vls
d=. }.;nms (,":) &.> 3 {"1 vls
TBENABLE=: a;b;c;d

a=. <nms1 ,. <("0) 0 {"1 vls
b=. <nms1 ,. <("0) 1 {"1 vls
c=. <nms1 ,. <("0) 2 {"1 vls
d=. <nms1 ,. <("0) 3 {"1 vls
TBENABLE1=: a,b,c,d

NB. =========================================================
jdb_tabcurrent=: 3 : 'TABGROUPS i. <TABCURRENT'

NB. =========================================================
jdb_tbenable=: 3 : 0
jdb_wd (jdb_tabcurrent'') >@{ TBENABLE
)

NB. =========================================================
jdebug_back_button=: 3 : 0
MOVELINE=: jdb_nextline _1
jdb_lexwin''
)

NB. =========================================================
jdebug_clear_button=: 3 : 0
jdb_clear''
)

NB. =========================================================
jdebug_cutback_run=: 3 : 0
jdb_restore''
13!:19 ''
)

NB. =========================================================
jdebug_forward_button=: 3 : 0
MOVELINE=: jdb_nextline 1
jdb_lexwin''
)

NB. =========================================================
jdebug_help_button=: 3 : 0
jdb_lxsoff''
jdb_stopread''
jdb_dbss''
if. 0 -: htmlhelp_j_ :: 0: 'user/debugs.htm' do.
  jdb_info 'Unable to access debug help'
end.
jdb_stopwrite''
jdb_lxson''
)

NB. =========================================================
jdebug_stack_button=: 3 : 0
stk=. 2}.13!:13''
if. 0 e. $stk do.
  jdb_info 'Nothing on the stack' return.
end.
hdr=. ;:'name en ln nc args locals susp'
stk=. 1 1 1 1 0 0 1 1 1 #"1 stk
stk=. hdr, ": &.> stk
wds=. ({:@$@":@,.)"1 |: stk
len=. 40 >.<.-: 120 - +/8, 4 {. wds
tc=. (len+1)&<.@$ {.!.'.' ({.~ len&<.@$)
r=. tc@": &.> stk
r=. ,(":r),.LF
s=. {:a.
jdb_wd 'textview *',s,'stack',s,s,r
)

NB. =========================================================
jdebug_refresh_button=: 3 : 0
MOVELINE=: CURRENTLINE
jdb_lexwin''
)

NB. =========================================================
jdebug_run_run=: 3 : 0
jdb_restore''
if. MOVELINE=CURRENTLINE do.
  13!:4 ''
else.
  13!:7 MOVELINE
end.
)

NB. =========================================================
NB. runcursor cF10
jdebug_runcursor_run=: 3 : 0
line=. jdb_getcursorline''
if. line <: CURRENTLINE do.
  jdb_info 'Line selected should be after current line' return.
elseif. line > >./ CODELINES do.
  jdb_info 'Cannot stop on selected line' return.
end.
jdb_restore''
names=. {."1 STACK
CUTNAMES=: LOCALE jdb_addlocale &.> names
CUTLINES=: ; 2 {"1 STACK
0 jdb_stopsetline CURRENTLINE + i. line - CURRENTLINE
1 jdb_stopsetline line
jdb_restore''
13!:4''
)

NB. =========================================================
jdebug_dissectcurrent_run=: 3 : 0
NB. y is empty for user click; for autodissect, it has the line # to dissect
if. DISSECTSTATUS ~: 1 do. DISSECTSTATUS =: dissectchecklevel 1 end.
select. DISSECTSTATUS
case. 0 do.
  wdinfo 'Out-of-date addon';'The addon, debug/dissect, is out of date.  Use Tools|Package Manager to update it.'
  empty''
case. _1 do.
  wdinfo 'Dissect Current/Cursor Line';'This feature requires the debug/dissect addon.  Use Tools|Package Manager to install the addon.'
  empty''
case. do.
  if. 0 = #line =. y do.
    if. 0 = #line=. jdb_getcursorline'' do.
      line =, CURRENTLINE
    end.
  end.
  NB. If dissect options have been set for this line, collect them
  dissectopts =. 12 14 {~ *#y
  if. #dos =. (((NAME;LOCALE,<VALENCE) -:"1 (1 2 3)&{"1) # 0 4&{"1) DISSECTOPTIONS do.
    if. #dos =. (#~    line e.&> {:"1) dos do.
      NB. Handle the 'auto' option.  'auto 0' supresses autodissect for the line
      dopts =. ; {."1 dos
      if. +./ amsk =. (<'auto') = {."1 dopts do.
        NB. 'auto' found.  See if 'auto 0' is.  Convert atomic '0' to list for comparison
        if. (*#y) *. (+./ ('auto';'0') -:&:(,&.>)"1 amsk # dopts) do.
          NB. 'auto 0' in autodissect.  Clear dissectopts as a flag to suppress the autodissect
          dissectopts =. dopts =. ''
        else.
          dopts =. (-. amsk) # dopts
        end.
      end.
      if. #dopts do. dissectopts =. dissectopts ;< dopts end.  NB. Leave dissectopts empty if auto suppressed 
    end.
  end.
  NB. Set up to run the user's line, with or without dissect
  jdb_restore (*#dissectopts) # (line { LINES) , <dissectopts
end.
)

NB. =========================================================
NB. If y given, use that value (may be called outside of form event)
jdebug_dissecttoggleauto_run=: 3 : 0
if. DISSECTSTATUS ~: 1 do. DISSECTSTATUS =: dissectchecklevel 1 end.
select. DISSECTSTATUS
case. 0 do.
  wdinfo 'Out-of-date addon';'The addon, debug/dissect, is out of date.  Use Tools|Package Manager to update it.'
case. _1 do.
  wdinfo 'Toggle Autodissect';'This feature requires the debug/dissect addon.  Use Tools|Package Manager to install the addon.'
case. do.
  if. #y do.
    wd 'psel jdebug'
    AUTODISSECT =: y
  else.
    AUTODISSECT =: -. AUTODISSECT
  end.
end.
wd 'set tbar checked dissecttoggleauto ' , ": AUTODISSECT
empty''
)
NB. =========================================================
jdebug_stepout_run=: 3 : 0
jdb_restore''
if. MOVELINE=CURRENTLINE do.
  13!:22 ''
else.
  MOVELINE 13!:22 ''
end.
)

NB. =========================================================
jdebug_stepover_run=: 3 : 0
jdb_restore''
if. MOVELINE=CURRENTLINE do.
  13!:20 ''
else.
  MOVELINE 13!:20 ''
end.
)

NB. =========================================================
jdebug_stepinto_run=: 3 : 0
jdb_restore''
if. MOVELINE=CURRENTLINE do.
  13!:21 ''
else.
  MOVELINE 13!:21 ''
end.
)

NB. =========================================================
jdebug_main=: 3 : 0
if. jdb_inactive'' do.
  jdb_swap 'jdbnone'
else.
  jdb_swap 'jdbmain'
  if. #jdb_getstack'' do.
    jdb_lexwin''
  end.
end.
jdb_lxson''
)

NB. =========================================================
jdebug_watchwin_button=: 3 : 0
jdb_lxsoff''
jdb_swap 'jdbwatch'
jdb_lxson''
)

NB. =========================================================
jdebug_mainwin=: 3 : 0
if. jdb_inactive'' do.
  jdb_swap 'jdbnone'
else.
  jdb_swap 'jdbmain'
  if. #jdb_getstack'' do.
    jdb_lexwin''
  end.
end.
jdb_lxson''
)

NB. =========================================================
NB. other toolbar handlers:
jdebug_stopline_button=: 3 : '(TABCURRENT,''_stopline_button'')~0'
jdebug_stopname_button=: 3 : '(TABCURRENT,''_stopname_button'')~0'
jdebug_stopwin_button=: 3 : '(TABCURRENT,''_stopwin_button'')~0'

NB. =========================================================
jdebug_stepover_button=: immexj bind 'jdebug_stepover_run_jdebug_$0'
jdebug_stepinto_button=: immexj bind 'jdebug_stepinto_run_jdebug_$0'
jdebug_stepout_button=: immexj bind 'jdebug_stepout_run_jdebug_$0'
jdebug_cutback_button=: immexj bind 'jdebug_cutback_run_jdebug_$0'
jdebug_runcursor_button=: immexj bind 'jdebug_runcursor_run_jdebug_$0'
jdebug_run_button=: immexj bind 'jdebug_run_run_jdebug_$0'
jdebug_dissectcurrent_button=: immexj bind 'jdebug_dissectcurrent_run_jdebug_$0'
jdebug_dissecttoggleauto_button=: immexj bind 'jdebug_dissecttoggleauto_run_jdebug_$0'
jdebug_jctrl_fkey=: immexj bind 'labrun_jlab_$0'
