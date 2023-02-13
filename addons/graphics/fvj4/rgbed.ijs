NB. Palette entry editing form meant mainly for editing palettes for chaotic attractors
NB. FVJ4 Decmber 2016

require '~addons/media/imagekit/imagekit.ijs'
cocurrent 'ped8'
('z';'jgl2';'mkit') copath 'ped8'


RGBED=: 0 : 0
pc rgbed;
  bin h;
  minwh 200 200;
  cc colsq isidraw;
  bin v;
    bin h; 
    minwh 255 20;
    cc rsb scrollbar 0 1 16 255;
    minwh 150 20;
    cc rs statusbar;
    set rs addlabel rsbv;
    bin z;
    bin h; 
    minwh 255 20;
    cc gsb scrollbar 0 1 16 255;
    minwh 150 20;
    cc gs statusbar;
    set gs addlabel gsbv;
    bin z;
    bin h; 
    minwh 255 20;
    cc bsb scrollbar 0 1 16 255;
    minwh 150 20;
    cc bs statusbar;
    set bs addlabel bsbv;
    bin z;
  bin z;
  bin v;
  cc ok button;cn "OK";
  cc cancel button;cn "Cancel";
  bin zz;
)

rgbed_run=: 3 : 0
rgb=.3{.".y,' 0 0 0'
rsb=.":0{rgb
gsb=.":1{rgb
bsb=.":2{rgb
wd RGBED
NB. initialize form here
wd 'set rsb pos ',rsb
wd 'set gsb pos ',gsb
wd 'set bsb pos ',bsb
wd 'set rs setlabel rsbv "',rsb,' Red";'
wd 'set gs setlabel gsbv "',gsb,' Green";'
wd 'set bs setlabel bsbv "',bsb,' Blue";'
wd 'pshow;'
paint rgb
)

paint=:3 : 0
wd'psel rgbed;'
glsel 'colsq'
glrgb y
glbrush ''
glpolygon ,1000*#:0 1 3 2
glpaintx ''
)

rgbed_colsq_paint=:3 :'paint getrgb i.0'

getrgb=:3 : 0
".rsb,' ',gsb,' ',bsb
)

rgbed_close=: 3 : 0
wd 'pclose'
)

rgbed_cancel_button=: 3 : 0
rgbed_close''
)

rgbed_rsb_changed=: 3 : 0
wd 'psel rgbed;set rs  setlabel rsbv "',rsb,' Red";'
paint getrgb ''
)

rgbed_gsb_changed=: 3 : 0
wd 'psel rgbed;set gs  setlabel gsbv "',gsb,' Green";'
paint getrgb ''
)

rgbed_bsb_changed=: 3 : 0
wd 'psel rgbed;set bs  setlabel bsbv "',bsb,' Blue";'
paint getrgb ''
)

rgbed_ok_button=: 3 : 0
wd 'mb info *For later use'
)

coclass 'base'

rgbed_run_ped8_ ''

