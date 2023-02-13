NB. Version 2.0 for this add on - Working copy with tests runjig805
NB.coerase <'jig' NB. clear previous jig variables, helps in updates

cocurrent'jig' NB. Set the defining locale as jig
require 'gl2'

DISPLAY=: 0 : 0 NB. Form that contains the display as well as zoom and font buttons
pc enhanced;
bin h;
cc w1 webview;
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
)

SCALE=:1 NB. display zoom
ZM=: 3 NB. index for display zoom
FM=: 0 NB. index for display f0nt
FONT=: >FM{'menlo';'unifont' NB. options to be 0-menlo for looks and 1-unifont for spacing of unprintables

webdisplay=: 4 : 0 NB. Displays the results in webview for jqt environment and returns ID of window
wd DISPLAY
wd 'pn *', > {. x
wd 'set w1 wh *', ": 200 170>. (_225 _200 + 2 3 { ". wd 'qscreen') <. SCALE * > {: x
wd 'set w1 html *', y
wd 'set ', (>ZM{'xs';'s';'sm';'m';'ml';'l';'xl'),' value 1;'
wd 'set ', (>FM{'menlo';'unifont'),' value 1;'
wd 'pshow'
wd 'qhwndp;'
)

enhanced_menlo_button=: 3 : 'font 0'
enhanced_unifont_button=: 3 : 'font 1'

font=: 3 : 0
FM=: y [ FONT=: >y{'menlo';'unifont'
vobj=. ". 'handle',wd 'qhwndp;' [ loc=. ". 'locale',wd 'qhwndp;'
loc visual vobj [ enhanced_close ''
)

enhanced_xs_button=: 3 : 'zoom ''xs'''
enhanced_s_button=:3 : 'zoom ''s''' 
enhanced_sm_button=: 3 : 'zoom ''sm'''
enhanced_m_button=: 3 : 'zoom ''m'''
enhanced_ml_button=: 3 : 'zoom ''ml'''
enhanced_l_button=: 3 : 'zoom ''l'''
enhanced_xl_button=: 3 : 'zoom ''xl'''

zoom=: 3 : 0
SCALE=: (ZM { 0.1 0.2 0.5 1 2 3 4) [ZM=:(<y)i.~ 'xs';'s';'sm';'m';'ml';'l';'xl'
vobj=. ". 'handle',wd 'qhwndp;' [ loc=. ". 'locale',wd 'qhwndp;'
loc visual vobj [ enhanced_close ''
)

enhanced_close=: 3 : 'wd ''pclose''[ erase ''handle'',wd ''qhwndp;''[ erase ''locale'',wd ''qhwndp;'''
enhanced_jctrl_fkey=: labs_run_jqtide_ bind 0
htmpack=: 3 :'''<hmtl><head><meta charset="UTF-8">'',''</head><body>'', y ,''</body></html>'''
cnv=:,/ @: > @: (8!:0) NB. converts _20 to -20 for svg text and justifies appropriately
sc=: 3 : '((1 >. % SCALE)* ])  y'
B=: 32{a. NB. non line-breakable blank for tooltips
anim=:'<set attributeName="fill-opacity" to="1" /><animate attributeName="fill-opacity" begin="mouseover" from="1" to="0" calcMode="linear" dur="0.5" fill="freeze" /><animate attributeName="fill-opacity" begin="mouseout" from="0" to="1" calcMode="linear" dur="0.25" fill="freeze"/>'

visual=: 4 : 0 NB. main verb that collects input, checks for errors then sends for processing, takes these results and wraps them up to be displayed by webdisplay. Retains information on the current window to track multiple displays.
cocurrent > {: x
if. >{. x do. vobj_jig_=. findline_jig_ y else. vobj_jig_=.y end. NB. if true then process current line, if false then just a window redraw for size or font don't want to go back to the line.
if. _1~: t_jig_=. 4!:0 <vobj_jig_ do. try. t_jig_ =. 4!:0 <'prox_jig_'[ ". 'prox_jig_=. ', vobj_jig_ catch. t=._2 end. end.  
cocurrent 'jig'
 select. t
  case. _2 do. try. ". vobj catch. tm=. 0 vgalt ": >"1 <;. _2 [ 13!:12 '' end.
  case. _1 do. tm=. 0 vgalt  '|value error: ', vobj,'_',(>{:x),'_'
  case.  0 do. tm=. (0;0) vg prox
  case.    do. tm=. t vgalt vobj
 end.
'fW fH'=.   (sc 200 120) + 3 5 {::"0 _ tm 
tm=.  ; (3&{. , ":@(3&{::) ; 4&{ , ":@(5&{::) ; {:) tm
tm=.'<svg width="',(": SCALE * fW),'" height="',(": SCALE * fH),'" viewbox="',(cnv sc _180) ,' ',(cnv sc _85),' ', (": fW,fH),'" preserveAspectRatio="xMidYMin meet" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >',tm,'</svg>'
ID=:":(vobj; 1.2 * fW , fH) webdisplay htmpack tm   
(i.0 0)[('handle',ID)=:vobj [ ('locale',ID)=: 0;>{:x
)

vgalt=: 4 : 0
'<rect ';'stroke="white" fill="#fff"';'" width="';(10.5+ 9.59 * {: $ ": ": y);'" height="';0;'"></rect>',,'<text font-family="courier" style="',"1(x{:: 'fill:red; stroke-width:0.7;';'fill:gold; stroke-width:0.5;';'fill:purple; stroke-width:0.2;';'fill:blue; stroke-width:0.4;'),"1'" y="',"1( cnv ,. 20 * i. {. $ ,:^:(2>#@$) y),"1'">',"1 (":y) ,"1 '</text>'
)

vg=: 3 : 0 NB. selects correct parsing depending on type and if empty shape
(0;1) vg y
:
select. >( 0 e. $ y) { (typ=. datatype y);'z'
 case.'z'        do. (typ;{.x) zerosvg y
 case.('sparse boolean';'sparse integer';'sparse floating';'sparse complex') do. typ spsvg y 
 case.'literal'  do.   x litsvg y 
 case.'unicode'  do.   x unisvg y 
 case.'unicode4' do.   x vnisvg y NB.else. vnisvgu y end.
 case.'symbol'   do.   x symsvg y
 case.'boxed'    do.   x bxsvg y
 case.'boolean'  do.     boosvg y
 case.'integer'  do.     intsvg y
 case.'extended' do.     extsvg y 
 case.'floating' do.     flosvg y
 case.'rational' do.     ratsvg y
 case.'complex'  do.     comsvg y 
end.
)

zerosvg=: 4 : 0 NB. empty shapes case for all types
'typ s'=.x
if. s do. 34;32;'<rect x="15.5" y="7" width="14.39" height="18" stroke="red" fill="white" rx="2"></rect><title> UTF-8 : 0</title></rect><text font-family="',FONT,'" font-size="0.8em" x="18.5" y="20"> </text>' NB. case for s: 0{a.  which has shape 0
      else.tt=. '<title>',(30#'='),(65{.!.B ' Type',B,':',B,typ),(40{.' Shape',B,':',B,(":$y)),(30#'='),'</title>'
           ('<g><rect rx="6" fill="#96C" width="',(":6 + (8 * {:)`(0:) @.(0-:{:)$ y),'" height="',(":14 + 18 *  */@:}:@:$ y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(* +/ $ y){::'fill="#bbb"';'fill="#666"');'" width="';(6 + (8 * {:)`(0:) @.(0-:{:)$ y);'" height="';(14 + 18 *  */@:}:@:$ y);'">',tt,'</rect>',anim,'</g>' end.
)

nmercal=: 4 : 0
'xc typ'=. x [ yc=. cnv ,. 24 + 17 * i. # vals=.  y   
if. (typer=.('fc'i.typ){'ej ')~:' 'do. vals=.  vals rplc"1 typer ; '<tspan fill="white" stroke-width="0.75">', typer ,'</tspan>' end.
,'<text x="',"1 xc ,"1'" y="',"1 yc ,"1'" width="9.59" height="18" ',"1(;(('b';'i';'f';'c';'p')i.(<typ)){'fill="white" stroke="black" font-weight="bold"';'fill="black" stroke="none" font-weight="normal"';'fill="#44F" stroke="black" stroke-width="0.5" font-weight="bold"';'fill="#040" font-style="italic" stroke="black" stroke-width="0.2" font-weight="bold"';'fill="red" stroke-width="0.4" font-weight="bold"'),"1' font-family="courier" pointer-events="none" xml:space="preserve" text-anchor="start">',"1 vals ,"1 '</text>'
)

spsvg=: 4 : 0 NB. sparse types case
sep=.9.59 * {: $ ind=. t {."1 m  [ v=.(t + 1)}."1 m [ t=.(1 I.~ =&(25{a.)){. m=.":  y 
tt=. '<title>',(30#'='),(60({.!.B)' Sparse',B,(;(1<#2 $. y){'Index : ';'Indices : '),(": 2$.y)),(40{.' Array Shape',B,':',B, (": $ y)),(30#'='),'</title>'
tm=. '<g><rect rx="6" stroke="none" fill="#96C" x="7" y="9" width="',(": sep),'" height="',(": 2 + 17 * # m),'" fill-opacity="1"></rect><rect overflow="visible" rx="6" stroke="none" fill="#fff" x="7" y="9" width="',(": sep),'" height="',(": 2 + 17 * # m),'">',tt,'</rect>',anim,'</g>',((": 11.5 );'i') nmercal  ind
tt=. '<title>',(35#'='),(55({.!.B)' Non-Sparse',B,'Entries',B,':',B,(": 7 $. y)),(55({.!.B)' Value',B,'Type',B,':',B,(7 }. datatype y)),(40{.' Sparse',B,'Element',B,':',B,(": 3 $. y)),(35#'='),'</title>'
tb=. '<g><rect rx="6" fill="#96C" x="',(": 26.5 + sep),'" y="9" width="',(": 4.8 + 9.59 * {: $ v ),'" height="',(": 2 + 17 * # m),'" fill-opacity="1"></rect><rect rx="6" fill="#fff" x="',(": 26.5 + sep),'" y="9" width="',(": 4.8 + 9.59 * {: $ v ),'" height="',(": 2 + 17 * # m),'">',tt,'</rect>',anim,'</g>',((": 11.5 );'i') nmercal  ind 
tm=.(((": 12 + sep);'p') nmercal ,. (# m) # '|'),tm, tb,((": 23 + sep) ; {. 7 }. x) nmercal v
tt=. '<title>',(35#'='),(55({.!.B)' Type',B,':',B,x),(40{.' Array',B,'Shape ',B,':',B, (": $ y)),(35#'='),'</title>'
('<g><rect rx="6" fill="#96C" width="',(": 30 + 9.59 * {: $ m),'" height="',(": 20 + 17 * # m),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(30 + 9.59 * {: $ m);'" height="';(20 + 17 * # m);'">',tt,'</rect>',anim,'</g>',tm 
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

mask=:((1+i:&1) {. ]) @ (((,@#,:) , 0:)/) @ (}:@$ , 1:)
rsfiy=:,.@:(({:@$ # 18*(# i.@#)@mask)`0:@.(''-:$)) NB. mask used to generate y position values
valclean=:>@(('&#9484;';'&#9516;';'&#9488;';'&#9500;';'&#9532;';'&#9508;';'&#9492;';'&#9524;';'&#9496;';'&#9474;';'&#9472;') {~ ((16+i.11) {a.) &i.) NB. box characters insertion
lc=:,@:(-.&a:each)@:<"1@:(-.&a:each)@:((13;10)&(+/\.@:(+./@:(=/)-E.)</.])"1)
unb=:(mask (#^:_1)!.(<a:) ,)

litsvg=: 4 : 0 NB. literal case
's b'=. x
if. b do. yc=.,.(msk=.a:~: ,lit) # rsfiy lit=. boxutf y 
          lit=. ,-.&a: each <"1 -.&a: lit [ xw=.  msk # , xw [xc=.,. msk # , 0&,@}:@(+/\)"1 xw=.(9.59 + s * 2) * >(((0.5+1.5*FM)"_)`1:`((0.5+1.5*FM)"_)`#@.( 15 26 31 I. {.))each lit 
      else. yc=.,.( ([ S:0 (# each each lit) ) # (18 * _1 |.!.0 +/\)) @:;@: (;@:(}: , >:@:;each@:{:) each) @: (+/@:((10;13)e.{:) each each) lit=. unb lc boxutf y 
            xw=. ; xw [ xc=. ,.  ; 0&,@}:@(+/\) each xw=.((9.59 + s * 4.8)&* each) (((0.5+1.5*FM)"_)`(12"_)`((0.5+1.5*FM)"_)`1:`((0.5+1.5*FM)"_)`(#@:>)@.(8 9 15 26 31 I. {.@:>))"0  each lit=.-.&a: ;lit end.
tt=.'<title>',"1(20#'='),"1 (26({.!.B)"1 (' UTF-8',B,':',B),"1 ;@:(>@:(": each)each) lit),"1' ',"1 (20#'='),"1'</title>'
tm=. '<g><rect fill="#96C"',"1 ' x="',"1(": (s * 12)+ xc+3.5),"1'" y="',"1(":yc+7),"1'" width="',"1 (": ,. , xw),"1'" height="18" rx="2" fill-opacity="1"></rect><rect ',"1(s{::((,. -.&(<'') , 33&>@:{.each S:1 lit){::'fill="#004225" stroke="gold"';'fill="#008825" stroke="gold"');'fill="white" stroke="red"'),"1' x="',"1(": (s * 12)+ xc+3.5),"1'" y="',"1(":yc+7),"1'" width="',"1 (": ,. , xw),"1'" height="18" rx="2">',"1 tt ,"1'</rect>',"1 anim,"1'</g>'
vals=. ;@:,.@:(;"1@:,.@:((' '"_)`({&a.)`(valclean@:{&a.)`(({&a.))@.(0 15 26 I.{.) each) each)lit NB. vals raw values cleaned to show box characters in svg
tm=. ,tm  ,"1 '<text font-family="',"1 FONT,"1'" font-weight="normal" stroke="none" font-size="0.8em" pointer-events="none" text-anchor="start" xml:space="preserve" ',"1 (s{::'fill="gold" ';'fill="black"'),"1'" x="',"1(cnv (s * 14)+xc+4.5),"1'" y="',"1(cnv yc+20),"1'">',"1 vals ,"1 '</text>'
if. s do. (19.5 + >./  xw +&, xc);(32 + (18 * ({: ; lit) e. 10;13)+{: ,yc);tm NB. width height character string
    else. tt=. '<title>',(30#'='),(70({.!.B)' Type',B,':',B,'literal',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
         ('<g><rect rx="6" fill="#96C" width="',(": 7.5 + >./  xw +&, xc),'" height="',(": 32 + (18* (-.b) * ({: ; lit) e. 10;13)+{: ,yc),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7.5 + >./  xw +&, xc);'" height="';(32 + (18* (-.b) * ({: ; lit) e. 10;13)+{: ,yc);'">',tt,'</rect>',anim,'</g>',tm end.
)

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

glfontextent_jgl2_ FONT,' 12' NB. sets fontspec for glqextent in wuf
wuf=: (9.59 * (* * 7&>. % 7:) @: (1&>.) @: {. @: glqextent_jgl2_ @: ":)


unisvg=: 4 : 0 NB. unicode case
's b'=. ({.,{:) x 
if. b do. yc=. ,. (msk=.a:~: ,uni2) # rsfiy uni2=. boxuni y
          xc=.,. msk # , 0&,@}:@(+/\)"1 xw=.(># each   uni2) *  ,/"1 >(((9.59 * 0.5+1.5*FM)"_)`(9.59 *1:)`((9.59 *0.5+1.5*FM)"_)`(wuf@(7&u:)@,)@.( 15 26 31 I. {.))each uni2  
          uni21=. ,-.&a: each <"1 -.&a: uni2 [ xwv=. ": ,. xw=. msk # ; xw 
    else. yc=. ,.( ([ S:0 (# each each uni2) ) # (18 * _1 |.!.0 +/\)) @:;@: (;@:(}: , >:@:;each@:{:) each) @: (+/@:((10;13)e.{:) each each) uni2=. unb lc boxuni y
          xc=. ,.  ; 0&,@}:@(+/\)@,"1 each xw=. ( ; each # each each uni21) * each xw=.((9.59 * 0.5+1.5*FM"_)`(9.59 * 12"_)`(9.59 * 0.5+1.5*FM"_)`1:`(9.59 * 0.5+1.5*FM"_)`(wuf@(7&u:)@>)@.(8 9 15 26 31 I. {.@:>))"0  each uni21=.-.&a: ; uni2
          xwv=. ": ,.  xw=. ;xw  end. 
tt=.'<title>',"1(20#'='),"1 (26({.!.B)"1 (' Unicode',B,':',B),"1 (;@:(>@:(": each)each) uni21)),"1' ',"1 (20#'='),"1'</title>'
tm=. '<g><rect fill="#96C"',"1 ' x="',"1(": (s * 12)+ xc+5),"1'" y="',"1(":yc+7),"1'" width="',"1 (": xwv),"1'" height="18" rx="2" fill-opacity="1"></rect><rect ',"1(s{::'fill="yellow" stroke="gold"';'fill="white" stroke="red"'),"1' x="',"1(": (s * 12)+ xc+5),"1'" y="',"1(":yc+7),"1'" width="',"1 (": xwv),"1'" height="18" rx="2">',"1 tt ,"1'</rect>',"1 anim,"1'</g>'
vals=.": ;@:,.@:(;"1@:,.@:((' '"_)`((9&u:)@:(9&u:))`(valclean@:{&a.)`((9&u:)@:(9&u:))@.(0 15 26 I.{.) each) each) uni21 NB. vals raw values cleaned to show box characters
tm=. ,tm  ,"1 '<text font-family="',"1 FONT,"1'" font-weight="normal" fill="black" stroke="none" font-size="0.8em" pointer-events="none" text-anchor="start" xml:space="preserve" x="',"1(cnv (s * 12) + xc+6),"1'" y="',"1(cnv yc+20),"1'">',"1 vals ,"1 '</text>'
if. s do. (21.5+ >./  xw +&, xc);(32 + (18 * ({: ; uni2) e. 10;13)+{: ,yc); tm
    else. tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'unicode',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
         ('<g><rect rx="6" fill="#96C" width="',(": 10.5 + >./  xw +&, xc),'" height="',(": 32 + (18* (-.b) * ({: ; uni21) e. 10;13)+{: ,yc),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(10.5 + >./  xw +&, xc);'" height="';(32 + (18* (-.b) * ({: ; uni21) e. 10;13)+{: ,yc);'">',tt,'</rect>',anim,'</g>',tm end.
)

vnisvg=: 4 : 0 NB. unicode4 case
's b'=. ({.,{:) x
if. b do. yc=. ,. (msk=.a:~: ,uni4) # rsfiy  uni4=.  boxuni y 
          xc=. ,. msk # , 0&,@}:@ (+/\)"1 xw=.(> # each uni4) * ,/"1 >(((9.59 * 0.5+1.5*FM)"_)`(9.59 *1:)`((9.59 *0.5+1.5*FM)"_)`(wuf@(7&u:)@,)@.( 15 26 31 I. {.))each uni4  
          uni41=. ,-.&a: each <"1 -.&a: uni4 [ xwv=. ": ,. xw=. msk # ; xw
    else. yc=. ,.( ([ S:0 (# each each uni4) ) # (18 * _1 |.!.0 +/\)) @:;@: (;@:(}: , >:@:;each@:{:) each) @: (+/@:((10;13)e.{:) each each) uni4=. unb lc boxuni y
          xc=. ,.  ; 0&,@}:@(+/\)@,"1 each xw=. ( ; each # each each uni41) * each ((9.59 * 0.5+1.5*FM"_)`(9.59 * 12"_)`(9.59 * 0.5+1.5*FM"_)`1:`(9.59 * 0.5+1.5*FM"_)`(wuf@(7&u:)@>)@.(8 9 15 26 31 I. {.@:>))"0  each uni41=.-.&a: ; uni4
          xwv=. ": ,. xw=.; xw  end.  
tt=.'<title>',"1(20#'='),"1 (26({.!.B)"1 (' Unicode4',B,':',B),"1 (;@:(>@:(": each)each) uni41)),"1' ',"1 (20#'='),"1'</title>'
tm=. '<g><rect fill="#96C"',"1 ' x="',"1(": (s * 12)+ xc+5),"1'" y="',"1(;"1": each <"0 [yc+6),"1'" width="',"1 (": xwv),"1'" height="18" rx="2" fill-opacity="1"></rect><rect ',"1(s{::'fill="gold" stroke="yellow"';'fill="white" stroke="red"'),"1' x="',"1(": (s * 12)+ xc+5),"1'" y="',"1(;"1": each <"0 [yc+6),"1'" width="',"1 (": xwv),"1'" height="18" rx="2">',"1 tt ,"1'</rect>',"1 anim,"1'</g>'
vals=.": ;@:,.@:(;"1@:,.@:((' '"_)`((9&u:)@:(9&u:))`(valclean@:{&a.)`((9&u:)@:(9&u:))@.(0 15 26 I.{.) each) each) uni41 NB. vals raw values cleaned to show box characters
tm=. ,tm  ,"1 '<text font-family="',"1 FONT,"1'" font-weight="normal" fill="black" stroke="none" font-size="0.8em" pointer-events="none" text-anchor="start" xml:space="preserve" x="',"1(cnv (s * 12) + xc+6),"1'" y="',"1(cnv yc+19),"1'">',"1 vals ,"1 '</text>'
if. s do. (21.5+ >./  xw +&, xc);(32 + (18 * ({: ; uni4) e. 10;13)+{: ,yc); tm
    else. tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'unicode4',B),(40{.' Shape',B,':',B,'',(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
         ('<g><rect rx="6" fill="#96C" width="',(": 10.5 + >./  xw +&, xc),'" height="',(": 32 + (18* (-.b) * ({: ; uni41) e. 10;13)+{: ,yc),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(10.5 + >./  xw +&, xc);'" height="';(32 + (18* (-.b) * ({: ; uni41) e. 10;13)+{: ,yc);'">',tt,'</rect>',anim,'</g>',tm end.
)

symsvg=: 4 : 0 NB. Symbols case: calls on litsvg, unisvg and vnisvg as needed to evaluate the labels. s flag ensures correct return of label format
's b'=. ({.,{:) x
ysvg=.  (1;0)&vg each 5 s: y 
bW=.8 + >./ bw +&, bx=. }:@(0 , +/\)"1 bw=.>./  >, <"1 [ 0 {::"1  >ysvg 
bh=. (1&>.@:{:@:$ y) # >./^:(2&<:@:#@:$)^:_  >./"1 [ 1 {::"1 > ysvg NB. >./^:(1&<:@:#@:$) swapped with , if the exception of 2 dimensions is covered
bH=.16 + bh +&{: by=. (1&>.@:{:@:$y)&# , (mask y) ({."1@:([ # +/\ @:(0&,)@:}:@:(#!.20^:_1)))  >, <"1($y)&$ bh
'bx bw bh by'=. ,.@,@(($y) $ ,) each bx ; bw ; bh ; by NB. may be smoothed a bit just normalizing the number of items of bw may be useful to look at the ysvg=. > , <"1 ysvg trick
slt=.,. , datatype each 5 s:  y
tt=. '<title>',"1(30#'='),"1(65({.!.B)"1(' Label',B,'Type',B,':',B),"1(;"1 slt),"1' '),"1(50({.!.B)"1(' Index',B,':',B),"1(;"1(":each ,. , 6 s: y))),"1(40{."1(' Total',B,'Symbols',B,'Assigned:',B),"1(": 0 s: 0)),"1(30#'='),"1'</title>'
tm=. '<svg x="';"1 bx ;"1'" y="';"1 by ;"1'"><g><rect fill="#96C" width="',"1 (": ,. , bw ),"1'" height="',"1 (": ,. , bh),"1'" rx="3" fill-opacity="1"></rect><rect stroke="#900" stroke-width="1" ',"1((('unicode';'unicode4')i.slt){::'fill="#b22"';'fill="#600"';'fill="#f55"'),"1' width="',"1 (": ,. , bw ),"1'" height="',"1 (": ,. , bh),"1'" rx="3">',"1 tt ,"1'</rect>',"1 anim,"1'</g><text  fill="white"  font-weight="normal" stroke="white" stroke-width="1" font-size="1.5em" x="2" y="18" pointer-events="none">`</text>',"1'"><svg>',"1  (>ysvg=. ,. {. > , <"1 > , &.:> {: each ysvg),"1 '</svg></svg>' NB. red background of symbol last text element is ` stroke
tt=. '<title>',(30#'='),(60({.!.B)' Type :',B,'symbol',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
tm=. ": each '<svg  x="4" y="8">';"1  tm ,"1<'</svg>'
('<g><rect rx="6" fill="#96C" width="',(": bW),'" height="',(": bH),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(bW);'" height="';bH;'">',tt,'</rect>',anim,'</g>',;tm
)

bxsvg=: 4 : 0 NB. boxed cases - sends contents through the process and boxes those results
's b'=. ({.,{:) x   
bW=.16 + bw +&{: bx=. }: 0 , +/\  <: bw=.>./  > , <"1 [ 3 {::"1  ysvg=.  vg&> y 
bh=. (1&>.@:{:@:$ y) # >./^:(2&<:@:#@:$)^:_  >./"1 [ 5 {::"1 ysvg NB. >./^:(1&<:@:#@:$) swapped with , if the exception of 2 dimensions is covered
bH=.32 + bh +&{: by=. (1&>.@:{:@:$y)&# , (mask y) ({."1@:([ # +/\ @:(0&,)@:}:@:(#!.20^:_1)))  >, <"1($y)$ <: bh  
'bx bw bh by'=. ,.@,@(($y)&$) each bx ; bw ; bh ; by NB. may be smoothed a bit just normalizing the number of items of bw may be useful to look at the ysvg=. > , <"1 ysvg trick
tm=. (<"1 '<g><rect rx="0" fill="#96C" width="',"1 (": ,. bw) ,"1'" height="',"1 (":,. bh) ,"1'" fill-opacity="1"></rect><rect overflow="visible" '),. (<' stroke="black" fill='),.(_6&{. each (1&{"1) ysvg),.(<' stroke-width="2') ,.(2{"1 ysvg),. (<"0 bw) ,.(4{"1 ysvg),. (<"0 bh) ,. ,. {:"1 ysvg=. > , <"1 ysvg
tt=. '<title>',(30#'='),(70({.!.B)' Type',B,':',B,'boxed',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
tm=. ": each '<svg  x="';"1((4*b)+ 4+ bx);"1'" y="';"1(17+by);"1'" width="';"1 bw;"1'" height="';"1 bh;"1'">';"1  tm ,"1<'</svg>'
('<g><rect rx="6" fill="#96C" width="',(": bW- 8 * -. b),'" height="',(": bH),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(bW- 8 * -. b);'" height="';bH;'">',tt,'</rect>',anim,'</g>',;tm
)

boosvg=: 3 : 0 NB. numeric case - boolean  
tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'boolean',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
tm=. ,('<text font-family="courier" fill="white" stroke="black" font-weight="bold" pointer-events="none" xml:space="preserve" text-anchor="start" x="3.5" y="'),"1 (cnv ,. 20+ 18*(# i.@#)@mask y),"1('">'),"1 (> , <"1  ": y) ,"1 '</text>'
('<g><rect rx="6" fill="#96C" width="',(": 7 + 9.6 * {:$":y),'" height="',(": 14 + 18 * # mask  y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7 + 9.6 * {:$":y);'" height="';(14 + 18 * # mask  y);'">',tt,'</rect>',anim,'</g>',tm
)

intsvg=: 3 : 0 NB. numeric case - integer  
tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'integer',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
tm=. ,('<text font-family="courier" fill="black" stroke="none" font-weight="normal" pointer-events="none" xml:space="preserve" text-anchor="start" x="3.5" y="'),"1 (cnv ,. 20+ 18*(# i.@#)@mask y),"1('">'),"1 (> , <"1  ": y) ,"1 '</text>'
('<g><rect rx="6" fill="#96C" width="',(": 7 + 9.6 * {:$":y),'" height="',(": 14 + 18 * # mask  y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7 + 9.6 * {:$":y);'" height="';(14 + 18 * # mask  y);'">',tt,'</rect>',anim,'</g>',tm
)

extsvg=: 3 : 0 NB. numeric case - extended  
tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'extended',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
tm=. ,('<text font-family="courier" fill="#888" stroke="black" stroke-width="0.4" font-weight="bold" pointer-events="none" xml:space="preserve" text-anchor="start" x="3.5" y="'),"1 (cnv ,. 20+ 18*(# i.@#)@mask y),"1('">'),"1 (> , <"1  ": y) ,"1 '</text>'
('<g><rect rx="6" fill="#96C" width="',(": 7 + 9.6 * {:$":y),'" height="',(": 14 + 18 * # mask  y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7 + 9.6 * {:$":y);'" height="';(14 + 18 * # mask  y);'">',tt,'</rect>',anim,'</g>',tm
)

flosvg=: 3 : 0 NB. numeric case - floating  
tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'floating',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
vals=. (> , <"1  ": y) rplc"1 'e';'<tspan fill="white" stroke-width="0.75">e</tspan>'
tm=. ,('<text font-family="courier" fill="#44F" stroke="black" stroke-width="0.5" font-weight="bold" pointer-events="none" xml:space="preserve" text-anchor="start" x="3.5" y="'),"1 (cnv ,. 20+ 18*(# i.@#)@mask y),"1('">'),"1 vals ,"1 '</text>'
('<g><rect rx="6" fill="#96C" width="',(": 7 + 9.6 * {:$":y),'" height="',(": 14 + 18 * # mask  y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7 + 9.6 * {:$":y);'" height="';(14 + 18 * # mask  y);'">',tt,'</rect>',anim,'</g>',tm
)

ratsvg=: 3 : 0 NB. numeric case - rational  
tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'rational',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
vals=. (> , <"1  ": y) rplc"1 'r';'<tspan fill="#F57" stroke-width="1">r</tspan>'
tm=. ,('<text font-family="courier" fill="black" stroke="black" stroke-width="0.2" font-weight="bold" pointer-events="none" xml:space="preserve" text-anchor="start" x="3.5" y="'),"1 (cnv ,. 20+ 18*(# i.@#)@mask y),"1('">'),"1 vals ,"1 '</text>'
('<g><rect rx="6" fill="#96C" width="',(": 7 + 9.6 * {:$":y),'" height="',(": 14 + 18 * # mask  y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7 + 9.6 * {:$":y);'" height="';(14 + 18 * # mask  y);'">',tt,'</rect>',anim,'</g>',tm
)

comsvg=: 3 : 0 NB. numeric case - complex  
tt=. '<title>',(30#'='),(60({.!.B)' Type',B,':',B,'complex',B),(40{.' Shape',B,':',B,(''-:  $ y){::((":  $ y);'atom')),(30#'='),'</title>'
vals=. (> , <"1  ": y) rplc"1 'j';'<tspan fill="white" stroke-width="0.75">j</tspan>'
tm=. ,('<text font-family="courier" fill="#040" font-style="italic" stroke="black" stroke-width="0.2" font-weight="bold" pointer-events="none" xml:space="preserve" text-anchor="start" x="3.5" y="'),"1 (cnv ,. 20+ 18*(# i.@#)@mask y),"1('">'),"1 vals ,"1 '</text>'
('<g><rect rx="6" fill="#96C" width="',(": 7 + 9.6 * {:$":y),'" height="',(": 14 + 18 * # mask  y),'" fill-opacity="1"></rect><rect overflow="visible" ');('rx="6" ',(1-: {. $ y){::('stroke="white" fill="#fff"');('fill="#dde" stroke="#aac"'));'" width="';(7 + 9.6 * {:$":y);'" height="';(14 + 18 * # mask  y);'">',tt,'</rect>',anim,'</g>',tm
)

findline =: 3 : 0    NB. WinSelect is a character index; WinText is entire window; if window contains non-ASCII, convert to unicode
  if. y do. ; }. ;:(#~ -.@:(*./\)@:=&' ') ": > {: < ;. _2 (wd'sm get inputlog'), LF NB. pull the last line only for the monadic case Programmatic version strip off first word which would be invoking verb
        else. (#~ -.@:(*./\)@:=&' ') ": ({. WinSelect_jqtide_) ((LF&taketo&.|.)@:{. , LF&taketo @:}.)  7 u: WinText_jqtide_  end.NB. The line that the cursor is on if 0 - Function key version
)

v_z_ =:   3 : '((1;coname 0$0) visual_jig_ 1:) y'
