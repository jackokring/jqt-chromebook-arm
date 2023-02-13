coclass 'psmgraph'

require '~addons/graphics/graphviz/graphview.ijs'

NB.*smgraph v graphdef=. (p;q) smgraph s[;r]
NB. p list of state labels, q list of input labels, s state table, r init state
smgraph=: 3 : 0
's r'=. 2{.y ,&boxopen 0
(;&i."0/]2{.$s) smgraph y
:
'p q'=. x
's r'=. 2{.y ,&boxopen 0
'pn qn'=. 2{.$s
z=. SMG1
z=. z,'  start->"',(":>r{p),'" [arrowhead=vee];',LF,LF
for_i. i.pn do.
  pl=. ":>i{p
  cat=. =i{s
  nub=. ~.i{s
  for_j. i.#cat do.
    ql=. ":>concat/(j{cat)#q
    'ns o'=. j{nub
    nl=. ":>ns{p
    ol=. >o{ARR
    z=. z,'  "',pl,'"->"',nl,'" [label="',ql,'",arrowhead=',ol,'];',LF
  end.
  z=. z,LF
end.
z,SMG2
)

concat=: ([ , ','"_ , ])&(":@:>)

ARR=: ;:'vee inv normal onormal diamond odiamond dot'

SMG1=: 0 : 0
digraph G {
  rankdir=LR;
  node  [shape=ellipse];

  start [shape=point, label=""];
)

SMG2=: 0 : 0
  label="Sequential machine";
}
)

smgraph_z_=: smgraph_psmgraph_
smview_z_=: graphview@smgraph
