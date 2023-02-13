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
bin v;
wh _1 _2;cc sel combolist;
bin h;
cc bstatus radiobutton horizontal;cn "Status";
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
bin v;
wwh 1 _1 _2;cc pac listbox multiple;
bin h;
cc bsummary button;cn "Summary";
cc bhistory button;cn "History";
cc bmanifest button;cn "Manifest";
cc blog button;cn "Log";
bin z;
bin z;
bin z;
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
wd PMVIEW
wd 'set bstatus value 1'
wd 'pn *',SYSNAME
wd 'pshow'
window=: 1
pmview_show''
)
