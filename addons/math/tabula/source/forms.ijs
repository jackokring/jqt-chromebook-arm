 	NB. tabby - forms.ijs
'==================== [tabby] forms ===================='
0 :0
Sunday 9 June 2019  02:21:25
-
loadFixed PARENTDIR sl 'tpathdev.ijs'
open PARENTDIR sl 'tabula.ijs'
)
coclass 'tabby'

  NB. form position,size factory setting: (may get overridden)
NB. FORM_POSITION=: _1     NB. upper left
NB. FORM_POSITION=: _2     NB. upper right
NB. FORM_POSITION=: _3     NB. lower left
NB. FORM_POSITION=: _4     NB. lower right
FORM_POSITION=: _5     NB. center

TABU=: 0 : 0
pc tab;pn Tabby;
menupop "File";
menu newtt "&New" "Ctrl+N" "Start a new t-table" "new";
menu opent "&Open..." "Ctrl+O" "Open a t-table from user library" "open...";
menu appet "&Append..." "" "Append a t-table from user library" "append...";
menu savex "&Save" "Ctrl+S" "Save current t-table under existing name" "savex";
menu savea "Save As..." "" "Save current t-table under new name" "save as...";
menu savet "Save As Title" "" "Save current t-table under title shown" "savet";
menusep;
menu opens "Open SAMPLE" "Ctrl+Shift+O" "Open SAMPLE t-table" "sample";
menu openn "Open Sample 0-9" "" "Open a numbered sample t-table" "sample";
menu saves "Save As Sample" "" "Save current t-table as default sample" "saves";
menu delsa "Delete Saved Sample" "" "Delete saved default sample" "delete sample";
menusep;
menu stept "Plot 0 to (value)" "" "plot values" "plot";
menu stepu "Plot 1 to (value)" "" "plot values" "plot";
menu stepm "Plot -(value) to (value)" "" "plot values" "plot";
menu plotl "Line Chart" "" "Specify plot: line" "line";
menu plotb "Bar Chart" "" "Specify plot: bar" "bar";
menu plotp "Pie Chart" "" "Specify plot: pie" "pie";
menu plots "Surface Chart" "" "Specify plot: surface" "surface";
menusep;
menu close "Close" "" "Close current t-table" "close t-table";
menu revtt "&Revert changes" "" "Revert changes to t-table" "revert";
menusep;
menu print "Print" "" "Print current t-table" "print t-table";
menusep;
menu quit "&Quit" "Ctrl+Shift+Q" "Quit TABULA" "quit";
menupopz;
menupop "Edit";
menu undo "&Undo" "Ctrl+U" "Undo last action" "undo";
menu redo "&Redo" "Ctrl+Shift+U" "Redo last action" "redo";
menusep;
menu copal "&Copy Ttable" "Ctrl+Shift+C" "copyall" "copy-all";
menusep;
menu label "Edit Item Name" "Ctrl+Shift+N" "Edit name" "name";
menu formu "Edit Formula" "Ctrl+Shift+F" "Edit formula" "formula";
menu erasf "Erase Formula" "" "Erase formula..." "no formula";
menu siunt "Convert to SI Units" "Ctrl+Shift+S" "Convert line to SI units..." "SI units";
menusep;
menu movet "Move Line to Top" "Ctrl+Shift+J" "Move line to top" "movetop";
menu moveu "Move Line Up" "Ctrl+J" "Move line up" "moveup";
menu moved "Move Line Down" "Ctrl+K" "Move line down" "movedown";
menu moveb "Move Line to Bottom" "Ctrl+Shift+K" "Move line to bottom" "movebottom";
menusep;
menu newsl "New Line" "Ctrl+L" "Make a new line" "newline";
menu merge "Merge lines" "Ctrl+M" "Merge lines..." "merge";
menu delit "Delete Line" "" "Delete this line" "delete";
menu dupit "Duplicate Line" "Ctrl+D" "Duplicate this line" "dup";
menusep;
menu updex "Update Exchange Rates" "" "Update currency exchange rates for this t-table" "upd-exch";
menu updin "Update Notes" "" "Update Notes for this t-table" "upd-inf";
rem menusep;
rem menu stup "Startup with TABULA" "" "Fix startup" "stup";
menupopz;
menupop "Command";
menu repet "Repeat" "Ctrl+Shift+R" "Repeat last action" "repeat";
menusep;
menu tthld "Toggle Transient Hold" "Ctrl+Shift+G" "Transient hold" "hold";
menu thold "Toggle Hold" "Ctrl+Shift+H" "Toggle hold" "hold!";
menusep;
menu hidel "Hide Line(s)" "" "Hide selected lines" "hide";
menu unhid "Unhide All Lines" "" "Unhide all hidden lines" "unhide";
menusep;
menu ttabl "Show Ttable" "Ctrl+T" "Show t-table display" "t-table";
menu conss "Show Constants List" "" "Show consts tab" "consts";
menu funcs "Show Functions List" "" "Show functs tab" "functs";
menu infor "Show Ttable Notes" "Ctrl+I" "Show Notes tab" "info";
menupopz;
menupop "Value";
menu Vzero "Zero" "Ctrl+0" "Zero the value" "zero";
menu Vonep "One" "Ctrl+1" "Set the value to 1" "+1";
menu Vonen "Minus One" "" "Set the value to -1" "-1";
menusep;
menu Vabsv "Abs" "" "Absolute Value" "abs";
menu Vdblv "Double" "" "Value doubled" "doubled";
menu Vhlvv "Halve" "" "Value halved" "halved";
menu Vintv "Integer" "" "Value integer" "int";
menu Vinvv "Invert" "" "Value inverted" "inverted";
menu Vnegv "Negate" "" "Value negated" "negated";
menusep;
menu Vsqtv "Sq Root" "" "Value sq-rooted" "sqrt";
menu Vsqrv "Square" "" "Value squared" "squared";
menu Vcbtv "Cube Root" "" "Value cube-rooted" "cubed";
menu Vcubv "Cube" "" "Value cubed" "cubed";
menu Vexpv "Exp" "" "e^value" "exp";
menu Vextv "10^" "" "10^value" "exp";
menu Vetwv "2^" "" "2^value" "exp";
menu Vlnnv "Ln" "" "Value natural-log" "ln";
menu Vltnv "Log10" "" "Value log10" "log10";
menu Vltwv "Log2" "" "Value log2" "log2";
menusep;
menu Vpimv "Times-??" "" "Value times ??" "*??";
menu Vptmv "Times-2??" "" "Value times 2??" "*2??";
menu Vpidv "By-??" "" "Value divided by ??" "/??";
menu Vptdv "By-2??" "" "Value divided by 2??" "/2??";
menupopz;
menupop "Scale";
menu Vunsc "Unscaled"  "" "Unscaled" "unscaled";
menu Vstpu "Step Up"  "" "Step Up" "stepup";
menu Vstpd "Step Down"  "" "Step Down" "stepdown";
menusep;
menu Vdeci "deci-  [/10]"  "" "Divided by 10" "deci";
menu Vcent "centi- [/100]" "" "Divided by 100" "centi";
menu Vmill "milli- [/1000]" "" "Divided by 10^3" "milli";
menu Vmicr "micro- [/10^6]" "" "Divided by 10^6" "micro";
menu Vnano "nano-  [/10^9]"  "" "Divided by 10^9" "nano";
menu Vpico "pico-  [/10^12]"  "" "Divided by 10^12" "pico";
menu Vfemt "femto- [/10^15]" "" "Divided by 10^15" "femto";
menu Vatto "atto-  [/10^18]"  "" "Divided by 10^18" "atto";
menu Vzept "zepto- [/10^21]" "" "Divided by 10^21" "zepto";
menu Vyoct "yocto- [/10^24]" "" "Divided by 10^24" "yocto";
menusep;
menu Vdeca "deca-  [*10]"  "" "Multiplied by 10" "deca";
menu Vhect "hecto- [*100]" "" "Multiplied by 100" "hecto";
menu Vkilo "kilo-  [*1000]" "" "Multiplied by 10^3" "kilo";
menu Vmega "mega-  [*10^6]" "" "Multiplied by 10^6" "mega";
menu Vgiga "giga-  [*10^9]" "" "Multiplied by 10^9" "giga";
menu Vtera "tera-  [*10^12]" "" "Multiplied by 10^12" "tera";
menu Vpeta "peta-  [*10^15]" "" "Multiplied by 10^15" "peta";
menu Vexaa "exa-   [*10^18]"  "" "Multiplied by 10^18" "exa";
menu Vzett "zetta- [*10^21]" "" "Multiplied by 10^21" "zetta";
menu Vyott "yotta- [*10^24]" "" "Multiplied by 10^24" "yotta";
menupopz;
menupop "Function";
menu additems "Add Lines" "" "Add lines" "add";
menu subitems "Subtract Lines" "" "Subtract lines" "subtract";
menu mulitems "Multiply Lines" "" "Multiply lines" "multiply";
menu divitems "Divide Lines" "" "Divide lines" "divide";
menu powitems "Power Lines" "" "Power lines" "power";
menusep;
menu Lequl "Equal Line" "Ctrl+E" "Append equal line" "equal";
menu Labsl "Abs Line" "" "Append abs-value line" "abs";
menu Ldbll "Doubled Line" "" "Append doubled line" "doubled";
menu Lhlvl "Halved Line" "" "Append halved line" "halved";
menu Lintl "Integer Line" "" "Append integer-value line" "int";
menu Linvl "Inverted Line" "" "Append inverted line" "inverted";
menu Lnegl "Negated Line" "" "Append negated line" "negated";
menusep;
menu Lsqtl "Sq Root Line" "" "Append square-rooted line" "sqrt";
menu Lsqrl "Squared Line" "" "Append squared line" "squared";
menu Lcbtl "Cube Root Line" "" "Append cube-rooted line" "cubert";
menu Lcubl "Cubed Line" "" "Append cubed line" "cubed";
menu Lexpl "Exp Line" "" "Append exponential line" "exp";
menu Lextl "10^ Line" "" "Append 10^ line" "exp";
menu Letwl "2^ Line" "" "Append 2^ line" "exp";
menu Llnnl "Ln Line" "" "Append natural-log line" "ln";
menu Lltnl "Log-10 Line" "" "Append log-10 line" "log";
menu Lltwl "Log-2 Line" "" "Append log-10 line" "log";
menusep;
menu Lpiml "Times-?? Line" "" "Append line times ??" "*??";
menu Lptml "Times-2?? Line" "" "Append line times 2??" "*2??";
menu Lpidl "By-?? Line" "" "Append line divided by ??" "/??";
menu Lptdl "By-2?? Line" "" "Append line divided by 2??" "/2??";
menusep;
menu Lt1ml "Times-10 Line" "" "Append line times 10" "*10";
menu Lt2ml "Times-100 Line" "" "Append line times 100" "*100";
menu Lt3ml "Times-1000 Line" "" "Append line times 1000" "*1000";
menu Lt1dl "By-10 Line" "" "Append line divided by 10" "/10";
menu Lt2dl "By-100 Line" "" "Append line divided by 100" "/100";
menu Lt3dl "By-1000 Line" "" "Append line divided by 1000" "/1000";
menupopz;
menupop "Help";
menu hlpt "Help for TABULA" "" "TABULA help" "help";
menu hinf "Notes for this t-table" "" "t-table Notes" "info";
menu togi "Toggle J IDE" "" "toggle IDE" "IDE";
menupopz;
bin v;
 bin hs;
  maxwh 511 63; minwh 511 63; cc g isidraw;
 bin sz;
cc tabs tab;
tabnew T-table;
bin h;
maxwh 40 30; cc preci combobox;
maxwh 100 30; cc unico combobox;
cc calco edit;
cc xunit combobox;
bin z;
cc panel listbox multiple;
tabnew Constants;
cc cons table;
bin h;
cc cappend button;cn "Append";
cc searchc edit;
cc casec checkbox;cn "case-sensitive";
bin z;
tabnew Functions;
cc func table;
bin h;
cc fappend button;cn "Append";
cc searchf edit;
cc casef checkbox;cn "case-sensitive";
bin z;
tabnew Notes;
cc info editm;
bin h;
cc updin button;cn "Update";
bin s1z;
tabnew Prefs;
bin h;
cc label1 static; cn "tab VERSION: ";
cc locat1 edit;
cc label1a static; cn "AABUILT: ";
cc locat1a edit;
cc reld1 button;cn "open";
bin z;
bin h;
cc label2 static; cn "cal VERSION: ";
cc locat2 edit;
cc label2a static; cn "AABUILT: ";
cc locat2a edit;
cc reld2 button;cn "open";
bin z;
bin h;
cc label3 static; cn "uu VERSION: ";
cc locat3 edit;
cc label3a static; cn "AABUILT: ";
cc locat3a edit;
cc reld3 button;cn "open";
bin z;
bin h;
cc labelt static; cn "TABULA PARENTDIR: ";
cc locatt edit;
cc reldt button;cn "tpathdev";
bin z;
bin h;
cc labelu static; cn "_UU_UU PARENTDIR: ";
cc locatu edit;
cc reldu button;cn "tpathdev";
bin z;
bin h;
cc labelc static; cn "-->UUC: ";
cc locatc edit;
cc chosc button;cn "::";
cc editc button;cn "Edit";
cc reldc button;cn "Reload";
bin z;
bin h;
cc labelf static; cn "-->UUF: ";
cc locatf edit;
cc chosf button;cn "::";
cc editf button;cn "Edit";
cc reldf button;cn "Reload";
bin z;
tabend;
cc sbar static; cn "(status unset)";
bin z;
)

0 :0
NB. set sbar addlabel status;
NB. set sbar addlabelp sinf1;
NB. set sbar addlabelp sinf2;
wd 'psel tab; pmove ',": XYWH
form _1
form _2
)

form=: 3 : 0
  NB. (|y) e. 1 2 3 4 5 -move form to screen corners or center???
  NB. 1 2
  NB.  5
  NB. 3 4
  NB. y<0		-resize the form to preferred W H
'Ws Hs'=. 2 3{".wd'psel tab; qscreen'
Hd=. 70  NB. height of Dock
'X Y W H'=. ".wd'qform'
if. y<0 do.
  'W H'=. 536 450
  wd 'pmove _1 _1 ',": W,H
end.
'X0 Y0'=. 1 23
'X1 Y1'=. (Ws - W),(Hs - H+Hd)
select. |y
case. 1 do. 'X Y'=. X0,Y0
case. 2 do. 'X Y'=. X1,Y0
case. 3 do. 'X Y'=. X0,Y1
case. 4 do. 'X Y'=. X1,Y1
case. 5 do. wd 'pcenter' return.
end.
wd 'pmove ',": X,Y,W,H
)


tab_open=: 3 : 0
  NB. serves: start
window_close''
wd TABU
wd 'psel tab'
wd 'set g wh _1 64'
refreshInfo''
t=. ,:UNSET
NB. wd 'set cons font ',fixfont''
NB. wd 'set func font ',fixfont''
wd 'set func font "Menlo" 10'
wd 'set panel font ',fixfont''
wd 'set calco font ',fixfont''
  NB. DONT set fixfont'' for preci or unico -too narrow
NB. wd 'set cons items *',x2f t
NB. wd 'set func items *',x2f t
wd 'set preci items *', o2f ": i.16
wd 'set unico items *',CONTENT_UNICO
wd 'set panel items *',UNSET
NB. confirm 'Click a line and perform some operation on it...'
if. PMOVES do.
  wd :: 0: 'pmoves ' , ":XYWH  NB. activate remembering window position
else.
NB.   wd 'pmove ' , ":XYWH
  form FORM_POSITION
end.
wd 'pshow'
fill_tools ''
)

setprefs=: 3 : 0
  NB. fill data in tab: Prefs
  NB. locatc locatf
wd 'psel tab; set locat1 text *',VERSION_tabby_
wd 'psel tab; set locat2 text *',VERSION_cal_
wd 'psel tab; set locat3 text *',VERSION_uu_
wd 'psel tab; set locat1a text *',AABUILT_tabby_
wd 'psel tab; set locat2a text *',AABUILT_cal_
wd 'psel tab; set locat3a text *',AABUILT_uu_
wd 'psel tab; set locatu text *',PARENTDIR_uu_
wd 'psel tab; set locatt text *',PARENTDIR  NB. _tabby_
wd 'psel tab; set locatc text *',TPUC
wd 'psel tab; set locatf text *',TPUF
)

tab_reldc_button=: 3 : 0
smoutput '>>>TESTONLY tab_reldc_button: reload UUC'
)

tab_reldf_button=: 3 : 0
smoutput '>>>TESTONLY tab_reldc_button: reload UUF'
)

tab_reldt_button=: 3 : 0
loadFixed PARENTDIR sl 'tpathdev.ijs'
setprefs''
smoutput tpaths''
smoutput date''
)

tab_reldu_button=: 3 : 0
loadFixed PARENTDIR_uu_ sl 'tpathdev.ijs'
setprefs''
smoutput tpaths''
smoutput date''
)

tab_reld1_button=: 3 : 'open TPTA,''/tabula.ijs'''
tab_reld2_button=: 3 : 'open TPCA,''/cal.ijs'''
tab_reld3_button=: 3 : 'open TPUU,''/uu.ijs'''
tab_editc_button=: 3 : 'open TPUC,''/uuc.ijs'''
tab_editf_button=: 3 : 'open TPUF,''/uuf.ijs'''
