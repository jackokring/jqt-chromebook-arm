NB. win

OFFX=: 70
OFFY=: 0
BUTTONS=: 0$<''

NB. =========================================================
PS=: 0 : 0
pc ps closeok nosize;pn "Pousse";
menupop "Options";
menu new "&New Game" "Ctrl+N" "" "";
menupop "New_Game_Size";
menu sz3 "&3" "" "" "";
menu sz4 "&4" "" "" "";
menu sz5 "&5" "" "" "";
menu sz6 "&6" "" "" "";
menu sz7 "&7" "" "" "";
menu sz8 "&8" "" "" "";
menupopz;
menusep ;
menu undo "&Undo" "Ctrl+U" "" "";
menusep ;
menu auto "&Auto Green Move" "" "" "";
menusep ;
menu two "&Two Player" "" "" "";
menusep ;
menu exit "E&xit" "" "" "";
menupopz;
menupop "Help";
menu instructions "&Instructions" "" "" "";
menusep ;
menu about "&About" "" "" "";
menupopz;
bin hvh;
cc s1 static;cn "Red";
cc s2 static;cn "Green";
bin z;
minwh 102 120;cc log editm readonly;
bin z;
pas 0 0;
rem form end;
)

NB. =========================================================
ps_run=: ''&$: : (4 : 0)
ps=. PS rplc 'New_Game_Size';'New Game Size'
if. 0=#BUTTONS do.
  wd ps
  wd 'setfont log ',FIXFONT
end.
defgridbuttons''
writemenu''
wd 'pas 0 0'
wd 'pshow hide'
if. #x do. wdcenter x
else. wd 'pcenter' end.
if. IFJA do.
  button_enable (4*SIZE)#1
  IFGREENMOVE=: 0
  SEQ=: ''
  run ":SIZE
else.
  ps_new_button''
end.
wd 'pshow;'
)

NB. =========================================================
ps_about_button=: 3 : 0
wdview 'About';(topara ABOUT)
)

NB. =========================================================
ps_auto_button=: 3 : 0
IFAUTO=: -. IFAUTO
writemenu''
if. IFGREENMOVE do. rungreen'' end.
)

NB. =========================================================
ps_close=: 3 : 0
wd'pclose'
)

NB. =========================================================
ps_exit_button=: ps_cancel=: ps_close

NB. =========================================================
ps_instructions_button=: 3 : 0
wdview 'Instructions';(topara INSTRUCTIONS)
)

NB. =========================================================
ps_board_mbldown=: 3 : 0
if. IFGREENMOVE > IFTWO do. rungreen'' end.
)

NB. =========================================================
ps_new_button=: 3 : 0
button_enable (4*SIZE)#1
IFGREENMOVE=: 0
SEQ=: ''
run ":SIZE
psshow''
)

NB. =========================================================
ps_nctrl_fkey=: ps_new_button

NB. =========================================================
ps_two_button=: 3 : 0
IFTWO=: -. IFTWO
writemenu''
if. IFGREENMOVE *. IFAUTO do. rungreen'' end.
)

NB. =========================================================
ps_undo_button=: 3 : 0
if. IFTWO do.
  SEQ=: _3 }. SEQ
  IFGREENMOVE=: -. IFGREENMOVE
elseif. IFGREENMOVE do.
  SEQ=: _3 }. SEQ
  IFGREENMOVE=: 0
elseif. 1 do.
  SEQ=: _6 }. SEQ
end.
run (":SIZE),' ',SEQ
psshow''
)

NB. =========================================================
ps_uctrl_fkey=: ps_undo_button

NB. =========================================================
ps_boardsize=: 3 : 0
if. y=SIZE do.
  ps_new_button''
else.
  pos=. wdqform''
  if. IFJA do.
    wd 'rm board', , ';rm ',"1 >BUTTONS
  else.
    wd 'pclose'
    BUTTONS=: 0$<''
  end.
  pos pousse y
end.
)

NB. =========================================================
ps_board_resize=: 3 : 0
writeboard BS
)

NB. =========================================================
ps_sz3_button=: ps_boardsize bind 3
ps_sz4_button=: ps_boardsize bind 4
ps_sz5_button=: ps_boardsize bind 5
ps_sz6_button=: ps_boardsize bind 6
ps_sz7_button=: ps_boardsize bind 7
ps_sz8_button=: ps_boardsize bind 8

NB. =========================================================
psshow=: 3 : 0
glsel 'board'
writelog SEQ
writeboard BS
writeenable''
writemenu''
wd 'setfocus board'
glpaint''
)

NB. =========================================================
button_enable=: 3 : 0
1 button_enable I. y
0 button_enable I. -.y
:
if. #y do.
  bn=. y{,BUTTONS
end.
)

NB. =========================================================
NB. !!! this needs fixing to ensure board is a square and
NB. buttons are sized and positioned..
defgridbuttons=: 3 : 0
BUTTONS=: 'LRTB' ,each "0/ ":&.> >:i.SIZE
wd 'bin vg'
wd 'grid size 3 3'
x=. ": OFFX + ,. SIZE#0,WID+CELL*SIZE
y=. ": OFFY + ,. HITE+CELL*(,~)i.SIZE
j=. (';cc '&,@ (,&' button')) &> ,2 {.BUTTONS

p=. 'minwh ',"1 (' ',":2* WID,CELL),"1 j
l=. SIZE{.p
r=. SIZE}.p

x=. ": OFFX + ,. (,~) WID+CELL*i.SIZE
y=. ": OFFY + ,. SIZE#0,HITE+CELL*SIZE
j=. (';cc '&,@ (,&' button')) &> ,2 }. BUTTONS

p=. 'minwh ',"1 (' ',":2* CELL,HITE),"1 j
t=. SIZE{.p
b=. SIZE}.p

wd 'minwh ',(":WID,CELL), ';bin hz'
wd 'bin h'
wd t
wd 'bin z'
wd 'minwh ',(":WID,CELL), ';bin hz'
wd 'bin v'
wd l
wd 'bin z'
j=. ';cc board isidraw'
wd 'minwh ',(":2#2*CELL*SIZE),j
wd 'bin v'
wd r
wd 'bin z'
wd 'minwh ',(":WID,CELL), ';bin hz'
wd 'bin h'
wd b
wd 'bin z'
wd 'minwh ',(":WID,CELL), ';bin hz'
wd 'bin zszs'

NB. resize grid for even sized buttons:
'x y w h'=. 0 ". wd 'qchildxywh board'
CELL=: <. SIZE %~ w <. h
NB. wd 'setxywhx board ',":x,y,2#CELL*SIZE
wd 'set board wh ',":2#CELL*SIZE
where=: (4,~*:SIZE)$, ,&(2#CELL)"1 CELL*>{2#<i.SIZE
)

NB. =========================================================
writeboard=: 3 : 0
y=. |:y
glrgb 1{COLORS
glpen 0 1
(0{COLORS) writecell where#~' '=,y
((2+PRED='X'){COLORS) writecell where#~'X'=,y
((2+PRED='O'){COLORS) writecell where#~'O'=,y
)

NB. =========================================================
writecell=: 4 : 0 "1
glrgb x
glbrush ''
glrect y NB. ,2#<.CELL%4
)

NB. =========================================================
writemenu=: 3 : 0
wd 'set auto checked ',":IFAUTO
wd 'set two checked ',":IFTWO
wd 'set auto enable ',":IFTWO=0
)

NB. =========================================================
writelog=: 3 : 0
if. 0 e. #y do.
  wd 'set log text '
else.
  seq=. ;: y
  rws=. >. -: #seq
  seq=. _2 [\ (rws*2) {. seq
  txt=. LF ,. (>{."1 seq) ,. '  ' ,"1 >{:"1 seq
  wd 'set log text *', log=: }. ,txt
  wd 'set log scroll ',":rws
end.
)
