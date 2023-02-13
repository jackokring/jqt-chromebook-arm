NB. controls demos
NB. also:
NB. pc controls closeok
NB. pc controls escclose

coclass 'qtdemo'

Controls=: 0 : 0
pc controls;
rem make nested vertical, horizontal, vertical bins:;
bin vhv;

groupbox Display;
cc linear radiobutton;
cn "view linear";
cc boxed radiobutton group;
cn "view boxed";
cc tree radiobutton group;
cn "view tree";
groupboxend;

bin zv;

groupbox "Expense Type";
cc gross radiobutton;
cc net radiobutton group;
cc paid checkbox;
set boxed value 1;
set net value 1;
groupboxend;

bin z s1 z;
cc names combobox;
set names items Bressoud Frye Rosen Wagon;
set names select 2;
cc list listbox;
set list items one "two turtle doves" three "four colly birds" five six seven;
cc entry edit;
set entry text 盛大 abc 大嘴鳥;
cc ted editm readonly;
rem demonstrate bin and child stretch:;
bin h s2;
cc iconbutton button;cn "";
cc ok button;cn "Push Me";
cc cancel button default;cn "Cancel";
set ok stretch 1;
)

NB. =========================================================
controls_run=: 3 : 0
wd 'verbose 2'
wd Controls
wd 'set ted stylesheet *background-color:#eeeeee'
wd 'set ted text *How grand to be a Toucan',LF,'Just think what Toucan do.'
wd 'set iconbutton icon ', (dquote jpath '~addons/graphics/bmp/toucan.bmp'), ' 204x148'
wd 'set tree icon ', dquote jpath '~addons/ide/qt/images/about.png'
wd 'set paid icon ', dquote jpath '~addons/ide/qt/images/clear.png'
wd 'pmove 400 10 300 300'
wd 'pshow'
smoutput wd'get ted stylesheet'
wd 'setp taborder list names ok entry'
wd 'setp tooltip *tooltip for form'
NB. tooltip
wd 'set names tooltip *tooltip for combobox'
wd 'set list tooltip *tooltip for listbox'
wd 'set ted tooltip *<font color="Red">tooltip</font> for <br> <br> <i>editm</i>'
wd 'set ok tooltip *tooltip for button'
NB. reset tooltip
wd 'set ok tooltip'
wd 'verbose 0'
)

NB. =========================================================
controls_close=: 3 : 0
wd 'pclose'
showevents_jqtide_ 0
)

showevents_jqtide_ 2
controls_run''

controls_cancel_button=: controls_close
