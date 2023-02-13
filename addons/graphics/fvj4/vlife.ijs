NB. Viewing the evolution of the Game of Life
NB. Colored by number of neighbors
NB. vlife2.ijs
NB. Cliff Reiter
NB. January 2005
NB. January 2007 update to J6.01c

coinsert 'jgl2 vclife'     NB. locale for vlife.ijs script definitions
require 'gl2 files'
require '~addons/media/imagekit/imagekit.ijs'
coclass 'vclife'

NB. defaults
LA_wh=:256 256
LA_mag=:3       NB. default
LA_bor_sz=:50  NB. default border padding size
pat_path=: jpath '~addons/graphics/fvj4/lif'  NB. path for *.lif patterns
im_path=:  jpath '~temp'  NB. path for reading/writing images
LA_save_fseq=: 0   NB. default is not to save a file sequence
NB. bor_wh=:30 175   NB. default edge used by windowing system

NB. update life pattern
lifee=:([:,/1&|.^:(i:1)@|:"2^:2)  NB. life expand
lifes=:lifee@:(4&{((3:=])+.[*.4:=]) +/)  NB. life step (expanded to expended)

NB. get color indices associated with a pattern
lcolor=: 4&{ * +/

NB. Palettes used for showing the colors
LA_pal=:255*1,0,(=i.3), 1 1 3#-.=i.3
LA_pakpal=:rgb_to_i_mkit_ LA_pal

NB. General utilities 

pad=: (+:@[-@+$@]){.([+$@]){. ]  NB. pad around an array

NB. getpath=: ([: +./\. =&PATHSEP_j_) # ]  NB. borrowed from ...extras\util\jadecon.ijs

NB. Form menus and buttons
LIFE0=: 0 : 0
pc life;pn vlife;
menupop "&File";
menu new "&New" "" "" "";
menu load "&Load *.lif Pattern" "" "" "";
menusep;
menu import "&Import Pattern from Image" "" "" "";
menu export "&Export Pattern to Image" "" "" "";
menu exportsnap "&Export Snapshot" "" "" "";
menu exportfseq "&Export Snapshot Sequence On" "" "" "1";
menu exportfseqoff "&Export Snapshot Sequence Off" "" "" "1";
menusep;
menu rand "&Random" "" "" "";
menu ggun "Load &Glider Gun" "" "" "";
menu bhept "Load &B-Heptomino" "" "" "";
menusep;
menu exit "&Exit" "" "" "";
menupopz;
menupop "Size";
menu size6 "Array Size &64 64";
menu size7 "Array Size 128 128";
menu size8 "Array Size 256 256";
menu size9 "Array Size 512 512";
menu size10 "Array Size 1024 1024";
menupopz;
menupop "Magnification";
menu mag1 "Magnification 1";
menu mag2 "Magnification 2";
menu mag3 "Magnification 3";
menu mag4 "Magnification 4";
menu mag5 "Magnification 5";
menu mag6 "Magnification 6";
menu mag7 "Magnification 7";
menu mag8 "Magnification 8";
menu mag9 "Magnification 9";
menupopz;
menupop "Expand";
menu expandall "Expand All Borders";
menu expandr "Expand Right";
menu expandl "Expand Left";
menu expandt "Expand Top";
menu expandb "Expand Bottom";
menupopz;
menupop "Help";
menu help "&Help";
menu about "&About";
menupopz;
bin v;
  bin h;
  cc start button;
  cc step button;
  cc pause button;
  cc iter statusbar;
  set iter addlabel count;
  set iter setlabel count "Iteration: 0";
bin z;
)

LIFE1=:0 : 0
cc rasterwin isidraw;
bin z;
pshow;
)

NB. NB. end of menu form
NB. LIFE1=: 0 : 0
NB. pshow;
NB. )
NB.
NB. run the main life form function

life_run=: 3 : 0
LA_blank ''
LA_paint_all ''
)

NB. run the main life form function
NB. paint the current life configuration
LA_paint=: 3 : 0
color=.lcolor LAe
wd 'psel life'
glsel 'rasterwin'
glclear ''
t=.0 0 ,LA_plp_wh,,(LA_plp { color){LA_pakpal 
glpixels t
glpaintx ''
wd 'msgs'
)

NB. repaint entire form
LA_paint_all=:3 : 0
wd :: 0: 'psel life;'
wd :: 1: 'pclose;'
wd LIFE0
wd 'minwh ',(":LA_plp_wh),';'
wd LIFE1
LA_paint ''
wd 'pshow;'
)

NB. used to initialize a new nonblank pattern
LA_init=:3 : 0
LA_plp=:<LA_mag #&.> <@i."0 |.LA_wh
LA_plp_wh=:LA_mag*LA_wh
)

NB. initialize a blank pattern
LA_blank=: 3 : 0
LAe=: lifee (|.LA_wh) $ 0
LA_init ''
LA_iter=:0
setiter ''
)

NB. New button creates a blank image
life_new_button=: 3 : 0
LA_blank ''
LA_paint_all ''
)

NB. save current pattern as an image
life_export_button=:3 : 0
fn=.wd 'mb save "Save Pattern As Image" "',im_path,'"  ""  "Bmp(*.bmp);Png(*.png)|*.bmp;*.png|All Files(*.*)|*.*"'
if. fn-: '' do. return. end.
im_path=: path_nm fn
(LA_pal;lcolor LAe) write_image fn
)

NB. read pattern from image
life_import_button=:3 : 0
fn=.wd 'mb open  "Read Image" "',im_path,'"  ""  "Bmp(*.bmp);Jpeg(*.jpg);Png(*.png)|*.bmp;*.jpg;*.png|All Files(*.*)|*.*"'
if. fn-: '' do. return. end.
fn=.fn-.CRLF
im_path=: path_nm fn
b=.read_image fn
LA_wh=:1 0{$b
LAe=: lifee 85 >  <./"1 b
LA_init ''
LA_paint_all ''
LA_iter=:0
setiter ''
)

NB. save snapshot
life_exportsnap_button=:3 : 0
fn=.wd 'mb save  "Save Current Image As" "',im_path,'"  ""  "Bmp(*.bmp);Png(*.png)|*.bmp;*.png|All Files(*.*)|*.*"'
if. fn-: '' do. return. end.
fn=.fn-.CRLF
im_path=: path_nm fn
color=.lcolor LAe
(LA_pal;LA_plp { color)write_image fn
)

NB. save snapshot sequence
life_exportfseq_button=:3 : 0
LA_fseq_fn=:wd 'mb save  "Save Generations with First File as" "',im_path,'"  ""  "Bmp(*.bmp);Png(*.png)|*.bmp;*.png|All Files(*.*)|*.*"'
if. LA_fseq_fn-: '' do. return. end.
LA_fseq_fn=:LA_fseq_fn-.CRLF
if. ''-:fn_num_suffix  LA_fseq_fn do.
   LA_fseq_fn=:(}: '' ch_ext LA_fseq_fn),'0000.',fn_ext LA_fseq_fn
   end.  
LA_save_fseq=:1
im_path=: path_nm LA_fseq_fn
color=.lcolor LAe
(LA_pal;LA_plp { color)write_image LA_fseq_fn
)

NB. save snapshot sequence
life_exportfseqoff_button=:3 : 0
LA_save_fseq=:0
)

NB. utilities for the load_lif utilities 
get_blocks=:3 : 0
('#P' E. y)<;._1 y
)

read_lif=:3 : 0
bposul=._1&".@}.@}:@>@{.
bpat=.'*'&=@}:&>@}.
pat=.fread y
if. -. 1 e. '#N' E. pat do.
  wd 'mb error "Error: not a normal Life 1.05 file";'
  return.
  end. 
pb=.|:(bposul;bpat)@:(<;._2)&> get_blocks pat
pos=.>{.pb
pos=.|."1 pos-"1 <./pos
blk=.{:pb
max=.>./pos+"1 sblk=.$&>blk
LA=.max$0
for_k. i.#pos do.
  LA=.(>k{blk)(<(k{pos)+&.> <@i."0 k{sblk)}LA
  end.
LA=.LA_bor_sz pad LA
LAe=:lifee LA
LA_wh=:|.$LA
LA_wh
)

life_load_button=:3 : 0
fn=.wd 'mb open  "Load *.lif Pattern" "',pat_path,'"  "Hensel Life(*.lif)|*.lif|All Files(*.*)|*.*"'
pat_path=:path_nm fn
if. fn-: '' do. return. end.
fn=.fn-.CRLF
read_lif fn
LA_init ''
LA_paint_all ''
LA_iter=:0
setiter ''
)

NB. load glider gun configuration
life_ggun_button=:3 : 0
LAe=:lifee(1 _1*|.LA_wh){.A2
LA_init ''
LA_paint_all ''
LA_iter=:0
setiter ''
)

NB. load B-heptomino configuration
life_bhept_button=:3 : 0
LAe=:lifee(|.LA_wh) {. (<.-:($A3)-|.LA_wh){.A3
LA_init ''
LA_paint_all ''
LA_iter=:0
setiter ''
)

NB. create a random configuration
life_rand_button=: 3 : 0
LAe=:lifee LAe=:? (|.LA_wh)$2
LA_init ''
LA_paint_all ''
LA_iter=:0
setiter ''
)

NB. Pause
life_pause_button=:3 : 0
wd 'ptimer 0'
)

NB. run one step of life
life_step_button=:3 : 0
LAe=:lifes LAe
LA_iter=:LA_iter+1
if. LA_save_fseq do. 
  color=.lcolor LAe
  (LA_pal;LA_plp { color)write_image LA_fseq_fn
  LA_fseq_fn=:nx_fn LA_fseq_fn
  end.
setiter ''
LA_paint ''
)

NB. run life
life_start_button=:3 : 0
life_step_button ''
wd 'ptimer 100'
)

NB. draw iteration count on form
setiter=: 3 : 0
try.
wd 'psel life;set iter setlabel count "Iteration: ',(": LA_iter),'";'
catch. 0 end.
)

NB. event used to iterate life
life_timer=: 3 : 0
try. life_step_button '' catch.
  wd 'ptimer 0'
  end.
)

NB. close/cancel/ext functions
life_close=: 3 : 0
wd 'pclose'
)

life_cancel_button=: life_close

life_exit_button=: life_close

NB. Sample initial configurations
NB. A2 is the famous Glider Gun
A2=: 10 pad ".;._2] 0 : 0
0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0
1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 1 1 0 1 0 0 0 1 0 0 0 0 0 0 0 0 1 1
0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0
)

NB. A3 is the b_heptomino
A3=:5 pad ".;._2] 0 : 0
0 0 0 0 0 0
0 1 0 0 0 0
0 1 1 0 0 0
0 0 1 1 0 0
0 1 1 0 0 0
0 0 0 0 0 0
)

NB. Change the current LA (life array) Size
life_size=:4 : 0
LAe=:(|.x){."2 (<.-:-x+LA_wh){."2 LAe
LA_wh=:x
LA_init ''
LA_paint_all ''
)

life_size6_button=: 64 64 & life_size
life_size7_button=: 128 128 & life_size
life_size8_button=: 256 256 & life_size
life_size9_button=: 512 512 & life_size
life_size10_button=: 1024 1024 & life_size

NB. specific magnification used to create super pixels
life_mag=:4 : 0
LA_mag=:x
LA_init ''
LA_paint_all ''
)

life_mag0_button=: 0&life_mag
life_mag1_button=: 1&life_mag
life_mag2_button=: 2&life_mag
life_mag3_button=: 3&life_mag
life_mag4_button=: 4&life_mag
life_mag5_button=: 5&life_mag
life_mag6_button=: 6&life_mag
life_mag7_button=: 7&life_mag
life_mag8_button=: 8&life_mag
life_mag9_button=: 9&life_mag

NB. Expand buttons
life_expandall_button=:3 : 0
LAe=:LA_bor_sz pad"2 LAe
LA_wh=:2 1{$LAe
LA_init ''
LA_paint_all ''
)

life_expandr_button=:3 : 0
LAe=:(LA_bor_sz+{.LA_wh){."1 LAe
LA_wh=:2 1{$LAe
LA_init ''
LA_paint_all ''
)

life_expandl_button=:3 : 0
LAe=:(-LA_bor_sz+{.LA_wh){."1 LAe
LA_wh=:2 1{$LAe
LA_init ''
LA_paint_all ''
)

life_expandt_button=:3 : 0
LAe=:(-LA_bor_sz+{:LA_wh){."2 LAe
LA_wh=:2 1{$LAe
LA_init ''
LA_paint_all ''
)

life_expandb_button=:3 : 0
LAe=:(LA_bor_sz+{:LA_wh){."2 LAe
LA_wh=:2 1{$LAe
LA_init ''
LA_paint_all ''
)

NB. Help and about menus
help_info=:0 : 0
This is vlife2, a J script providing a colored 
version of the game of life. 

Life patterns may be loaded using *.lif (v 1.05)
patterns or image files. Obtaining lifep.zip
by Al Hensel is highly recomended. 
)

life_help_button=:3 : 0
wd 'mb info "vlife Help " "',help_info,'";'
)

about_info=:0 : 0
vlife was written by Cliff Reiter
January 2005
revised in 2007
and 2015
)

life_about_button=:3 : 0
wd 'mb info "About vlife" "',about_info,'";'
)

NB. simple name for main function
vlife=:life_run

NB. run the function
coclass 'base'
vlife ''

