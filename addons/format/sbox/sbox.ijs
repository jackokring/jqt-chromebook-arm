NB. Box display verb, corrected for Unicode
NB. by Ian Clark, Oct 2012.

require 'strings convert'
require 'format/zulu/lite'

coclass 'sbox'

asc=: a. i. ]		NB. code points from ascii chars

coords=: 3 : 0
	NB. (i,j)-coords of placeholders in cmx: y, followed by the id
z=. ,y [ rc=. $y	NB. save shape & flatten y (z)
k=. I. z~:' '		NB. posns k of placeholders in z
j=. 1&phold k{z		NB. corresponding pane-id j
z=. rc #: k		NB. table of coords, col 0 being j
z,.j			NB. return list of (coords,id)
)

cc=: 3 : 0
	NB. TEST ONLY: view P-entry
y=. {.y	NB. scalar only: id or placeholder letter
if. y e. a. do. y=. 1&phold y end.	NB. placeholder-->id#
p=. >y{P	NB. contents of y{P
smoutput nb  '#P:' ; (#P) ; '$p:' ; ($p) ; '  p=.(>' ; y ; '{P) -- u: p ...'
smoutput u: p
p [ smoutput '(returns p...)'
)

cp=: 3 u: 7 u: ]   NB. code-point (decimal) of glyph: y

cpfix=: 4 : 0
	NB. replace {.y with {:y in (int mx)x
mask=. x= {.y=. 2{.y
x - mask* -/y
)

cpbox=: 3 : 0
	NB. code points of (nested) boxed noun: y containing unicodes
	NB. stores panes in P, their coords in K
	NB. and builds a mx C of code points
if. unboxed y do.	NB. outermost box assumed always present
  u: cpimage y return.	NB. return consistent format of image
end.
P=: 0$0			NB. list of saved panes
BDC0=: 9!:6''		NB. save original box-drawing chars
setbox ' '		NB. neutral fill
L=: _1			NB. leaf count (init)
S=: ": subDummy leaf y	NB. setup map S to build list: K
K=: coords S		NB. coords (col:0 1) and id (col:2) of arbit pane
setbox BDC0		NB. restore original box-border
L=: _1			NB. leaf count (init)
T=: ": subBlank leaf y	NB. setup map T to build end-framework
C=. 3&u: T		NB. start building code point array C
for_k. i.#K do.		NB. overlay saved panels on C
  C=. C overlaid k	NB. k is NOT necessarily the id#	
end.
erase 'K L P S T'	NB. destroy work variables
u: C
)

cpimage=: 3 : 0
	NB. (int)mx code point display image of noun: y
select. zutype y	NB. y--> utf-8 encoded LF-sep string
case. 'o' do.	z=. y
case. 'b' do.	z=. b2f y
case. 'x' do.	z=. x2f y
case. 'f' do.	z=. y
case. 'm' do.	z=. ''
case. 'n' do.	z=. ''
case. '-' do.	z=. x2f image y
end.
z=. 3 u: f2x uucp z
z cpfix 13 32	NB. convert CR-->SP
)
0 : 0	NB. TEST...
	cpimage y=: 'alpha',CR,'bravo',CR,'charlie'
	cpimage y=: 'alpha',LF,'bravo',LF,'charlie'
	cpimage y=: 'alpha',CRLF,'bravo',CRLF,'charlie'
)

dsp=: ([: - 2 {. ]) |. [ {.~ 2 }. ]  NB. displace (imx)x by 2{.y

image=: 3 : 0
	NB. 2D displayable image of noun: y inside a boxed display
	NB. This is used by cpimage when all else fails
	NB. Technique: ":@:< --and then peel away the box.
saved=. 9!:6''	NB. save existing box-drawing chars
setbox ' '	NB. to make stray box-sides invisible
if. LF e. y do. z=. f2x y else. z=. y end.
z=. uucp"1 ":@:< z
setbox saved	NB. restore box-drawing chars on entry
z=. _1 _1 }. 1 1 }. z	NB. peel away the outer box
)

ip=: ] i. [: i. #	NB. invert the permutation: y

overlaid=: 4 : 0
	NB. (int)mx x overlaid with pane id; (int)y
	NB. USES GLOBALS: K P
id=. {: y{K	NB. id is last K col
ij=. }: y{K	NB. (i,j)-coords in: x
NB. 	NB. WILL THE FOLLOWING EVER HAPPEN NOW?? ...
NB. if. 0 e. ij do.	NB. (0 0) never valid
NB.   smoutput '>>>overlaid id' ; id ; 'ij' ; ij ; '>>>noop'
NB.   x return.
NB. end.
hw=. $p=. >id{P	NB. panel height,width
mask=. -. (hw$1) dsp ij,$x
NB. smoutput '>>>overlaid id' ; id ; 'phold' ; (phold id) ; 'ij' ; ij 
(mask*x) + p dsp ij,$x
)

phold=: 3 : 0
0 phold y
:
	NB. x=0: placeholder letter <-- pane id: (int)y
	NB. x=1: letter y --> pane id
z=. asc '0'		NB. starting letter for y=0
if. x do.
  z-~ asc y		NB. id<--letter y
else.
  a.{~ z+y		NB. letter<--id y
end.
)

setbox=: [: (9!:7) 11 $ ,	NB. set box-drawing chars to: y

subBlank=: 3 : 0
	NB. Substitute blank pane (id: L) in noun: y
	NB. called with (adverb)leaf
	NB. USES GLOBALS: L
L=: 1 + L		NB. ID of current leaf
rc=. $ p=. cpimage y	NB. size (r,c) of original pane p
rc$ ":L			NB. replace the leaf with ID-NUMBERED pane
)

subDummy=: 3 : 0
	NB. Substitute dummy pane (id: L) in noun: y
	NB. called with (adverb)leaf
	NB. Saves pane p in list P
	NB. USES GLOBALS: L P
L=: 1 + L		NB. ID of current leaf
rc=. $ p=. cpimage y	NB. size (r,c) of original pane p
P=: P,<p		NB. append pane p to list P
	assert L = <:#P
z=. (*/rc) {. phold L	NB. replacement pane contents string z
rc$ z			NB. replace the leaf with dummy pane
)

sbox=: u:@:cpbox

sbox_z_=: sbox_sbox_

testbox=: 3 : 0
	NB. test-output y boxed (solid)
	NB. TEST ONLY: For in-line diagnostics
	NB. ALWAYS uses the linedraw chars
y testbox~ 16{a.
:
saved=. 9!:6''	NB. save original box-drawing chars
t=. {. ":x	NB. topleft corner is 1st char of x
setbox t,}.a.{~ 16+i.11
smoutput <y
setbox saved
)

unboxed=: L. = 0:	NB. Boolean: y is not boxed
