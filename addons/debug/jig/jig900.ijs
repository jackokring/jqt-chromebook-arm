NB. Version 900 for this add on - QTide tooltips used - J901 passed testfile load '/users/bobtherriault/j901-user/projects/jig900/runjig901.ijs'
NB. This version also limits the number of processes to 10 plus however many saved displays are created.
coerase <'jig' NB. clear previous jig variables including handlists, savelists and titlelists
cocurrent'jig' NB. Set the defining locale as jig
require 'gl2'

CSS=: 0 : 0  NB. CSS for the different types and animations of tootips.
<style type="text/css">
 svg {overflow:visible;}
 rect {overflow:visible;}
 text { font-family:"courier"; font-weight:bold; stroke-width:0.75; stroke:black; pointer-events: none; text-anchor:start; white-space:pre;}
 .err  { fill:red; stroke-width:0.7;}
 .verb  { fill:blue; stroke-width:0.4;}
 .adverb  { fill:gold; stroke-width:0.5;}
 .conj  { fill:purple; stroke-width:0.2;}
 .p  { fill:red; stroke-width:0.4;} 
 .l  { fill:gold; font-family:"<FONT>"; font-weight:normal; stroke:none; font-size:0.8em;}
 .u , .v  { fill:black; font-family:"<FONT>"; font-weight:normal; font-size:0.8em;}
 .sy { fill:black; font-family:"<FONT>"; font-weight:normal; stroke:none; font-size:0.8em;}
 .b , .ja , .ea { fill:white; stroke-width:1;} 
 .i  { font-weight:normal; stroke:none;}
 .f  { fill:#44f; stroke-width:0.5;} 
 .fa { fill:white; stroke-width:0.75;}
 .e  { fill:#888; stroke-width:0.4;} 
 .r  { fill:black; stroke-width:0.2;} 
 .ra { fill:red; stroke-width:0.5;}
 .c  { fill: #004400; font-style: italic; stroke-width:0.2;}
 .s  { fill:white;  font-weight:normal; stroke:white; stroke-width:1; font-size: 1.5em;}
 .sl { fill:#f55;}
 .su { fill:#b22;}
 .sv { fill:#600;}
 .sx { border-style:solid; border-color:"black"; border-width:"1";}
 .d  { fill:#dde; stroke:#aac; stroke-width:1;}
 .j  { fill:#fff;}
 .n  { fill:#fff; stroke:#fff; height:18;}
 .x  { stroke:black; stroke-width:2.5; rx:0;} 
 .z0 { fill:#fff; stroke:#666; stroke-width:1;}
 .z1 { fill:#bbb;}
 .z2 { fill:#666;}
 .lb { fill:#004225; stroke:gold; height:18;}
 .lc { fill:#008825; stroke:gold; height:18;}
 .syb { fill:white; stroke:red; height:18;}  
 .ub { fill:yellow; stroke:gold; height:18;}
 .u4 { fill:gold; stroke:yellow; height:18;}
 rect:hover  {fill:#96C; opacity:1; transition: all 0.1s ease-in-out;}
</style>
)

DISPLAY=: 0 : 0 NB. Form that contains the display as well as zoom and font buttons
pc enhanced;
bin v;
bin h;
minwh 250 170; cc w1 webview;set _ sizepolicy minimum;
bin vs;
cc FI static;cn "Font";
maxwh 80 20;cc menlo radiobutton;cn "menlo";set _ tooltip "Set display font to menlo";
maxwh 80 20;cc unifont radiobutton group;cn "unifont";set _ tooltip "Set display font to unifont";
bin s;
cc SI static;cn "Zoom";
maxwh 60 20;cc xs radiobutton;cn "10%";set _ tooltip "Zoom out to 10% size";
maxwh 60 20;cc s radiobutton group;cn "20%";set _ tooltip "Zoom out to 20% size";
maxwh 60 20;cc sm radiobutton group;cn "50%";set _ tooltip "Zoom out to 50% size";
maxwh 60 20;cc m radiobutton group;cn "100%";set _ tooltip "View at original size";
maxwh 60 20;cc ml radiobutton group;cn "200%";set _ tooltip "Zoom in to 200% size";
maxwh 60 20;cc l radiobutton group;cn "300%";set _ tooltip "Zoom in to 300% size";
maxwh 60 20;cc xl radiobutton group;cn "400%";set _ tooltip "Zoom in to 400% size";
bin szz;
bin h;
maxwh 200 30;cc sj checkbox;cn "Make Permanent";set _ value 0; set _ tooltip "Keep this window in memory";
maxwh 200 30;cc saved static;cn "Saved";set _ visible 0; set _ tooltip "This window is saved permanently";
bin s;
maxwh 80 30;cc dj button;cn "Retrieve";set _ tooltip "Access to previous windows";
bin szz; 
)

enhanced_menlo_button=: 3 : 'font 0'
enhanced_unifont_button=: 3 : 'font 1'

font=: 3 : 0
ndx=. handlist_jig_ i. wd 'qhwndp'
FM=: y [ FONT=: >y{'menlo';'unifont'
'vobj loc'=. 1 0 1 # ndx {titlelist NB. middle 0 is just a dummy variable to get rid of the current window zoom and font info
(0;loc) visual vobj [ enhanced_close ''
)

enhanced_xs_button=: 3 : 'zoom ''xs'''
enhanced_s_button=:3 : 'zoom ''s''' 
enhanced_sm_button=: 3 : 'zoom ''sm'''
enhanced_m_button=: 3 : 'zoom ''m'''
enhanced_ml_button=: 3 : 'zoom ''ml'''
enhanced_l_button=: 3 : 'zoom ''l'''
enhanced_xl_button=: 3 : 'zoom ''xl'''

zoom=: 3 : 0
ndx=. handlist_jig_ i. wd 'qhwndp'
SCALE=: (ZM { 0.1 0.2 0.5 1 2 3 4) [ZM=:(<y)i.~ 'xs';'s';'sm';'m';'ml';'l';'xl'
'vobj loc'=. 1 0 1 # ndx {titlelist NB. middle 0 is just a dummy variable to get rid of the current window zoom and font info
(0;loc) visual vobj [ enhanced_close ''
)

enhanced_sj_button=: 3 : 0
 savejig t=. wd 'qhwndp'
 wd 'psel ', t
 wd 'set sj visible 0; set saved visible 1; set _ text <b>Saved</b>'
 wd 'set xs visible 0;set s visible 0;set sm visible 0;set m visible 0;set ml visible 0;set l visible 0;set xl visible 0;'
 wd 'set menlo visible 0;set unifont visible 0;set FI visible 0;set SI visible 0;'
 wd 'setp wh ',": 75 0 -~ ". wd 'getp wh'
wd 'pshow;'
) 

enhanced_close=:  wd bind 'setp visible 0;'

init=: 3 : 0 NB. create initial 10 handles to be recycled and savelist for hndles not to be recycled and titlelist as titles are created with jig windows
 handlist=: crjig i. 10  NB. create 10  handles
 savelist=: 0 10 $ '' NB. receptacle for future saved 
 titlelist=: 10 3 $ a:  NB. receptacle for available titles and locales
 windex=: _1  NB. start from 0 with first jig window
 i. 0 0
)
crjig=: 3 : 0"0
 wd DISPLAY
 wd 'qhwndp'
)

newjig=: 3 : 0  NB. y is the title of the jig window
 windex=: 10 | >: windex NB. cycles through the handles
 titlelist =: y windex } titlelist NB. adds title to titlelist
 windex { handlist NB. returns handle for the jig window 
)

savejig=: 3 : 0  NB. y is the handle of the jig window
 savelist=: savelist, y NB. add window to save list
 ndx=. handlist i. y  NB. uses handle of selected window to find position in hand
 titlelist=: titlelist, ndx { titlelist NB. add saved window to end of titlelist
 titlelist=: (a:,a:,a:) ndx } titlelist NB. create new blank in titlelist
 handlist=: (crjig 0) ndx } handlist  NB. replace the saved window with a new one
 i. 0 0
)  

webdisplay=: 4 : 0 NB. Displays the results in webview for jqt environment
 wd 'psel *' ,newjig t=. ((0;0) {:: x );('      NB. ',(>ZM{'10';'20';'50';'100';'200';'300';'400') , '% ',(>FM{'menlo';'unifont'));(0;1){:: x
 wd 'pn *', (; 2 {. t)
 wd 'set w1 wh *', ": s=. 250 170>. (_225 _200 + 2 3 { ". wd 'qscreen') <. SCALE * > {: x
 wd 'setp wh ',": s + 100 65
 wd 'set w1 html *', y
 wd 'set ', (>ZM{'xs';'s';'sm';'m';'ml';'l';'xl'),' value 1;'
 wd 'set ', (>FM{'menlo';'unifont'),' value 1;'
 wd 'pshow'
)

JIGDISPLAY=: 0 : 0
pc jigdisplay popup closeok;pn "Jig displays";
bin vh;
cc currentinfo static;cn "Select Current Displays";
cc savedinfo static;cn "Select Saved Displays";
bin zh;
minwh 240 20;cc current listbox;
minwh 240 20;cc saved listbox;
bin zh;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin szz;
pas 4 2;
rem form end;
)

enhanced_dj_button=: 3 : 0  
 t=. wd 'qform'
 wd JIGDISPLAY
 wd 'set current items ',; (DEL , ,&DEL)  each  2 <@;@{."1 [ 10{.titlelist 
 wd 'set saved items ',; (DEL , ,&DEL)  each  2 <@;@{."1 [ 10}.titlelist
 wd 'pmove ', (": _200 100  + 2{.". t) , ' 270 290'
 wd 'pshow;'
)

jigdisplay_ok_button=: 3 : 0
 ndx1=. ".current_select
 ndx2=. ".saved_select
 if. _2 ~: ndx1 + ndx2 do. NB. nothing selected show nothing just exit
  if. ndx1 ~: _1 do. showjig ndx1 {handlist end. NB. show current selected
  if. ndx2 ~: _1 do. showjig ndx2 {savelist end. end. NB. show saved selected
 wd 'psel jigdisplay;'
 wd 'pclose;'
)
showjig=: 3 : 0 
 wd 'psel *',y
 wd 'setp visible 1;'
 wd 'pshow;'
)

jigdisplay_enter=: jigdisplay_ok_button
jigdisplay_close=: jigdisplay_cancel=: jigdisplay_cancel_button=: wd bind 'pclose;'

enhanced_jctrl_fkey=: labs_run_jqtide_ bind 0
htmpack=: 3 :'''<hmtl><head><meta charset="UTF-8">'', (CSS rplc ''<FONT>'';FONT),''</head><body>'', y ,''</body></html>'''
cnv=:,/ @: > @: (8!:0)"1 NB. converts _20 to -20 for svg text and justifies appropriately
sc=: 3 : '((1 >. % SCALE)* ])  y'
lbtt=: 3 : ';"1 {&a. each (<194 160) (I. @:((<32)=])) }"1 boxutf y' NB. substitutes 194 160 for 32 in tooltips for nbsp
anim=:'<set attributeName="fill-opacity" to="1" /><animate attributeName="fill-opacity" begin="mouseover" from="1" to="0" calcMode="linear" dur="0.5" fill="freeze" /><animate attributeName="fill-opacity" begin="mouseout" from="0" to="1" calcMode="linear" dur="0.25" fill="freeze"/>'
DEPTH=: _1
SCALE=:1 NB. display zoom
ZM=: 3 NB. index for display zoom
FM=: 0 NB. index for display f0nt
FONT=: >FM{'menlo';'unifont' NB. options to be 0-menlo for looks and 1-unifont for spacing of unprintables

visual=: 4 : 0 NB. main verb that collects input, checks for errors then sends for processing, takes these results and wraps them up to be displayed by webdisplay. Retains information on the current window to track multiple displays.
cocurrent > {: x
if. >{. x do. vobj_jig_=. findline_jig_ y  else. vobj_jig_=.y  end. NB. if true then process current line, if false then just a window redraw for size or font don't want to go back to the line.
if. _1~: t_jig_=. 4!:0 <vobj_jig_ do. try. t_jig_ =. 4!:0 <'prox_jig_'[ ". 'prox_jig_=. ', vobj_jig_ catch. t=._2 end. end.  
cocurrent 'jig'
 select. t
  case. _2 do. try. ". vobj catch. tm=. 0 vgalt ": >"1 <;. _2 [ 13!:12 '' end.
  case. _1 do. tm=. 0 vgalt  '|value error: ', vobj,'_',(>{:x),'_'
  case.  0 do. tm=. (0;0;0;a:) vg prox
  case.    do. tm=. t vgalt vobj
 end.
'fW fH'=.   (sc 200 120) + 3 5 {::"0 _ tm 
tm=.  ; (3&{. , ":@(3&{::) ; 4&{ , ":@(5&{::) ; {:) tm  NB. changes format on width and height 
tm=.'<svg width="',(": SCALE * fW),'" height="',(": SCALE * fH),'" viewbox="',(cnv sc _180) ,' ',(cnv sc _85),' ', (": fW,fH),'" preserveAspectRatio="xMidYMin meet" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >',tm,'</svg>'
((vobj;{:x); 100 + fW , fH) webdisplay htmpack tm   NB. x is input line boxed to locale, y is the svg representation.
(i.0 0) 
)

vgalt=: 4 : 0
'<rect ';'stroke="white" fill="#fff"';'" width="';(10.5+ 9.59 * {: $ ": ": y);'" height="';0;'"></rect>',,'<text font-family="courier" style="',"1(x{:: 'fill:red; stroke-width:0.7;';'fill:gold; stroke-width:0.5;';'fill:purple; stroke-width:0.2;';'fill:blue; stroke-width:0.4;'),"1'" y="',"1( cnv ,. 20 * i. {. $ ,:^:(2>#@$) y),"1'">',"1 (":y) ,"1 '</text>'
)

vg=: 3 : 0"1 _ NB. selects correct parsing depending on type and if empty shape
(0;0;1;a:) vg y
:
s=.>( 0 e. $ y) { (typ=. datatype y);'z'
select. s
 case.'z'        do. (typ;x) zerosvg y
 case.('sparse boolean';'sparse integer';'sparse floating';'sparse complex';'sparse boxed') do. typ spsvg y 
 case.'literal'  do.   x litsvg y 
 case.'unicode'  do.   x unisvg y 
 case.'unicode4' do.   x vnisvg y 
 case.'symbol'   do.   x symsvg y
 case.'boxed'    do.   x bxsvg y
 case.'boolean'  do.   x boosvg y
 case.'integer'  do.   x intsvg y 
 case.'extended' do.   x extsvg y 
 case.'floating' do.   x flosvg y
 case.'rational' do.   x ratsvg y
 case.'complex'  do.   x comsvg y 
end.
)

zerosvg=: 4 : 0 NB. empty shapes case for all types
'typ depth s b path'=.x
if. s do. 34;32;'<rect class="syb" x="15.5" y="7" width="14.39" rx="2">',(tooltip '<h1> UTF-8 : 0 </h1>'),'</rect><text font-family="',FONT,'" font-size="0.8em" x="18.5" y="20"> </text>' NB. case for s: 0{a.  which has shape 0
      else. tt=. lbtt '<h1> ',(; (('sparse boolean';'sparse integer';'sparse floating';'sparse complex';'sparse boxed';'literal';'unicode';'unicode4';'symbol';'boxed';'boolean';'integer';'extended';'floating';'rational';'complex') i. <typ){ ('Sparse Boolean';'Sparse Integer';'Sparse Floating';'Sparse Complex';'Sparse Boxed';'Literal';'Unicode';'Unicode4';'Symbol';'Box';'Boolean';'Integer';'Extended';'Floating';'Rational';'Complex')),' <br> Shape: ',(":$y),(; b{'';(' <br> <br> Depth: ',(":depth),'<br> Path: ',(}: path))),' </h1>'
           '<rect class="';('z',": (*@:# + *@:#@:, + *@:(+/)@:$) y);'" width="';( 6 + (8 * {:)`(0:) @.(0-:{:)$ y);'" height="';(14 + 18 *  */@:}:@:$ y);'" rx="6"',tooltip tt end.
)

nmercal=: 4 : 0
'xc typ'=. x [ yc=. cnv ,. 24 + 17 * i. # vals=. y
if. typ -: 'boxed' do. vals=. '<tspan stroke="red" fill="red" stroke-width="1">',"1 y ,"1 '</tspan>' 
                   elseif. typer=.('fc'i.{.typ){'ej '  do.  vals=. vals rplc"1 typer ; '<tspan fill="white" stroke-width="0.75">', typer ,'</tspan>' end.
vals=. <"1 vals
;(<'<text class="'),"1 (<{.typ) ,"1 (< '" x="'),"1 (<xc) ,"1(<'" y="'),"1 (,.<"1 yc) ,"1 (<'" width="9.59" height="18">'),"1 (,., vals) ,"1 <'</text>'   
)

spsvg=: 4 : 0 NB. sparse types case
se=.>(x -: 'sparse boxed'){(": 3 $. y);'a:' NB. Sparse element designated a: if sparse boxed type
sep=.9.59 * {: $ ind=. t {."1 m  [ v=.(t + 1)}."1 m [ t=.(1 I.~ =&(25{a.)){. m=.":  y 
tt=. lbtt '<h1> Sparse ',(;(1<#2 $. y){'Index: ';'Indices: '),(": 2$.y),' <br> Array Shape: ',(": $ y),' </h1>'
tm=. '<rect  rx="6" stroke="none" fill="#fff" x="7" y="9" width="',(": sep),'" height="',(": 2 + 17 * # m),'"',(tooltip tt),((": 11.5 );'i') nmercal  ind
tt=. lbtt '<h1> Non-Sparse Entries: ',(": 7 $. y),' <br> Value Type: ',(; (('sparse boolean';'sparse integer';'sparse floating';'sparse complex';'sparse boxed') i. <x){ ('Boolean';'Integer';'Floating';'Complex';'Boxed')),' <br> Sparse Element: ',se,' </h1>'
tb=. '<rect rx="6" fill="#fff" x="',(": 26.5 + sep),'" y="9" width="',(": 4.8 + 9.59 * {: $ v ),'" height="',(": 2 + 17 * # m),'"',(tooltip tt),((": 11.5 );'i') nmercal  ind 
tm=.,(((": 12 + sep);'p') nmercal ,. (# m) # '|'),tm, tb,((": 23 + sep) ; 7 }. x) nmercal v
tt=. lbtt '<h1> ',(; (('sparse boolean';'sparse integer';'sparse floating';'sparse complex';'sparse boxed') i. <x){ ('Sparse Boolean';'Sparse Integer';'Sparse Floating';'Sparse Complex';'Sparse Boxed')),' <br> Array Shape: ', (": $ y),' </h1>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(30 + 9.59 * {: $ m);'" height="';(20 + 17 * # m);'" rx="6"',(tooltip tt),tm
)

boxutf=: 3 : 0"1
a=.a: [ t=.3 u: y
while. #t do.
 select. s=. 127 191 223 239 I. {. t
  case. (0;1) do. t=.}.t [ a=.a,< {.t                   
  case.       do. if. 0={:t1=.s{.t do. a=.a,<"0 t1-.0 
                                   elseif. 191 < >./ }.t1 do. a=.a,<"0 s{.t1 [ s=.>:@:(1 i.~ 191 < }.) t1
                                   elseif.                do. a=.a,< t1   end. t=. s }.t
 end.
end.
}.a
)
mask=:(-@<:@# }. ((,@#,:) , 0:)/) @ (}:@$ , 1:)
rsfiy=:,.@:(({:@$ # 18*(# i.@#)@mask)`0:@.(''-:$)) NB. mask used to generate y position values
valclean=:>@(('&#9484;';'&#9516;';'&#9488;';'&#9500;';'&#9532;';'&#9508;';'&#9492;';'&#9524;';'&#9496;';'&#9474;';'&#9472;') {~ ((16+i.11) {a.) &i.) NB. box characters insertion
lc=:,@:(-.&a:each)@:<"1@:(-.&a:each)@:((13;10)&(+/\.@:(+./@:(=/)-E.)</.])"1)
unb=:(mask (#^:_1)!.(<a:) ,)

encode=: > @: -.&a: @: , @: (":each)   NB. creates list of boxed encodings in literal type, removes empty boxes and opens into an n X encoding stack, where n is the number of literals encoded
rind=:  ,.@:,@:(_1&(|.!.0)@(+/\@:;@:(#&.>))"1)
lind=: ($@:, $ }:"1@($ #: i.@:#@:,)) NB. takes listatom boxutf y and returns the left indices in the path. Each line is the path of the distinct element of y
newpath=: (":"1)@:(,@:(a:&~: ) # (lind,.rind)) NB. creates a path using rind to ensure that unicodes in literal format alter the path appropriately eg. 'a',(": 9 u: 128512), 'b' create a rind of 0 1 5

tooltip=: (' onclick="alert(''' ,"1 ,"1 & ''')" ><title>' ,"1  ,"1 & '</title></rect>')  NB. fork that takes tt as argument to insert into onclick and tooltip string

litsvg=: 4 : 0 NB. literal case
'depth s b path'=. x 
if. b do. yc=.,.(msk=.a:~: ,lit) # rsfiy lit=. boxutf y 
          lit=. ,-.&a: each <"1 -.&a: lit [ xw=.  msk # , xw [xc=.,. msk # , 0&,@}:@(+/\)"1 xw=.(9.59 + s * 2) * >(((0.5+1.5*FM)"_)`1:`((0.5+1.5*FM)"_)`#@.( 15 26 31 I. {.))each lit 
      else. yc=.,.( ([ S:0 (# each each lit) ) # (18 * _1 |.!.0 +/\)) @:;@: (;@:(}: , >:@:;each@:{:) each) @: (+/@:((10;13)e.{:) each each) lit=. unb lc boxutf y 
            xw=. ; xw [ xc=. ,.  ; 0&,@}:@(+/\) each xw=.((9.59 + s * 4.8)&* each) (((0.5+1.5*FM)"_)`(12"_)`((0.5+1.5*FM)"_)`1:`((0.5+1.5*FM)"_)`(#@:>)@.(8 9 15 26 31 I. {.@:>))"0  each lit=.-.&a: ;lit end.
if. s do.   tt=. lbtt '<h1> UTF-8: ',"1 (encode boxutf y) ,"1 '</h1> '
      else. tt=. lbtt '<h1> UTF-8: ',"1 (encode boxutf y) ,"1 '<br> Path: ' ,"1 path ,"1  (newpath  boxutf y) ,"1 '</h1> ' end.
tm=. '<rect class="',"1(s{::((,. -.&(<'') , 33&>@:{.each S:1 lit){::'lb';'lc');'syb'),"1'" x="',"1(": (s * 12)+ xc+3.5),"1'" y="',"1(":yc+7),"1'" width="',"1 (": ,. , xw),"1 '" rx="2"' ,"1 tooltip tt
vals=. ;@:,.@:(;"1@:,.@:((' '"_)`(":@u:)`(valclean@:{&a.)`(({&a.))@.(0 15 26 I.{.) each) each)lit NB. vals raw values cleaned to show box characters in svg
tm=. ,tm  ,"1 '<text class="',"1 (s{::'l';'sy'),"1'" x="',"1(cnv (s * 14)+xc+4.5),"1'" y="',"1(cnv yc+20),"1'">',"1 vals ,"1 '</text>'
if. s do. (19.5 + >./  xw +&, xc);(32 + (18 * ({: ; lit) e. 10;13)+{: ,yc);tm NB. width height character string
    else. tt=.lbtt '<h1> Literal  <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';('<br> <br> Depth: ',(":depth),'<br> Path: ',(}: path))),' </h1>'
         '<rect class="';((1-: {. $ y){'jd');'" width="';(7.5 + >./  xw +&, xc);'" height="';(32 + (18* (-.b) * ({: ; lit) e. 10;13)+{: ,yc);'" rx="6" ',(tooltip tt),tm  end.
)

glfontextent_jgl2_ FONT,' 12' NB. sets fontspec for glqextent in wuf
wuf=: (9.59 * (* * 7&>. % 7:) @: (1&>.) @: {. @: glqextent_jgl2_ @: ":)
boxuni=: 3 : 0"1
a=.a: [ t=.3 u: y
while. #t do.
 select.  55295 57343 I. {. t
  case. (0;2) do. t=. }. t [ a=. a , < {. t
  case.       do. if. (56320&> +. 57343&<:) {: t1=.2 {. t  do. t=.  }. t [ a=.a , < {. t else. t=.2 }. t [ a=.a , < t1 end.                                                           
 end.
end.
}.a
)

unisvg=: 4 : 0 NB. unicode case
'depth s b path'=. x 
if. b do. yc=. ,. (msk=.a:~: ,uni2) # rsfiy uni2=. boxuni y 
          xc=.,. msk # , 0&,@}:@(+/\)"1 xw=.(># each   uni2) *  ,/"1 >(((9.59 * 0.5+1.5*FM)"_)`(9.59 *1:)`((9.59 *0.5+1.5*FM)"_)`(wuf@(7&u:)@,)@.( 15 26 31 I. {.))each uni2  
          uni21=. ,-.&a: each <"1 -.&a: uni2 [ xwv=. ": ,. xw=. msk # ; xw 
    else. yc=. ,.( ([ S:0 (# each each uni2) ) # (18 * _1 |.!.0 +/\)) @:;@: (;@:(}: , >:@:;each@:{:) each) @: (+/@:((10;13)e.{:) each each) uni2=. unb lc boxuni y 
          xc=. ,.  ; 0&,@}:@(+/\)@,"1 each xw=. ( ; each # each each uni21) * each xw=.((9.59 * 0.5+1.5*FM"_)`(9.59 * 12"_)`(9.59 * 0.5+1.5*FM"_)`(9.59"_)`(9.59 * 0.5+1.5*FM"_)`(wuf@(7&u:)@>)@.(8 9 15 26 31 I. {.@:>))"0  each uni21=.-.&a: ; uni2
          xwv=.": ,. xw=. ;xw  end.
if. s do.   tt=. lbtt '<h1> Unicode: ',"1 (encode  boxuni y),"1'</h1> '
      else. tt=. lbtt '<h1> Unicode: ',"1 (encode  boxuni y),"1 '<br> Path: ' ,"1 path ,"1 (newpath boxuni y) ,"1 '</h1> ' end.
tm=. '<rect class="',"1(s{::'ub';'syb'),"1'" x="',"1(": (s * 12)+ xc+5),"1'" y="',"1(":yc+7),"1'" width="',"1 xwv,"1'" rx="2" ',"1 tooltip tt
vals=.": ;@:,.@:(;"1@:,.@:((' '"_)`((9&u:)@:(9&u:))`(valclean@:{&a.)`((9&u:)@:(9&u:))@.(0 15 26 I.{.) each) each) uni21 NB. vals raw values cleaned to show box characters
tm=. ,tm  ,"1 '<text class="',"1(s{::'u';'sy'),"1 '" x="',"1(cnv (s * 12) + xc+6),"1'" y="',"1(cnv yc+20),"1'">',"1 vals ,"1 '</text>'
if. s do. (21.5+ >./  xw +&, xc);(32 + (18 * ({: ; uni2) e. 10;13)+{: ,yc); tm
    else. tt=.lbtt '<h1> Unicode  <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>' 
         '<rect class="';((1-: {. $ y){'jd');'" width="';(10.5 + >./  xw +&, xc);'" height="';(32 + (18* (-.b) * ({: ; uni21) e. 10;13)+{: ,yc);'" rx="6" ',(tooltip tt),tm  end.
)

vnisvg=: 4 : 0 NB. unicode4 case
'depth s b path'=. x
if. b do. yc=. ,. (msk=.a:~: ,uni4) # rsfiy  uni4=.  boxuni y 
          xc=. ,. msk # , 0&,@}:@ (+/\)"1 xw=.(> # each uni4) * ,/"1 >(((9.59 * 0.5+1.5*FM)"_)`(9.59 *1:)`((9.59 *0.5+1.5*FM)"_)`(wuf@(7&u:)@,)@.( 15 26 31 I. {.))each uni4  
          uni41=. ,-.&a: each <"1 -.&a: uni4 [ xwv=. ": ,. xw=. msk # ; xw
    else. yc=. ,.( ([ S:0 (# each each uni4) ) # (18 * _1 |.!.0 +/\)) @:;@: (;@:(}: , >:@:;each@:{:) each) @: (+/@:((10;13)e.{:) each each) uni4=. unb lc boxuni y 
          xc=. ,.  ; 0&,@}:@(+/\)@,"1 each xw=. ( ; each # each each uni41) * each ((9.59 * 0.5+1.5*FM"_)`(9.59 * 12"_)`(9.59 * 0.5+1.5*FM"_)`(9.59"_)`(9.59 * 0.5+1.5*FM"_)`(wuf@(7&u:)@>)@.(8 9 15 26 31 I. {.@:>))"0  each uni41=.-.&a: ; uni4
          xwv=. ": ,. xw=.; xw  end.  
if. s do.   tt=. lbtt '<h1> Unicode4: ',"1 (encode  boxuni y),"1 '</h1> '
      else. tt=. lbtt '<h1> Unicode4: ',"1 (encode  boxuni y),"1 '<br> Path: ' ,"1 path ,"1 (newpath boxuni y) ,"1 '</h1> ' end. 
tm=. '<rect class="',"1(s{::'u4';'syb'),"1'" x="',"1(": (s * 12)+ xc+5),"1'" y="',"1(":yc+6),"1'" width="',"1 xwv,"1'" rx="2" ',"1 ,"1 tooltip tt
vals=.": ;@:,.@:(;"1@:,.@:((' '"_)`((9&u:)@:(9&u:))`(valclean@:{&a.)`((9&u:)@:(9&u:))@.(0 15 26 I.{.) each) each) uni41 NB. vals raw values cleaned to show box characters
tm=. ,tm  ,"1 '<text class="',"1(s{::'v';'sy'),"1 '" x="',"1(cnv (s * 12) + xc+6),"1'" y="',"1(cnv yc+19),"1'">',"1 vals ,"1 '</text>'
if. s do. (21.5+ >./  xw +&, xc);(32 + (18 * ({: ; uni4) e. 10;13)+{: ,yc); tm
    else. tt=.lbtt '<h1> Unicode4 <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
         '<rect class="';((1-: {. $ y){'jd');'" width="';(10.5 + >./  xw +&, xc);'" height="';(32 + (18* (-.b) * ({: ; uni41) e. 10;13)+{: ,yc);'" rx="6" ',(tooltip tt),tm  end.
)

symsvg=: 4 : 0 NB. Symbols case: calls on litsvg, unisvg and vnisvg as needed to evaluate the labels. s flag ensures correct return of label format
'depth s b path'=. x 
ysvg=.  (depth;1;b;path)&vg each 5 s: y 
sW=.8 + >./ sw1 +&, sx=. }:@(0 , +/\)"1 sw1=.>./ sw=. >, <"1 [ 0 {::"1  >ysvg 
sh=. (1&>.@:{:@:$ y) # >./^:(2&<:@:#@:$)^:_  >./"1 [ 1 {::"1 > ysvg NB. >./^:(1&<:@:#@:$) swapped with , if the exception of 2 dimensions is covered
sH=.16 + sh +&{: sy=. (1&>.@:{:@:$y)&# , (mask y) ({."1@:([ # +/\ @:(0&,)@:}:@:(#!.20^:_1)))  >, <"1($y)&$ sh
'sx sw sh sy'=. ,.@,@(($y) $ ,) each sx ; sw ; sh ; sy NB. may be smoothed a bit just normalizing the number of items of sw may be useful to look at the ysvg=. > , <"1 ysvg trick
slt=.,. , datatype each 5 s:  y
tt=. lbtt '<h1>  Label Type: ',"1(;"1 slt),"1('     <br>  Index: '),"1(;"1(":each ,. , 6 s: y)),"1(' <br>  Total Symbols Assigned: '),"1(": 0 s: 0),"1'<br> <br>  Path: ' ,"1 path ,"1 (newpath y) ,"1 '</h1> '
tm=. '<svg x="';"1 sx ;"1'" y="';"1 sy ;"1'"><rect class=" ',"1((('unicode';'unicode4')i.slt){::'su';'sv';'sl'),"1'" width="',"1 (": ,. , sw ),"1'" height="',"1 (": ,. , sh),"1'" rx="3" ',"1 (tooltip tt) ,"1 '<text  class="s" x="2" y="18" >`</text>',"1'"><svg>',"1  (>ysvg=. ,. {. > , <"1 > , &.:> {: each ysvg),"1 '</svg></svg>' NB. red background of symbol last text element is ` stroke
tt=. lbtt '<h1> Symbol     <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';('     <br> <br> Depth: ',(":depth),'    <br> Path: ',(}: path))),' </h1>'
tm=. ;": each '<svg  x="4" y="8">';"1  tm ,"1<'</svg>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(sW);'" height="';(sH);'" rx="6" ',(tooltip tt),tm 
)

bxsvg=: 4 : 0 NB. boxed cases - sends contents through the process and boxes those results
'depth s b path'=. x
depth=.>: depth
ysvg=.  (<"1 ((depth ; s ; 1) ,"1 0 (path , ';',~": )each <"1 '(0$0)'"_^:(1-:#@$) ($ $ (#: i.@:(*/))@$)  y))vg &> y 
bW=.16 + bw +&{: bx=. }: 0 , +/\  <: bw=.>./  > , <"1 [ 3 {::"1  ysvg
bh=. (1&>.@:{:@:$ y) # >./^:(2&<:@:#@:$)^:_  >./"1 [ 5 {::"1 ysvg NB. >./^:(1&<:@:#@:$) swapped with , if the exception of 2 dimensions is covered
bH=.32 + bh +&{: by=. (1&>.@:{:@:$y)&# , (mask y) ({."1@:([ # +/\ @:(0&,)@:}:@:(#!.20^:_1)))  >, <"1($y)$ <: bh 
'bx bw bh by'=. ,.@,@(($y)&$) each bx ; bw ; bh ; by NB. may be smoothed a bit just normalizing the number of items of bw may be useful to look at the ysvg=. > , <"1 ysvg trick
tm=. (<"1 '<g><rect class="x" width="',"1 (": ,. bw) ,"1'" height="',"1 (":,. bh) ,"1'" ></rect><rect class="'),.(1&{"1 ysvg),.(<'" stroke-width="2" width="') ,. (<"0 bw) ,.(<'" height="'),. (<"0 bh) ,. ,. 7&}. each {:"1 ysvg=. > , <"1 ysvg
tt=. lbtt '<h1> Box  <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(": <:depth),'<br> Path: ',(}: path))),' </h1> '
tm=. ; ": each '<svg  x="';"1((4*b)+ 4+ bx);"1'" y="';"1(17+by);"1'" width="';"1 bw;"1'" height="';"1 bh;"1'">';"1  tm ,"1<'</svg>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(bW- 8 * -. b);'" height="';(bH);'" rx="6" onclick="alert(''',"1 tt ,"1''')" ><title>',"1 tt ,"1'</title></rect>',tm 
)

boosvg=: 4 : 0 NB. numeric case - boolean  
'depth s b path'=. x 
tt=.lbtt '<h1> Boolean  <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
tm=. ;(<'<text class="b" x="4" y="'),. (cnv each 20+ 18x *(# i.@#)@mask y),. (<'" textLength="'),. (<cnv tl=.<. 96r10 * {:$":y),. (<'" lengthAdjust="spacingAndGlyphs" >'),. (,. , <"1  ": y) ,. <'</text>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(<.9 + tl);'" height="';(14 + 18x * # mask  y);'" rx="6"',(tooltip tt),tm
)

intsvg=: 4 : 0 NB. numeric case - integer 
'depth s b path'=. x 
tt=.lbtt '<h1> Integer <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
tm=. ;(<'<text class="i" x="4" y="'),. (cnv each 20+ 18x *(# i.@#)@mask y),. (<'" textLength="'),. (<cnv tl=.<. 96r10 * {:$":y),. (<'" lengthAdjust="spacingAndGlyphs" >'),. (,. , <"1  ": y) ,. <'</text>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(<.9 + tl);'" height="';(14 + 18x * # mask  y);'" rx="6"',(tooltip tt),tm
)

extsvg=: 4 : 0 NB. numeric case - extended  
'depth s b path'=. x 
tt=.lbtt '<h1> Extended <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
tm=. ;(<'<text class="e" x="4" y="'),. (cnv each 20+ 18x *(# i.@#)@mask y),. (<'" textLength="'),. (<cnv tl=.<. 96r10 * {:$":y),. (<'" lengthAdjust="spacingAndGlyphs" >'),. (,. , <"1  ": y) ,. <'</text>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(<.9 + tl);'" height="';(14 + 18x * # mask  y);'" rx="6"',(tooltip tt),tm
)

flosvg=: 4 : 0 NB. numeric case - floating  
'depth s b path'=. x 
tt=.lbtt '<h1> Floating <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
vals=. ,. , (": y) <@rplc"1 'e';'<tspan class="fa">e</tspan>'
tm=. ;(<'<text class="f" x="4" y="'),. (cnv each 20+ 18x *(# i.@#)@mask y),. (<'" textLength="'),. (<cnv tl=.<. 96r10 * {:$":y),. (<'" lengthAdjust="spacingAndGlyphs" >'),.  vals ,. <'</text>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(9 + tl);'" height="';(14 + 18x * # mask  y);'" rx="6"',(tooltip tt),tm
)

ratsvg=: 4 : 0 NB. numeric case - rational  
'depth s b path'=. x 
tt=.lbtt '<h1> Rational <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
vals=. ,. , (": y) <@rplc"1 'r';'<tspan class="ra">r</tspan>'
tm=. ;(<'<text class="r" x="4" y="'),. (cnv each 20+ 18x *(# i.@#)@mask y),. (<'" textLength="'),. (<cnv tl=.<. 96r10 * {:$":y),. (<'" lengthAdjust="spacingAndGlyphs" >'),.  vals ,. <'</text>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(9 + tl);'" height="';(14 + 18x * # mask  y);'" rx="6"',(tooltip tt),tm
)

comsvg=: 4 : 0 NB. numeric case - complex  
'depth s b path'=. x 
tt=.lbtt '<h1> Complex <br> Shape: ',((''-:  $ y){::((":  $ y);'atom')),(; b{'';(' <br> <br> Depth: ',(":depth),' <br> Path: ',(}: path))),' </h1>'
vals=. ,. , (": y) <@rplc"1 'j';'<tspan class="ja">j</tspan>'
tm=. ;(<'<text class="c" x="4" y="'),. (cnv each 20+ 18x *(# i.@#)@mask y),. (<'" textLength="'),. (<cnv tl=.<. 96r10 * {:$":y),. (<'" lengthAdjust="spacingAndGlyphs" >'),.  vals ,. <'</text>'
'<rect class="';((1-: {. $ y){'jd');'" width="';(9 + tl);'" height="';(14 + 18x * # mask  y);'" rx="6"',(tooltip tt),tm
)

findline =: 3 : 0    NB. WinSelect is a character index; WinText is entire window; if window contains non-ASCII, convert to unicode
  if. y do. ; }. ;:(#~ -.@:(*./\)@:=&' ') ": > {: < ;. _2 (wd'sm get inputlog'), LF NB. pull the last line only for the monadic case Programmatic version strip off first word which would be invoking verb
        else. (#~ -.@:(*./\)@:=&' ') ": ({. WinSelect_jqtide_) ((LF&taketo&.|.)@:{. , LF&taketo @:}.)  7 u: WinText_jqtide_  end.NB. The line that the cursor is on if 0 - Function key version
)

jig_z_ =:   3 : '((1;coname 0$0) visual_jig_ 1:) y'
init ''
