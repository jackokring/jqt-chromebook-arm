NB. win

onStart=: nk_run1

NK=: 0 : 0
pc nk;pn "Nurikabe";
menupop "File";
menu newboard "&New..." "Ctrl+N" "" "";
menusep;
menu openboard "&Open..." "Ctrl+O" "" "";
menusep ;
menu saveboard "Save" "Ctrl+S" "" "";
menu saveboardas "Save &As..." "" "" "";
menusep;
menu exit "Exit" "" "" "";
menupopz;
menupop "Demos";
menu board1 "&Board1 5x5" "" "" "";
menu board2 "&Board2 5x5" "" "" "";
menu board3 "&Board3 5x5" "" "" "";
menu board4 "&Board4 5x5" "" "" "";
menu board5 "&Board5 5x5" "" "" "";
menusep;
menu board6 "&Board6 9x9" "" "" "";
menu board7 "&Board7 9x9" "" "" "";
menusep;
menu board8 "&Board8 10x10" "" "" "";
menusep;
menu board9 "&Board9 10x18" "" "" "";
menupopz;
menupop "Help";
menu about "&About" "" "" "";
menusep;
menu helpnew "&New Board" "" "" "";
menupopz;
bin vh;
cc restart button;cn "Restart";
cc undo button;cn "Undo";
cc redo button;cn "Redo";
cc hint button;cn "Hint";
cc check button;cn "Check";
cc editcancel button;cn "Cancel";
cc editok button;cn "Accept";
bin z;
cc g isigraph flush;
bin z;
pas 0 0;pcenter;
rem form end;
)

NKJA=: 0 : 0
pc nk;pn "Nurikabe";
menupop "File";
menu newboard "&New..." "Ctrl+N" "" "";
menusep;
menu openboard "&Open..." "Ctrl+O" "" "";
menusep ;
menu saveboard "Save" "Ctrl+S" "" "";
menu saveboardas "Save &As..." "" "" "";
menusep;
menu exit "Exit" "" "" "";
menupopz;
menupop "Demos";
menu board1 "&Board1 5x5" "" "" "";
menu board2 "&Board2 5x5" "" "" "";
menu board3 "&Board3 5x5" "" "" "";
menu board4 "&Board4 5x5" "" "" "";
menu board5 "&Board5 5x5" "" "" "";
menusep;
menu board6 "&Board6 9x9" "" "" "";
menu board7 "&Board7 9x9" "" "" "";
menusep;
menu board8 "&Board8 10x10" "" "" "";
menusep;
menu board9 "&Board9 10x18" "" "" "";
menupopz;
menupop "Help";
menu about "&About" "" "" "";
menusep;
menu helpnew "&New Board" "" "" "";
menupopz;
bin vh;
cc restart button;cn "Restart";
cc undo button;cn "Undo";
cc redo button;cn "Redo";
cc hint button;cn "Hint";
cc check button;cn "Check";
cc editcancel button;cn "Cancel";
cc editok button;cn "Accept";
bin z;
wh _1 _1;cc g isigraph flush;
bin z;
pas 0 0;pcenter;
rem form end;
)

NB. =========================================================
nk_run1=: 3 : 0
if. IFJA do. y=. yy end.
bufinit''
DONE=: 0
HIGH=: _1
if. HWNDP=0 do.
  wd NK
  HWNDP=: wdqhwndp''
end.
drawsetedit {.y,0
nk_fit''
nk_name''
NB. drawit''
wd 'setfocus g'
wd 'pshow;'
glpaint''
)

NB. =========================================================
nk_check_button=: 3 : 0
if. DONE=: checkdone 1 do.
  BOARD=: BOARD >. _1
  draw''
else.
  unfinished''
end.
)

NB. =========================================================
nk_close=: 3 : 0
wd 'set g enable 0'
wd 'pclose'
codestroy''
)

NB. =========================================================
NB. try to fit in part of available screen
NB. if edge is > 10, scale up to near full screen
nk_fit=: 3 : 0
formx=. wdqform''
gx=. wdqchildxywh 'g'
swh=. 2 {. wdqm''
cr=. |. SHAPE
if. *./ 10 >: cr do.
  siz=. cr * <./ <. 0.5 * swh % cr
else.
  siz=. cr * (<./ <. 0.5 * swh % 10) <. <./ <. 0.85 * swh % cr
end.
wd 'set g minwh ',": siz
wd 'pcenter'
)

NB. =========================================================
nk_g_paint=: drawit

NB. =========================================================
nk_name=: 3 : 0
name=. NAME,(0<#NAME)#' '
if. #FILE do.
  file=. ' ',1 pick pathname FILE
else.
  file=. ''
end.
wd 'pn *Nurikabe ',name,(}.;'x'&,each ":each SHAPE),file
)

NB. NB. =========================================================
NB. nk_hint_button=: 3 : 0
NB. board=. ,heuristics SHAPE$BOARD
NB. ndx=. I. board ~: BOARD
NB. if. #ndx do.
NB.   ndx=. (?@# { ]) ndx
NB.   BOARD=: (ndx{board) ndx} BOARD
NB.   buffer''
NB.   draw''
NB. else.
NB.   info 'No hint available.'
NB. end.
NB. )

NB. =========================================================
nk_hint_button=: 3 : 0
sel=. hint SHAPE$BOARD
if. #sel do.
  BOARD=: (2{sel) (<SHAPE #. 2{.sel)} BOARD
  buffer''
  draw''
else.
  info 'No hint available.'
end.
)

NB. =========================================================
nk_redo_button=: 3 : 0
BUFPOS=: (<:#BUF) <. >: BUFPOS
BOARD=: BUFPOS pick BUF
draw''
)

NB. =========================================================
nk_restart_button=: 3 : 0
if. 0 = query 'OK to restart?' do.
  BOARD=: 0 pick BUF
  bufinit ''
  draw''
end.
)

NB. =========================================================
nk_solve_button=: 3 : 0
BOARD=: ,bfh SHAPE$BOARD
DONE=: 2
draw''
)

NB. =========================================================
nk_undo_button=: 3 : 0
BUFPOS=: 0 >. <: BUFPOS
BOARD=: BUFPOS pick BUF
draw''
)

NB. =========================================================
nk_default=: 3 : 0
if. 'board' -: 5 {. syschild do.
  demoboard 5 }. syschild
end.
)

NB. =========================================================
nk_g_char=: char
nk_g_paint=: drawit
nk_g_mmove=: mmove
nk_g_mbldown=: mbldown
nk_g_mbldbl=: mbldbl

NB. =========================================================
nk_about_button=: 3 : 'info ABOUT'
nk_helpnew_button=: 3 : 'info NEWBOARD'
nk_editcancel_button=: newboardcancel
nk_editok_button=: newboardok
nk_exit_button=: nk_close
nk_openboard_button=: openboard
nk_newboard_button=: newboard
nk_saveboard_button=: saveboard
nk_saveboardas_button=: saveboardas
nk_nctrl_fkey=: newboard
nk_octrl_fkey=: openboard
nk_sctrl_fkey=: saveboard
