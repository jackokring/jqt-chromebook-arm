	NB. tabby - graphic.ijs
'==================== [tabby] graphic ===================='
0 :0
Saturday 25 May 2019  22:42:05
-
  wd'psel tree; qform'  NB. to get current position
  sminfo_z_=: wdinfo_z_=: echo_z_  NB. suppress wdinfo-of-death
)

clear 'tree'	NB. >>>>> DELETE THIS LINE IN RELEASED ADDON
coclass 'tree'
coinsert 'jgl2'	NB. use gl2 verbs to paint the window

PCAPT=: 150j10	NB. posn of caption
ROWSEP=: 20
XDISP=: 80	NB. adjusts body of display
YDISP=: 30	NB. adjusts body of display

NODEID=: 1
NODE=: ''
NOSELECTION=: '(nothing selected)'

TREEPOS=: 1380 500 530 550

TREE=: 0 : 0
pc tree;pn T-Table Tree;
cc g isidraw;
cc sbar static; cn "(status unset)";
)

window_close=: 3 : 'wd :: 0: ''psel tree; pclose;'''

start=: 3 : 0
  NB. fill tools with glyphs from 1st col of table: CNB
TIMER_HOVER=: 1000
PEN_WIDTH=: 3
COLOR_HOVER=: 255 200 0	NB. color of hover spot
COLOR_CLICK=: 255 100 0	NB. color of click spot
COLOR_WHITE=: 255 255 255	NB. color of (invisible) circumference
COLOR_ARROW=: 170 170 255	NB. color of arrow
MAX_DISTANCE=: 15		NB. used by verb: closest (13 seems critical)
MAX_DISTANCE=: 100		NB. used by verb: closest (13 seems critical)
NB. FONT=: 'Arial Unicode MS'	NB. best-looking glyphs
NB. FONT=: 'APL385 Unicode'	NB. solid-looking APL glyphs
NB.FONT=: 'Andale Mono'	NB. squared-off glyphs
FONT=: 'menlo' [FONTSIZE=: 14
FFONT=: '"menlo" 14'
IFONT=: '"times" 20 italic'
IFONT2=: '"times" 16 italic'
'GCOUNT GWIDTH GDROP DIAMETER CENTER DISP'=: 24 20 18 36 6j12 _12j_7
NB. PTLS=: ptls''		NB. topleft points for tool glyphs
NB. PTS=: PTLS + CENTER	NB. est displacement to visual center
NB. WTS=: (#PTS)#1		NB. dummy weights (for now)
sysevent=: ''		NB. clear to avoid garbage sysevent
window_close''
wd TREE
NB. wd 'set g wh _1 64'
wd 'pmove ',": TREEPOS
wd 'pshow'
icp=: _1  NB. outside range of: items
redraw''
)

putsb=: 3 : 0
  NB. show (string/num) y in statusbar
z=. ": ,y
if. 70<#z do. z=. '…',~ 69{.z end.
wd 'psel tree; set sbar text *',z
)

circle=: 4 : 0
  NB. draw circle of DIAMETER centreed at (px coords) y
NB. 	ssw '+++ circle y=(y)'
clicked=. x  NB. (bool) x-arg of caller: redraw
ring=. clicked pick COLOR_HOVER ; COLOR_CLICK
NB. ring=. COLOR_WHITE
NB. spot=. clicked pick COLOR_HOVER ; COLOR_CLICK
glsel 'g'
glpen PEN_WIDTH [glrgb ring
NB. glbrush'' [glrgb spot  NB. next ellipse filled with spot color
xy=. +.y
wh=. 2#DIAMETER
radius=. <.DIAMETER%2
glellipse (xy - radius) , wh
)

NB. tree_g_focus=: empty
NB. tree_g_focuslost=: empty
NB. tree_g_mbldbl=: empty	NB. DOUBLECLICK on toolbar
NB. tree_g_resize=: empty

tree_close=: window_close

tree_g_mbldown=: 3 : 0
  NB. mouseDown on toolbar
  NB. NODEID is repeatedly assigned by: tree_g_mmove
	ssw '+++ tree_g_mbldown NODEID=(NODEID) NODE=(NODE)'
1 redraw NODEID
)

tree_g_mblup=: 3 : 0
  NB. mouseUp on toolbar: executes the tool
NODE=: 'CLICKED',":NODEID
	ssw '+++ tree_g_mblup NODEID=(NODEID) NODE=(NODE)'
NB. (NODE~)''
)

tree_g_mmove=: hover

hover=: 3 : 0
NB. wd 'timer 0'
'X Y'=: 2{.".sysdata  NB. REDUNDANT?
PT=: X j. Y           NB. REDUNDANT?
icp=: closest pjmouse''	NB. tool# closest to cursor
if. _=icp do. signal NOSELECTION return. end.
signal 2 pick icp{CNB	NB. confirm what the tool is
redraw icp		NB. hilite the tool glyph
  NB. Dont let hilite stay on forever…
sys_timer_z_=: hover_off_nut_
wd'timer ',":TIMER_HOVER
)

signal=: empty  NB. too much output

signal=: 3 : 0
if.-. y-:NOSELECTION do. smoutput 'signal:' ; y end.
)

tree_hover_off=: 3 : 0
wd 'timer 0'
	ssw '+++ tree_hover_off: X=(X) Y=(Y)'
NB. redraw''  NB. redraw with no hilite
)

closest=: 3 : 0
  NB. return index of (first) closest point (y) in PTS
z=. |PTS-y	NB. distances of y from each of PTS
NB. z=. z*WTS	NB. …weighted (based on char width)
ld=. <./z		NB. lowest distance found
if. ld>MAX_DISTANCE do. _ return. end.  NB. force: index error
i=. z i. ld	NB. index of lowest distance
)

  NB. mouse event data extractors
sysndata=:   3 : 'y{ 12{. 0&".sysdata' "0
ptmouse=: sysndata bind 0 1
pjmouse=: 3 : 'j./ ptmouse y'
formxy=:  sysndata bind 2 3
bnleft=:  sysndata bind 4
bnmid=:   sysndata bind 5
dnctrl=:  sysndata bind 6	NB. acts like bnright
dnshift=: sysndata bind 7
  NB. Command key ⌘	gives 1 for dnctrl''
  NB. Option key ⌥		HAS NO EFFECT
  NB. Ctrl key ^		BEHAVES LIKE RIGHTCLICK
bnright=: sysndata bind 8
  NB. 0 0-: sysndata 9 10	--ALWAYS
nwheel=:  sysndata bind 11

clickleft=: 3 : 0
Handler 'clickleft'
icp=: closest pjmouse''	NB. tool# closest to cursor
if. _=icp do. signal '(no tool selected)' return. end.
NB. 1 fill_tools icp		NB. hilite (clicked)
i.0 0
)

redraw=: 0 ddefine
  NB. redraws t-table tree, hilites hotspot id= y
  NB. (bool) x makes choice between 2 circle colors
NB. 	ssw '... redraw x=(x) y=(y)'
ITEMS=: }.i.#>{.CTB=: tabengine_cal_'CTBB'
PTS=: XDISP j. YDISP + ROWSEP*ITEMS
putsb sw 'icp=(icp) NODEID=(NODEID) NODE=(NODE) x=(x) y=(y) X=(X) Y=(Y)'
wd 'psel tree'
blank=. COLOR_WHITE
spot=. x pick COLOR_HOVER ; COLOR_CLICK
glsel 'g'
glclear''
if. icp e. ITEMS-1 do. x circle icp{PTS end.
NB. glfont sw '"(FNT)" (FNTSIZE)'
glfont IFONT
NB. glrgb blank
glpen 1 [glbrush'' [glrgb spot  NB. next ellipse filled with spot color
capt=. tabengine_cal_'CAPT'
NB. width=. - >: {:$ units=. 4 pick CTB
names=. 6 pick CTB
NB. qtys=. (width&}. "1) 3 pick CTB
qtys=. 3 pick CTB
NB. gltextxy +. DISP + PCAPT		NB. item no
gltextxy +. PCAPT		NB. item no
gltext tabengine_cal_'CAPT'
  NB. draw text of items
for_i. i.#PTS do.
  glfont FFONT	NB. sw '"(FONT)" (FONTSIZE)'
  gltextxy +. DISP + i{PTS		NB. item no
  gltext brace i+1
  gltextxy +. DISP + 50 + i{PTS	NB. qtys
  gltext utf8 qtys {~ i+1
NB.   gltextxy +. DISP + 90 + i{PTS	NB. units
NB.   gltext units {~ i+1
NB.   glfont IFONT2
  gltextxy +. DISP + 180 + i{PTS	NB. names
  gltext names {~ i+1
end.
arrow arrx''  NB. draw each arrow
NB. arrow 1 4 8
NB. arrow 2 4 1
NB. arrow 2 2 4
glpaint''
)

arrow=: 3 : 0 "1
  NB. draw arrow
  NB. (y) format: (col#),(source-item),(target-item)
NB. smoutput 'arrow: ',":y
'c i j'=. y
h=. 30 * j-i
s=. 20  NB. col separation
d=. _20-(c*s)
w=. 10	NB. arrow tail width
p=. d + i{0,PTS
o=. p + w
q=. d + j{0,PTS
r=. q + w
glbrush'' [ glpen 2 [glrgb COLOR_ARROW
gllines ,+. o,p,q,r
6 tip r
)

tip=: 4 : 0
  NB. draw arrowhead size (x) at point: y
glpen 1
glpolygon ,+. y + 0 0j1 0j_1 1j0 0j1 * x
)

arrx=: 3 : 0
  NB. extract drawing instrs from y ==ARRO
  NB. --format of each row: (col#),(source-item),(target-item)
'a aa'=: tabengine_cal_'ARRO'  NB. (arrow ch-array);(arrow-draw-table)
w=. {:$a
z=. -. SP= ((w$0 1)#i.w){|:a  NB. bool: arrowheads in alt cols of: a
t=. +/(|. 1+i.#z) *"0 0 1 z  NB. make a new col-id table (t)
z=. t{~ {:"1 aa  NB. make new col-ids from arrow targets
z,. }."1 aa  NB. aa with replacement 1st col (z)
)

onload 'start_tree_ $0'
