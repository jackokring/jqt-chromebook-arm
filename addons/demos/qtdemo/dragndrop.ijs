NB. dragndrop

coclass 'qtdemo'

NB. =========================================================
DragnDrop=: 0 : 0
pc dragndrop closeok escclose;pn "Select Active";
bin v;
cc l0 static;cn "Select items then drag and drop to move and rearrange. Double click will also move an item";
bin g;
grid shape 2 2;
grid colwidth 0 100 1 100;
grid rowheight 1 100;
cc s0 static;cn " Available:";
cc s1 static;cn " Selected:";
cc fm listbox drag drop multiple;
cc to listbox drag drop multiple;
bin zh;
bin s1;
cc ok button;
cn "OK";
)

NB. =========================================================
dragndrop=: 3 : 0
avail=. ;: 'Amsterdam Athens Berlin Dublin London Madrid Paris Rome Stockholm Vienna'
sel=. ;: 'Helsinki Oslo'
wd DragnDrop
dragndrop_write avail;<sel
wd 'pmove -1 -1 350 400'
wd 'pshow'
)

NB. =========================================================
dragndrop_fm_button=: 3 : 0
'fm to'=. dragndrop_read''
n=. ". fm_select
to=. to,n{fm
fm=. (<<<n){fm
dragndrop_write fm;<to
)

NB. =========================================================
dragndrop_ok_button=: 3 : 0
wd 'pclose'
)

NB. =========================================================
dragndrop_read=: 3 : 0
(<;._2 wd 'get fm allitems');<<;._2 wd 'get to allitems'
)

NB. =========================================================
dragndrop_to_button=: 3 : 0
'fm to'=. dragndrop_read''
n=. ". to_select
fm=. fm,n{to
to=. (<<<n){to
dragndrop_write fm;<to
)

NB. =========================================================
dragndrop_write=: 3 : 0
'fm to'=. y
wd 'set fm items ', ; fm ,each SOH
wd 'set to items ', ; to ,each SOH
)

NB. =========================================================
dragndrop''