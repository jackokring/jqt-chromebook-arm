NB. Learning objects for Catalan video lab in jqt
cocurrent 'cat'
NB. second definition in Cat locale sets up a cover locale so variable do not pollute the calling namespace

tester=: 4 : 0  NB. Basis of catalan tester for string y of length 2 x
if. 2~:3!:0 y do.(LF,(":y),' is not a character string.',LF,'Try entering: test',(":x),' ''',(":y),'''',LF)return. end.
y=.y-.' ' NB. remove blanks in string 
if. -.*./ y e.'10' do.(LF,'''',y,''' should only contain ''0''s and ''1''s. No spaces.',LF)return. end. 
if. (+:x)>#y do. (LF,'''',y,''' needs ',(": t),' more character',((1<t=.(+:x)-#y){' s'),LF) return. end.
if. (+:x)<#y do. (LF,'''',y,''' needs ',(": t),' less character',((1<t=.(#y)-+:x){' s'),LF) return. end.
if. | t=.* +/r=.(+ _1* -. ) ". 1j1 # y do.(LF,'''',y,''' needs more ''',(":(0>t){ 0 1),'''s in string',LF) return. end. 
if. 0><./t=.+/\ r do.(LF,'''',y,''' breaks rule by having more ''0''s than ''1''s at position: ',(": t i. _1),LF)return. end. 
LF,'''',y, ''' is valid',LF
)
test3=: 3 & tester  NB. test string of length 6 for Catalan validity

test4=: 4 & tester  NB. test string of length 8 for Catalan validity
CSS=: 0 : 0  NB. CSS for the different Catalan views.
<style type="text/css">
 svg {overflow:visible;}
 text { font-family:"courier"; font-weight:bold; stroke-width:0.75; stroke:black; pointer-events: none; text-anchor:start; white-space:pre;}
 .pr  { fill:#888; stroke-width:0.4; font-weight:bold; font-size: 30px;}
 .pl , .b1  { fill:#000; stroke-width:0.4; font-weight:bold; font-size: 30px;} 
 .br , .b0 { fill:#F00; stroke-width:0.4; font-weight:bold; font-size: 30px;} 
 .bb  { fill:#00F; stroke-width:0.4; font-weight:bold; font-size: 30px;} 
 .mr  { fill:#F00; stroke-width:0.4; font-weight:bold; font-size: 30px;}
 .mb  { stroke:blue; stroke-width:8; font-weight:bold; font-size: 30px;}  
 .wr  { fill:#FFF; stroke-width:0; font-weight:bold; font-size: 30px;}
 .polr  { stroke:#900; stroke-width:1.5;}
 .pg  { stroke:#AAA; stroke-width:13; fill:none;}
 .m   { stroke:#00F; stroke-width:4; fill:none;}  
</style>
)
htmpack=: 3 :'''<hmtl><head><meta charset="UTF-8">'', (CSS rplc ''<FONT>'';''courier''),''</head><body>'', y ,''</body></html>'''
DISPLAY=: 0 : 0 NB. Form that contains the display of the different catalan views
pc enhanced;
cc w1 webview;
)
webdisplay=: 4 : 0 NB. Displays the results of different Catalan views in webview 
wd DISPLAY
wd 'pn *', > {. x
wd 'pmove ',(": -: 2 { ". wd 'qscreen'),' 100 _1 _1'
wd 'set w1 wh *', ": 200 120>. (_225 _200 + 2 3 { ". wd 'qscreen') <. 1.1 * > {: x
wd 'set w1 html *', ,y
wd 'pshow'
)

enhanced_close=: 3 : 0
NB.handle=. ": wd 'qhwndp;' 
NB.wd 'psel ',handle,';'
wd 'pclose;'
)

jhtml=: 4 : 0
'w h'=: > {: x
x webdisplay htmpack '<svg width="',(": w),'" height="',(": h),'" >',y,'</svg>'
)

cmb=:#:@:i.@:(2&^)@:+:@:<: NB. creates the truth table for all combinations
r1=:((-:@:# = +/)"_1 # ]) NB. removes those combinations where number of 1's ~: number of 0's - Rule 1
r2=: ((_1&<:@: (<./)@:(+/\)@:(+ (_1 * -.))"_1) # ]) NB. removes those combinations where number of 0's > number of preceding 1's- Rule 2
cat=: a:&$: : (<@: ({ ($~)`(1 0"_)`((1 , 0 ,~ ])"1 @: r2 @: r1 @: cmb)@.(2&<.))"0) NB. Handles 0 and 1 cases and trims others with the beginning 1 column and ending 0 column

parenthesis=: 3 : 0
(i. catalan y) parenthesis y
:
if. y=0 do. (('Parenthesis - ' , ": y); 100 100) jhtml '<rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /><text x="15" y="30" class="pl" > Empty </text>' return. end. 
if. y=1 do. (('Parenthesis - ' , ": y); 100 100) jhtml '<text x="20" y="40"><tspan class="pl">(</tspan><tspan class="pr">)</tspan></text>' return. end.
if. 8<y do. (('Parenthesis - ' , ": y); 680 100) jhtml '<text x="15" y="50" class="pl" >8 is the maximum value for this display.</text>' return. end.  NB. artificial limit for display
tm=.'<text  x="10" y="20" style=";font-size:20px"> ', ,&'</text>' ;(<'<tspan x="10" dy="35"> '),"1 ,.&(<'</tspan>') x (('<tspan class="pr">)</tspan>';'<tspan class="pl">(</tspan>') {~ >@:cat)y
(('Parenthesis - ' , ": y); (35 * # > 1 cat y) , (35 * >: #x)) jhtml tm
)
ballot=:  3 : 0
(i. catalan y) ballot y
: 
if. y=0 do. (('Ballot - ' , ": y); 100 100) jhtml '<rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /><text x="15" y="30" class="pl" > Empty </text>' return. end. 
if. y=1 do. (('Ballot - ' , ": y); 100 100) jhtml '<text x="20" y="40"><tspan class="br">R</tspan><tspan class="bb">B</tspan></text>' return. end.
if. 8<y do. (('Ballot - ' , ": y); 680 100) jhtml '<text x="15" y="50" class="pl" >8 is the maximum value for this display.</text>' return. end.  NB. artificial limit for display
tm=.'<text  x="10" y="20" style=";font-size:20px"> ', ,&'</text>' ;(<'<tspan x="10" dy="35"> '),"1 ,.&(<'</tspan>') x (('<tspan class="br">R</tspan>';'<tspan class="bb">B</tspan>') {~ >@:cat)y
(('Ballot - ' , ": y); (35 * # > 1 cat y) , (35 * >: #x)) jhtml tm
)

binary=: 3 : 0
(i. catalan y) binary y 
:
if. y=0 do. ' Empty ' return. end. 
if. y=1 do. '1 0' return. end.
if. 8<y do. (('Binary - ' , ": y); 680 100) jhtml '<text x="15" y="50" class="pl" >8 is the maximum value for this display.</text>' return. end.  NB. artificial limit for display
 x >@:cat y 
)

ct=:(+ (_1 * -.)) @>@cat
exf=:i.@(#"1)@ct
wyf=: ( (+/\"1 )@ct - >@cat)
frmt=:,@:(];;@:(('<tspan class="','">',~[);'</tspan>';~]))

mount=: 3 : 0
(i. catalan y) mount y
:
if. y=0 do. <' . Empty' return. end.
if. y=1 do. <'/\' return. end.
t=.(' ' $~ catalan , ] , +:) y NB.(0,x) (' ' <@$~ (([: >./"1 >:@wyf) ,"0 +:@:] ))y
t=. (x (<. <:@:catalan) y){ <"_1 ('\/'{~ > a: cat y)((a:([:<"1(i.@:catalan@],."0 _1 wyf,"0 exf))y))}"_ t
_6 ]\ |. each t
)

multiply=: 3 : 0
(i. catalan y) multiply y
:
if. y=0 do. '() Empty' return. end. 
if. y=1 do. '(a*b)' return. end.
if. 9<y do. '9 is the maximum value for this display.' return. end. NB. artificial limit of variables for display
t=.({"_1 (')',.'abcdefghij'&({~ <:@:(+/\))))"1@:(1,.>@:cat) y
mult"1 <"0 x{t
)

mult=: 3 : 0
p=.y
while. 1<# p do.
 for_t. p do. if. t=<')' do. p=. t_index (((-&2)@:[ {. ]) , <@:(')',~'(',;@:(_2&+@[}.{.)) , (>:@:[ }. ])) p break.end. end.
end.
p=.(;p) rplc '(a';'(a*';'(b';'(b*';'(c';'(c*';'(d';'(d*';'(e';'(e*';'(f';'(f*';'(g';'(g*';'(h';'(h*';'(i';'(i*';'(j';'(j*';')c';')*c';')d';')*d';')e';')*e';')f';')*f';')g';')*g';')h';')*h';')i';')*i';')j';')*j'
p rplc ')(';')*('
)

path=: 3 : 0
(i. catalan y) path y
:
if. y=0 do. (('Path - ' , ": y); 100 100) jhtml '<rect x="2" y="2" width="10" height="10" class="pg" /><text x="15" y="30" class="pl" > Empty </text>' return. end. 
if. y=1 do. t=. '<rect x="2" y="2" width="10" height="10" class="pg" />'
            t=. t,'<line x1="2" y1="12" x2="12" y2="2" stroke="red" />'
            (('Path - ' , ": y); 100 100) jhtml t,'<path stroke="forestgreen" stroke-width="3" fill="none" d="M 1,13 v -11 h 11" />' return. end.
if. 7<y do. (('Path - ' , ": y); 680 100) jhtml '<text x="15" y="50" class="pl" >7 is the maximum value for this display.</text>' return. end. NB. artificial limit of variables for display
pos=.x{ >@:({. ,@:{@:(1&*@:i.@:>.@:%&8 ; 1.2&*@:i.@:<.&8))@:catalan  y NB. upper left positions of grids
(('Path - ' , ": y); ((5 + (8<.catalan) *  11 * ]) ,( >.@:(8 %~ catalan)* 10 * >:)) y) jhtml  , pos paths > (x (<. <:@:catalan) y) cat y
)
paths=: 4 : 0"1 NB. aux to build grids N1 AUX N2 - N1 is x1 y1 - N2 is size of grid in rows=columns
'h w'=.x
n=. -: # y
t=.('<line x1="',":@:(xpos + (wid =. _10 + (10 * >:) ) ),'" y1="',(": ypos),'" x2="',":@:(xpos=. 10 * *&w),'" y2="',":@:((ht=. _10 + (10 * >:))  + (ypos=. 10 + 10 * (h * >:) )),'" stroke="red" stroke-width="1.5" />'"_) n
t=. t,('<rect x="',(":xpos),'" y="',(":ypos),'" width="',(":wid),'" height="',(":ht),'" stroke="grey" fill="none" />'"_) n
t=. t,,('<line x1="',"1 (": xpos) ,"1 '" y1="',"1(": ypos + 10 * ,.@:i.),"1 '" x2="' ,"1 (": wid+xpos),"1 '" y2="',"1 (": ypos + 10 * ,.@:i.),"1'" stroke="gray"/>'"_) n
t=. t,,('<line x1="',"1 (": xpos + 10 * ,.@:i.) ,"1 '" y1="',"1(": ypos ),"1 '" x2="' ,"1 (": xpos + 10 * ,.@:i.),"1 '" y2="',"1 (": ypos + ht ),"1'" stroke="gray"/>'"_) n
t,,('<path stroke="forestgreen" stroke-width="4" fill="none" d="M ',":@:(xpos@:-:@:#),',', ":@:((ht + ypos) & -:@:#),((' h 10';' v -10');@:{~ ]),'" />'"_) y NB. forest green #228B22
)

polygon=: 3 : 0
(i. catalan 8 <.y) polygon y
:
t=. 8 <. y
if. y=0 do. (('Polygon - ' , ": y); 100 100) jhtml '<rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /><text x="15" y="30" class="pl" > Empty </text>' return. end. 
if. y=1 do. t=. '<line class="polr" x1="39.142" y1="39.142" x2="5.681" y2="30.176" />'
            t=. t,'<line class="polr" x1="30.176" y1="5.681" x2="5.681" y2="30.176" />'
            (('Polygon - ' , ": y); 100 100) jhtml t,'<line class="polr" x1="39.142" y1="39.142" x2="30.176" y2="5.681"x />' return. end.
if. 7<y do. (('Path - ' , ": y); 680 100) jhtml '<text x="15" y="50" class="pl" >7 is the maximum value for this display.</text>' return. end. NB. artificial limit of variables for display
pos=.(i. # x (<. <:@:catalan) t){ >@:({. ,@:{@:(1.2&*@:i.@:>.@:%&10 ; 1.2&*@:i.@:<.&10))@:catalan  t NB. upper left positions of grids
vertices=.(25 +|. pos* 40) (+"1"1 _) 20+.@:r.((o.%4)+ 2&% * o.@:i.)t+2
ed=. ,/ poly (1,. > cat t) # inv"_1  (;"1) 2[\"1 <"1 vertices
w=.('<svg height="',":@: ( 48 * >.@:((#x)<.10 %~ catalan)),'" width="',":@:(125 * <.&10),'">'"_)t NB. outside svg wrapper 8 grids per row
(('Polygon - ' , ": y); (47 * (1.2+ {: >./pos) <. 10),( 48 * >. ((#x)<.10 %~ catalan y))) jhtml   ; ": each (<'<line x1="'),.(<"0 [ 1{"1 ed),. (<'" y1="'),.(<"0 {."1 ed),.(<'" x2="'),. (<"0 {:"1 ed),.(<'" y2="'),. ( _2{"1 ed);"0(<'" class="polr" />')
)
poly=: 3 : 0"_1
t=.y
p=.0
while. p<#t do.
if. */ p{t 
 do. p=.p+1 
 else. t=. ((_2{.p&{. ),(_2 }. p&{. ), ((2{. (p-2)&{),(_2{. (p-1)&{ )) , (p+1)&}.) t end.
 end.
 t
)

catalan=: 3 : 0
p=. ple +: y NB. the list of primes less than 2 * n
 e1=. p pexp"0 +: y NB. The exponents of primes of the numerator !2 * n
 e2=. p pexp"0 y NB. The exponents of primes of the denominator ! n
 e3=. p pexp"0 >: y NB. The exponents of primes of the denominator ! >: n
*/  p ^ x: e1-e2+e3 NB. Add and subtract exponents then restore to their true values and multiply for the answer.
)

firstcat=: (1:`1:`#@.(2<.#@$))@>@cat
explode=:  (! +:)@:x:
kitty=: (! +:) % >:
kittyX=:  kitty @ x:
ple=: i. &. (p: inverse)
pexp=:  [: +/ ] <.@% [ ^ >: @ i. @ (<.@^.)
kittyN=:  #@:":@: catalan
NB. Define cover locale so that variables do not leak back into the calling base locale
tester_Cat_=:tester_cat_
test3_Cat_=:test3_cat_
test4_Cat_=:test4_cat_
test3_Cat_=:test3_cat_
CSS_Cat_=:CSS_cat_
htmpack_Cat_=:htmpack_cat_
DISPLAY_Cat_=:DISPLAY_cat_
webdisplay_Cat_=:webdisplay_cat_
enhanced_close_Cat_=:enhanced_close_cat_
jhtml_Cat_=:jhtml_cat_
cmb_Cat_=:cmb_cat_
r1_Cat_=:r1_cat_
r2_Cat_=:r2_cat_
cat_Cat_=:cat_cat_
parenthesis_Cat_=:parenthesis_cat_
ballot_Cat_=:ballot_cat_
binary_Cat_=:binary_cat_
ct_Cat_=:ct_cat_
exf_Cat_=:exf_cat_
wyf_Cat_=:wyf_cat_
frmt_Cat_=:frmt_cat_
mount_Cat_=:mount_cat_
multiply_Cat_=:multiply_cat_
mult_Cat_=:mult_cat_
path_Cat_=:path_cat_
paths_Cat_=:paths_cat_
polygon_Cat_=:polygon_cat_
poly_Cat_=:poly_cat_
catalan_Cat_=:catalan_cat_
firstcat_Cat_=:firstcat_cat_
explode_Cat_=:explode_cat_
kitty_Cat_=:kitty_cat_
kittyX_Cat_=:kittyX_cat_
ple_Cat_=:ple_cat_
pexp_Cat_=:pexp_cat_
kittyN_Cat_=:kittyN_cat_
