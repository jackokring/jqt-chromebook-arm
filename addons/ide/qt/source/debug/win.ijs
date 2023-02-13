NB. debug win

TABGROUPS=: ;: 'jdbmain jdbstop jdbwatch'

NB. DISSECTSTATUS: _1 = not installed or not used; 0 = installed but downlevel; 1 = ready to use
NB. If x is 1, we try loading dissect first, in case the user updated it
NB. recently
DISSECTSTATUS =: (dissectchecklevel =: 4 : 0&(4 0)) 0  NB. The number in parentheses is the required level for dissect
if. -. IFDISSECT do. _1 return. end.
NB. We check the dissect status the first time debug is loaded
if. x +. 0 > 4!:0 <'dissect_dissect_' do.
  NB. dissect not defined or downlevel, try loading it
  if. fexist getscripts_j_ 'debug/dissect' do.
    load 'debug/dissect'
  end.
end.
if. 3 = 4!:0 <'dissect_dissect_' do.
  NB. dissect now defined, see if it is up to level
  if. 0 ~: {. /: y ,: ". 'DISSECTLEVEL_dissect_' do.  NB. ". to handle early versions that had no level
    0
  else. 1
  end.
else. _1
end.
)
DTTCURR =. DTTTOGGLE =. 'These functions are defined in the debug/dissect addon, use Package Manager to get it'
DTTCURR =. 'Dissect current/cursor line' [^:(DISSECTSTATUS=1) DTTCURR
DTTTOGGLE =. 'Automatically dissect on stop' [^:(DISSECTSTATUS=1) DTTTOGGLE

DTTTBAR=: IFDISSECT # 0 : 0 rplc 'DTTCURR';DTTCURR;'DTTTOGGLE';DTTTOGGLE
set tbar add dissectcurrent "DTTCURR" "DEBUGPATH/dissect-current.png";
set tbar add dissecttoggleauto "DTTTOGGLE" "DEBUGPATH/dissect-toggle.png";
set tbar checkable dissecttoggleauto;
set tbar addsep;
)

NB. =========================================================
JDEBUG=: (0 : 0 rplc 'DTTTBAR';DTTTBAR) rplc 'DEBUGPATH';(jpath '~addons/ide/qt/images')
pc jdebug escclose ptop;pn "Debug - Ctrl+H help";
cc tbar toolbar 22x22 flush;
set tbar add run "Run" "DEBUGPATH/run.png";
set tbar addsep;
set tbar add stepinto "Step into" "DEBUGPATH/stepinto.png";
set tbar add stepover "Step over" "DEBUGPATH/stepover.png";
set tbar add stepout "Step out" "DEBUGPATH/stepout.png";
set tbar addsep;
set tbar add runcursor "Run to cursor" "DEBUGPATH/runcursor.png";
set tbar add cutback "Cut back" "DEBUGPATH/cutback.png";
set tbar addsep;
set tbar add back "Back" "DEBUGPATH/goback.png";
set tbar add refresh "Refresh" "DEBUGPATH/refresh.png";
set tbar add forward "Forward" "DEBUGPATH/goforward.png";
set tbar addsep;
set tbar add stopname "Stop name at cursor" "DEBUGPATH/stopname.png";
set tbar add stopwin "Stop Manager" "DEBUGPATH/stopmanager.png";
set tbar add watchwin "Watch Manager" "DEBUGPATH/watchmanager.png";
set tbar add stack "View stack" "DEBUGPATH/stack.png";
set tbar addsep;
DTTTBAR
set tbar add clear "Clear" "DEBUGPATH/clear.png";
)

NB. =========================================================
JDEBUGP=: 0 : 0
minwh 540 400;
cc tabs tab nobar;
tabnew jdbmain;
splitv;
cc lines editm readonly selectable;
set lines font fixfont;
splitsep;
splitv;
cc stack editm readonly;
set stack font fixfont;
splitsep;
cc value editm readonly;
set value font fixfont;
splitend;
splitend;
tabnew jdbstop;
bin m8h;
cc stopline button;cn "Stop Line";
cc stopall button;cn "Stop All";
bin s;
cc syslocs checkbox;cn "Show all locales";
cc stopclose button;cn "Close";
bin zhv;
cc s0 static;cn "Name:";
cc name combobox;
bin zv;
cc s1 static;cn "In:";
cc locs combobox;
bin zz;
cc slines editm readonly selectable;
set slines font fixfont;
tabnew jdbwatch;
bin m8hv;
cc s1 static; cn "Enter Watch Names:";
cc wlist editm;
set wlist font fixfont;
bin zvs1;
cc watchclear button;cn "Clear";
cc watchclose button;cn "Close";
bin s10zz;
tabend;
)

NB. =========================================================
NB. y=1 run main, else none
jdebug_run=: 3 : 0
jdb_swap > (y-:1) { 'jdbnone';'jdbmain'
)

NB. =========================================================
NB. clear stops
jdebug_clearstops=: 3 : 0
STOPS=: 0#STOPS
jdb_lxsoff''
jdb_dbss''
jdb_lexwin''
jdb_lxson''
)

NB. =========================================================
NB. runnext csF5
jdebug_runnext=: 3 : 0
jdb_restore''
if. MOVELINE=CURRENTLINE do.
  13!:5 ''
else.
  13!:7 MOVELINE
end.
)

NB. =========================================================
jdebug_hctrl_fkey=: 3 : 0
jdb_info 'Debug Shortcuts';SHORTCUTS
)

NB. =========================================================
jdebug_resize=: 3 : 0
if. #ACTIVE do.
  echo i.0 0
  jdb_setactive ACTIVE
  ACTIVE=: ''
end.
)

NB. =========================================================
jdebug_tctrl_fkey=: 3 : 0
jdb_lxsoff''
PTOP=: -. PTOP
jdb_wd 'psel ',HWNDP,';ptop ',":PTOP
jdb_lxson''
)

NB. =========================================================
jdebug_wctrl_fkey=: 3 : 0
jdb_lxsoff''
jdb_setactive 'term'
wd 'sm prompt *   ',jdb_dlb MOVELINE >@{ LINES
jdb_lxson''
)

NB. =========================================================
jdebug_cancel=: jdebug_close=: jdb_close

jdebug_enter=: ]
