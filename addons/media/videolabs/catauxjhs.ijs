NB. Learning objects for Catalan video lab in jhs
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

cmb=:#:@:i.@:(2&^)@:+:@:<: NB. creates the truth table for all combinations
r1=:((-:@:# = +/)"_1 # ]) NB. removes those combinations where number of 1's ~: number of 0's - Rule 1
r2=: ((_1&<:@: (<./)@:(+/\)@:(+ (_1 * -.))"_1) # ]) NB. removes those combinations where number of 0's > number of preceding 1's- Rule 2
cat=: a:&$: : (<@: ({ ($~)`(1 0"_)`((1 , 0 ,~ ])"1 @: r2 @: r1 @: cmb)@.(2&<.))"0) NB. Handles 0 and 1 cases and trims others with the beginning 1 column and ending 0 column

parenthesis=: 3 : 0
(i. catalan y) parenthesis y 
:
if. y=0 do. jhtml_jhs_ '<svg height="12" width="12"><rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /></svg>' return. end. 
if. y=1 do. jhtml_jhs_ '<span style="font-weight:bold;letter-spacing:5px;font-size:30px;color:slategrey">(</span><span style="font-weight:bold;letter-spacing: 5px;font-size:30px;color:black">)</span>' return. end.
(x (<. <:@:catalan) y)([: jhtml_jhs_"1 (')(' {~ >@cat) rplc"1 ('(';'<span style="font-weight:bold;letter-spacing:5px;font-size:30px;color:slategrey">(</span>';')';'<span style="font-weight:bold;letter-spacing: 5px;font-size:30px;color:black">)</span>')"_)y
)
ballot=:  3 : 0
(i. catalan y) ballot y 
: 
if. y=0 do. jhtml_jhs_ '<svg height="12" width="12"><rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /></svg>' return. end. 
if. y=1 do. jhtml_jhs_ '<span style="letter-spacing:5px;font-size:30px;color:red">R</span><span style="letter-spacing: 5px;font-size:30px;color:blue">B</span>' return. end.
(x (<. <:@:catalan) y) ([: jhtml_jhs_"1 ('BR' {~ >@cat) rplc"1 ('R';'<span style="letter-spacing:5px;font-size:30px;color:red">R</span>';'B';'<span style="letter-spacing: 5px;font-size:30px;color:blue">B</span>')"_)y
)

binary=: 3 : 0
(i. catalan y) binary y 
:
if. y=0 do. jhtml_jhs_ '<svg height="12" width="12"><rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /></svg>' return. end. 
if. y=1 do. jhtml_jhs_ '<span style="font-weight:bold;letter-spacing:5px;font-size:30px;color:black">1</span><span style="font-weight:bold;letter-spacing: 5px;font-size:30px;color:red">0</span>' return. end.
(x (<. <:@:catalan) y)([: jhtml_jhs_"1 ('01' {~ >@cat) rplc"1 ('1';'<span style="font-weight:bold;letter-spacing:5px;font-size:30px;color:black">1</span>';'0';'<span style="font-weight:bold;letter-spacing: 5px;font-size:30px;color:red">0</span>')"_)y
)

ct=:(+ (_1 * -.)) @>@cat
exf=:i.@(#"1)@ct
wyf=: ( (+/\"1 )@ct - >@cat)

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
if. y=0 do. jhtml_jhs_ '<svg height="12" width="12"><rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /></svg>' return. end. 
if. y=1 do. jhtml_jhs_ '<span style="font-weight:bold;letter-spacing:5px;font-size:30px;color:red"><span style="color:black">(</span>a<span style="color:darkred;">*</span>b<span style="color:black">)</span></span>' return. end.
if. 9<y do. jhtml_jhs_ '<text x="15" y="50" class="pl" >9 is the maximum value for this display.</text>' return. end.
t=.({"_1 (')',.'abcdefghij'&({~ <:@:(+/\))))"1@:(1,.>@:cat) y
t=. mult"1 <"0 x{t
jhtml_jhs_"1 t 
)

mult=: 3 : 0
p=.y
while. 1<# p do.
 for_t. p do. if. t=<')' do. p=. t_index (((-&2)@:[ {. ]) , <@:(')',~'(',;@:(_2&+@[}.{.))   , (>:@:[ }. ])) p break.end. end.
end.
p=.(;p) rplc '(a';'(a*';'(b';'(b*';'(c';'(c*';'(d';'(d*';'(e';'(e*';'(f';'(f*';'(g';'(g*';'(h';'(h*';'(i';'(i*';'(j';'(j*';')c';')*c';')d';')*d';')e';')*e';')f';')*f';')g';')*g';')h';')*h';')i';')*i';')j';')*j'
p=. p rplc ')(';')*('
p=.p rplc '*';'<span style="color:darkred">*</span>';'(';'<span style="color:black">(</span>';')';'<span style="color:black">)</span>'
'<span style="font-weight:bold;letter-spacing:5px;font-size:30px;color:red">',p,'</span>'
)

path=: 3 : 0
(i. catalan y) path y
:
if. y=0 do. jhtml_jhs_ '<svg height="12" width="12"><rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /></svg>' return. end. 
if. y=1 do. t=. '<svg height="14" width="14"><rect x="2" y="2" width="10" height="10" stroke="grey" fill="none" />'
            t=. t,'<line x1="2" y1="12" x2="12" y2="2" stroke="red" />'
            jhtml_jhs_ t,'<path stroke="forestgreen" stroke-width="3" fill="none" d="M 1,13 v -11 h 11" /></svg>' return. end.
w=.('<svg height="',":@: ( (12 * >:)* >.@:((#x)<.8 %~ catalan)),'" width="',":@:(125 * <.&8),'">'"_)y NB. outside svg wrapper 8 grids per row
pos=.(i. # x (<. <:@:catalan) y){ >@:({. ,@:{@:(1.2&*@:i.@:>.@:%&8 ; 1.2&*@:i.@:<.&8))@:catalan  y NB. upper left positions of grids
jhtml_jhs_"1 (w , ,&'</svg>') , pos paths >(x (<. <:@:catalan) y) cat y
)
paths=: 4 : 0"1 NB. to build grids and place paths and diagonal on them
'h w'=.x
n=. -: # y
t=.'<line x1="',(": xpos + (wid =. _10 + 10 * >: n ) ),'" y1="',(": ypos),'" x2="',(": xpos=.10 + 10 * w * n),'" y2="',(": 2 + (ht=. _10 + 10 * >: n) + (ypos=. 10 * h * >: n )),'" stroke="red" stroke-width="1.5" />'
t=. t, '<rect x="',(": xpos),'" y="',(":ypos),'" width="',(":wid),'" height="',(":ht),'" stroke="grey" fill="none" />'
t=. t,'<line x1="',(":xpos),'" y1="',(":ypos + -:ht),'" x2="',(":xpos +  wid),'" y2="',(":ypos + -:ht),'" stroke-width="',(": wid),'" stroke-dasharray="1 9" stroke="gray"/>'
t=. t,'<line x1="',(":xpos + -: wid),'" y1="',(": ypos),'" x2="',(":xpos + -: wid),'" y2="',(":ht + ypos),'" stroke-width="',(":  wid),'" stroke-dasharray="1 9" stroke="gray"/>'
t,'<path stroke="forestgreen" stroke-width="4" fill="none" d="M ',(": xpos),',',((":2 +ht+ypos)),((' h 10';' v -10');@:{~y),'" />'
)


polygon=: 3 : 0
(i. catalan 8 <.y) polygon y
:
t=. 8 <. y
if. y=0 do. jhtml_jhs_ '<svg height="12" width="12"><rect x="1" y="1" width="10" height="10" stroke="grey" fill="grey" /></svg>' return. end. 
if. y=1 do. t=. '<svg height="48" width="50"><line x1="39.142" y1="39.142" x2="5.681" y2="30.176" stroke="red" />'
            t=. t,'<line x1="30.176" y1="5.681" x2="5.681" y2="30.176" stroke="red" />'
            jhtml_jhs_ t,'<line x1="39.142" y1="39.142" x2="30.176" y2="5.681" stroke="red" /></svg>' return. end.
pos=.(i. # x (<. <:@:catalan) t){ >@:({. ,@:{@:(1.2&*@:i.@:>.@:%&10 ; 1.2&*@:i.@:<.&10))@:catalan  t NB. upper left positions of grids
vertices=.(25 +|. pos* 40) (+"1"1 _) 20+.@:r.((o.%4)+ 2&% * o.@:i.)t+2
ed=. ,/ poly (1,. > cat t) # inv"_1  (;"1) 2[\"1 <"1 vertices
w=.('<svg height="',":@: ( 48 * >.@:((#x)<.10 %~ catalan)),'" width="',":@:(125 * <.&10),'">'"_)t NB. outside svg wrapper 8 grids per row
jhtml_jhs_ (w , ,&'</svg>') ,  ; ": each (<'<line x1="'),.(<"0 [ 1{"1 ed),. (<'" y1="'),.(<"0 {."1 ed),.(<'" x2="'),. (<"0 {:"1 ed),.(<'" y2="'),. ( _2{"1 ed);"0(<'" stroke-width="1" stroke="red" />')
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
pexp=: [: +/ ] <.@% [ ^ >: @ i. @ (<.@^.)
ple=: p: @ i. @ (p: inverse) @ >:

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
