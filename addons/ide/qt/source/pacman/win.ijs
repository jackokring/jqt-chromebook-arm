NB. view form

NB. =========================================================
PMVIEW=: 0 : 0
pc pm;
menupop "&File";
menu exit "&Quit" "Ctrl+Q";
menupopz;
menupop "&Tools";
menu pupcat "&Update Catalog from Server";
menusep;
menu prebuild "&Rebuild all Repository Catalogs";
menusep;
menu remove "Re&move Selected Packages";
menupopz;
splith 0 1 100 100;
cc sel listbox;
bin p5h;
cc bstatus radiobutton;cn "Status";
cc bsection radiobutton group;cn "Category";
bin zp5;
groupbox Selections;
cc bclear button;cn "Clear All";
cc bupdate button;cn "Updates";
cc bnotins button;cn "Not Installed";
cc bselall button;cn "Select All";
bin p5;
cc apply button;cn "Install";
groupboxend;
splitsep;
splitv 1 0 100 150;
cc pac table selectrows;
splitsep;
cc edlog editm readonly;
bin p5h;
cc bsummary radiobutton;cn "Summary";
cc bhistory radiobutton group;cn "History";
cc bmanifest radiobutton group;cn "Manifest";
cc blog radiobutton group;cn "Log";
bin s1;
cc binfo button;cn "Wiki";
splitend;
splitend;
)

NB. =========================================================
PMVIEW_S=: 0 : 0
pc pm;
menupop "&File";
menu exit "&Quit" "Ctrl+Q";
menupopz;
menupop "&Tools";
menu pupcat "&Update Catalog from Server";
menusep;
menu prebuild "&Rebuild all Repository Catalogs";
menusep;
menu remove "Re&move Selected Packages";
menupopz;
bin v;
cc sel combolist;
bin h;
cc bstatus radiobutton;cn "Status";
cc bsection radiobutton group;cn "Category";
bin s;
cc binfo button;cn "Wiki";
bin z;
bin vh;
cc apply button;cn "Install";
bin s;
cc selection static;cn "Selections";
cc bselall button;cn "Select All";
bin zh;
cc bclear button flush;cn "Clear All";
cc bupdate button;cn "Updates";
cc bnotins button;cn "Not Installed";
bin szz;
cc pac table selectrows;
cc edlog editm readonly;
bin h;
cc bsummary radiobutton flush;cn "Summary";
cc bhistory radiobutton group;cn "History";
cc bmanifest radiobutton group;cn "Manifest";
cc blog radiobutton group;cn "Log";
bin sz;
bin z;
)

NB. =========================================================
pmview_edlog=: 3 : 0
MSGX=: '1' i.~ bsummary,bhistory,bmanifest,blog
pmview_showlog''
)

NB. =========================================================
pmview_postinit=: 3 : 0
pmview_setmenu''
pmview_show''
logstatus''
)

NB. =========================================================
pmview_read=: 3 : 0
IFSECTION=: 0 ". bsection
SELNDX=: (0 ". sel_select) IFSECTION } SELNDX
)

NB. =========================================================
pmview_open=: 3 : 0
wh=. 900 700 <. 200 20 -~ 2 3 { 0 ". wd 'qscreen'
wd PMVIEW
wd 'set bsummary value 1'
wd 'set bstatus value 1'
wd 'pn *',SYSNAME
wd 'set pac shape 0 5'
wd 'set pac type 100 0 0 0 0'
wd 'set pac hdr "     " Package Installed Latest Caption'
wd 'pmove 100 10 ',":wh
wd 'pshow'
window=: 1
)
