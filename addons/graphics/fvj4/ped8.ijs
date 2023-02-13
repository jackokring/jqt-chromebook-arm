NB. Palette editing form meant mainly for editing palettes for chaotic attractors
NB. FVJ4 Decmber 2016

require 'trig gl2 files'
NB. require '~addons/media/imagekit/imagekit.ijs'
require '~addons/graphics/fvj4/rgbed.ijs'
rgbed_close_ped8_ :: ] ''
require '~addons/media/imagekit/pal_rw_bmp.ijs'

cocurrent 'ped8'
('z';'jgl2';'mkit') copath 'ped8'

rgbed_ok_button=: 3 : 0
pa_hist=:pa,pa_hist
pa=:(getrgb '')PP}pa
wd 'psel paledit'
display_pal ''
wd 'psel rgbed'
wd 'pclose'
)

PALEDIT=: 0 : 0
pc paledit;
menupop "File";
menu open "&Open Bitmap" "Ctrl+O" "" "";
menu save "&Save" "Ctrl+S" "" "";
menu saveas "S&ave As" "Ctrl +A" "" "";
menu loadpal "Load &Palette from bmp" "" "" "";
menusep ;
menu exit "&Exit" "" "" "";
menupopz;
menupop "Help";
menu command "&Commands" "F1" "" "";
menu about "&About" "" "" "";
menupopz;
bin hvh;
minwh 400 400;
cc pic isidraw;
cc verpos scrollbar v 0 1 10 99;
bin z;
cc horpos scrollbar 0 1 10 99;
bin h;
minwh 200 30;
cc label2 static center;cn "Magnification";
cc mag scrollbar 0 1 10 99;
bin zzv;
minwh 400 400;
cc pal isidraw;
bin h;
minwh 200 30;
cc phb button;cn "palette history BACK";
cc phf button;cn "palette history FORWard";
bin zh;
cc label static center;cn "Action on Selection:";
cc seltyp combolist;
bin zzv;
cc open button;cn "Open";
cc save button;cn "Save";
cc saveas button;cn "Save as";
cc copy button;cn "Copy RGB";
cc paste button;cn "Paste RGB";
cc cancel button;cn "Exit";
pshow;
)

paledit_run=: 3 : 0
wd PALEDIT
wd 'set seltyp items blend reverse inverse random2 random3 random4 random5;setselect seltyp 0; '
if. 0<#y do.
  fn=:y
  loadbmp ''
  end.
wd 'pshow;'
)

paledit_close=: 3 : 0
wd'pclose'
)

paledit_cancel_button=: 3 : 0
paledit_close''
)

paledit_exit_button=: 3 : 0
paledit_close''
)

gpolygon=: 3 : 0
glpolygon y
:
glbrush glrgb x
glpolygon y
)

display_pal=:3 : 0
wd 'psel paledit;'
glsel 'pic'
NB.glpixels 0 0,($ bit),,256 256 256#. (a.i.bit){pa
glpixels 0 0,($ bit),,rgb_to_i (a.i.bit){pa
glpaintx ''
wd 'pshow'
glsel 'pal'
(|.16 16$256{.pa) gpolygon"1 (400%16)*,/"2 (#:0 1 3 2)+"1 _"_ 1 (|.,"0~/])i.16
glpaintx ''
wd 'pshow;'
)

paledit_open_button=: 3 : 0
try. 1+$fndir=.jpath path_nm fn catch. fndir=.jpath '~addons/graphics/fvj4/' end.
try. 1+$nfn=.nx_fn fn catch. nfn=. 'temp.bmp' end.
fn=:wd 'mb open "Bitmap files" "',fndir,'" "',nfn,'" "Bmp(*.bmp)|*.bmp|All files(*.*)|*.*"'
fn=:fn-.LF
wd 'pn "',fn,'";'
loadbmp ''
)

raw_pal_read=:3 : 0
'p b'=.pal_read_bmp y
b=.b{a.
p;b
)

paledit_loadpal_button=: 3 : 0
try. 1+$tempdir=.jpath path_nm tempfn catch. tempdir=.jpath '~addons/graphics/fvj4/' end.
tempfn=:wd 'mb open "Bitmap files" "',tempdir,'" " " "Bmp(*.bmp)|*.bmp|All files(*.*)|*.*"'
tempfn=:tempfn-.LF
if. 0<#tempfn do.
  pa_hist=:pa,pa_hist
  'pa temp'=:raw_pal_read tempfn
  pa=:256{.pa
  display_pal ''
  end.
)

paledit_phb_button=: 3 : 0
if. 0<#pa_hist do.
'pa pa_hist'=:({.pa_hist);}.pa_hist,pa
display_pal ''
end.
)

paledit_phf_button=: 3 : 0
if. 0<#pa_hist do.
'pa pa_hist'=:({:pa_hist);pa,}:pa_hist
display_pal ''
end.
)

loadbmp=:3 : 0
if. 0<#fn do.
  'pa bitmap'=:raw_pal_read fn
  'M N'=:$bitmap
  bitmap2=:|.(_1 1*>./M,N){.bitmap
  pa=:256{.pa
  pa_hist=:i.0 256 3
  updatebit ''
  display_pal ''
end.
)

updatebit=: 3 : 0
MAG=.".mag
in=.<.((i.%<:)400)*((400%99)*(99-MAG))+(MAG%99)*<:M<.N
HP=.<.((".horpos)%99)*N->:{:in
VP=.<.((".verpos)%99)*M->:{:in
bit=: (HP+in){"1 ((M-1)-|.VP+in){bitmap2
)

paledit_mag_changed=: 3 : 0
updatebit ''
display_pal ''
)

paledit_horpos_changed=:paledit_mag_changed
paledit_verpos_changed=:paledit_mag_changed

paledit_octrl_fkey=: paledit_open_button
paledit_actrl_fkey=: paledit_saveas_button
paledit_sctrl_fkey=: paledit_save_button
paledit_f1_fkey=: paledit_command_button

pal_pos=:3 : 0
16 16 #. |.<.16*(0 1&{ % 2 3&{)". y
)

paledit_pal_mbldbl=:3 : 0
NB. smoutput sysdata
PP=:pal_pos sysdata
rgbed_run ":PP{pa
)

paledit_pal_mbldown=:3 : 0
if. 0=7{".sysdata do.
    PP=:pal_pos sysdata
    display_pal ''
    glrgb 255-PP{pa
    glpen 3 1
    gllines ,(400%16)*(#:2 1)+"1 <.16*(0 1&{ % 2 3&{)". sysdata
    gllines ,(400%16)*(#:0 3)+"1 <.16*(0 1&{ % 2 3&{)". sysdata
    glrgb 0 0 0
    glpen 1 1
    glpaint ''
  else.
  qq=.pal_pos sysdata
  if. qq<PP do. 'PP qq'=.qq,PP end.
  si=. PP+i.1+qq-PP      NB. selected indices
  pa_hist=:pa,pa_hist
  select. seltyp
    case. 'blend' do.
          rr=.<.0.5+(PP{pa)+"1((qq{pa)-PP{pa)*"1 0(i.%])qq-PP
          pa=:rr (}:si)}pa
    case. 'reverse' do.
          pa=:(|.si{pa)si}pa
    case. 'inverse' do.
          pa=:(255-si{pa)si}pa
    case. 'random2' do.
          pa=:(<.0.5+(((i.%<:)2);?2 3$256)pwlin (i.%<:)#si)si}pa
    case. 'random3' do.
          pa=:(<.0.5+(((i.%<:)3);?3 3$256)pwlin (i.%<:)#si)si}pa
    case. 'random4' do.
          pa=:(<.0.5+(((i.%<:)4);?4 3$256)pwlin (i.%<:)#si)si}pa
    case. 'random5' do.
          pa=:(<.0.5+(((i.%<:)5);?5 3$256)pwlin (i.%<:)#si)si}pa
    end.    
  display_pal ''
end.
)

pwlin=: 3 : 0"_ 0
:
p=.>{.x
c=.>{:x
i=.i.&0 p<y
((1-r),r=.(y-~i{p)%-/(i-0 1){p)+/ .* (i- 0 1){c
)

paledit_copy_button=: 3 : 0
Clip=:PP{pa
)

paledit_paste_button=: 3 : 0
pa_hist=:pa,pa_hist
pa=:Clip PP}pa
display_pal ''
)

paledit_saveas_button=: 3 : 0
try. 1+$fndir=.((i:&'\') {. ])fn catch. fndir=.'' end.
out=.wd 'mb save "Bitmap files" "',fndir,'" "" "Bmp(*.bmp);Png(*.png)|*.bmp;*.png|All files(*.*)|*.*"'
if. 0<#out do. 
  fn=:out
  (pa;a. i. bitmap) pal_write_bmp fn
  wd 'pn "',fn,'";pshow;'
  end.
)

paledit_save_button=: 3 : 0
ok=.wd 'mb query mb_yes mb_no "Ok to overwrite image: ',fn,' ?"'
if. ok-:'yes' do. (pa;a. i. bitmap) pal_write_bmp fn end. 
)

help_commands=:0 : 0
Images opened need to be 8 bit 
uncompressed windows bitmaps

Open		ctrl-o	Loads a new image
Save		ctrl-s	Save the image with modified palette
Save As		ctrl-a	Save the image with a new name

Copy			Copies selected RGB triple to a clipboard
Paste			Pastes the RGB triple to selected position

Double-left         Edit palette entry
Left-click          Select palette entry
Shift-left click    SELECTS palette from selected entry to 
			current entry and performs an action on selection
     Blend ..... applies Linear merge
     Reverse ... reverses the order of the palette entries
     Inverse ... applies 255&- to each color
     Random n .. creates n uniformly spaced random color with
                 linear merge in between    

Help		F1      This help
)

paledit_command_button=: 3 : 0
wdinfo help_commands
)

help_about=:0 : 0
Utility for editing the palette of
8 bit uncompressed windows bmps

Written by Cliff Reiter
Lafayette College
Last update December 2016
)

paledit_about_button=: 3 : 0
wdinfo help_about
)

cocurrent 'base'

paledit_run_ped8_ ''
