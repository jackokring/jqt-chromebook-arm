NB. static verb

NB. =========================================================
NB. public verbs
NB.
NB. indexof
NB. reset

NB. =========================================================
NB. indexof
NB.
NB. return the indices of y in x
NB. form: data1 indexof_jsqltable_ data2
NB.
NB. x and y are typically index columns
NB. beware each corresponding columns from the 2 tables should have the same jytpe format
NB.
NB. for example:
NB. ('city' read__a'') indexof_jsqltable_ ('city' read__b'')
indexof=: 4 : 0

if. ((1=#@$) x) *. (1=#@$) y do.       NB. inverted table
  if. (#x)~:#y do. ERR02 return. end.

NB. edge conditions
  if. 0=ttally x do. (ttally y)$0 return. end.
  if. 0=ttally y do. 0$0 return. end.

NB. make text columns compatible width before comparison
  tx=. 2= 3!:0&>x
  ty=. 2= 3!:0&>y
  if. 0= *./ tx=ty do. ERR01 return. end.

  w=. ({:@$&>tx#x)>.({:@$&>ty#y)
  x=. (w ({."1)&.> tx#x) (I.tx)}x
  y=. (w ({."1)&.> ty#y) (I.ty)}y

NB. tindexof
  x (i.&>~@[ i.&|: i.&>) y

elseif. ((2=#@$) x) *. (2=#@$) y do.    NB. boxed table
  if. ({:@$ x)~:{:@$ y do. ERR02 return. end.

NB. edge conditions
  if. 0=#x do. (#y)$0 return. end.
  if. 0=#y do. 0$0 return. end.

NB. make text columns compatible width before comparison
  tx=. 2= 3!:0&>{.x
  ty=. 2= 3!:0&>{.y
  if. 0= *./ tx=ty do. ERR01 return. end.

  x=. (dtb&.> (<a:;tx){x) (<a:;I.tx)}x
  y=. (dtb&.> (<a:;ty){y) (<a:;I.ty)}y

NB. tindexof
  x i. y

elseif. do.
  ERR02 return.
end.

)

NB. =========================================================
NB. reset
NB.
NB. close all connection handles and destroy all jsqltable objects
NB. form: reset_jsqltable_ ''
reset=: 3 : 0
for_l. allobj_jsqltable_ do.
  if. l e. 18!:1[1 do.
    destroy__l ::0: ''
  end.
end.
allobj_jsqltable_=: 0$<''
0
)
