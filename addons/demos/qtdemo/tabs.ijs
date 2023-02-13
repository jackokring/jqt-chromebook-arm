NB. tabdemo
NB.
NB. this is the controls demo in 3 tabs
NB.
NB. cc id tab     - start a tabs control with keywords:
NB.   closable         tab can be closed
NB.   documentmode     (default off)
NB.   east|south|west  (default north)
NB.   icon
NB.   movable          (default fixed)
NB.   tooltip
NB.
NB. tabnew id        start a single tab
NB. ...
NB. tabend           end tabs control

coclass 'qtdemo'

NB. =========================================================
Tabdemo=: 0 : 0
pc tabdemo closeok escclose;
cc prefs tab closable movable;

tabnew View;
cc linear radiobutton;
cn "view linear";
cc boxed radiobutton group;
cn "view boxed";
cc tree radiobutton group;
cn "view tree";
bin s1;

tabnew Editor;
cc gross radiobutton;
cc net radiobutton group;
cc paid checkbox;
bin z s1 z;
cc names combobox;

tabnew Dummy;
cc list listbox;
cc entry edit;set _ sizepolicy expanding;
cc ted editm;

tabend;

bin h s2;
cc ok button;cn "Push Me";
cc cancel button;cn "Cancel";

set boxed value 1;
set net value 1;
set names items Bressoud Frye Rosen Wagon;
set names select 2;
set entry text 盛大 abc 大嘴鳥;
set list items one "two turtle doves" three "four colly birds" five six seven;

)

NB. =========================================================
tabdemo_run=: 3 : 0
wd Tabdemo
wd 'set ted text *How grand to be a Toucan',LF,'Just think what Toucan do.'
wd 'set prefs active 1'
wd 'set prefs label 2 Notes'
wd 'set prefs tooltip 0 "toolip view"'
wd 'set prefs tooltip 1 "toolip editor"'
wd 'set prefs icon 0 qstyle::sp_fileicon'
wd 'set prefs icon 1 qstyle::sp_diropenicon'
wd 'set prefs icon 2 qstyle::sp_mediavolume'
wd 'pmove 400 10 400 200'
wd 'pshow'
)

NB. =========================================================
tabdemo_prefs_tabclose=: 3 : 0
wd 'set prefs tabclose ',prefs_select
)

NB. =========================================================
tabdemo_cancel_button=: tabdemo_close=: 3 : 0
wd 'pclose'
showevents_jqtide_ 0
)


showevents_jqtide_ 2
tabdemo_run''
