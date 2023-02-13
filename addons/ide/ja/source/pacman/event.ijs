NB. event

NB. =========================================================
pm_apply_button=: 3 : 0
dat=. pmview_selected''
if. 0 = #dat do.
  info 'No packages selected for installation.' return.
end.
if. -. ONLINE do.
  if. -. getonline 'Install Packages';CHECKONLINE do. return. end.
end.
install dat
pmview_show''
)

NB. =========================================================
pm_bclear_button=: 3 : 0
setshowall 0
pmview_show''
)

NB. =========================================================
pm_bnotins_button=: 3 : 0
setshownew 1
pmview_show''
)

NB. =========================================================
pm_bsection_button=: 3 : 0
IFSECTION=: '1'={.bsection
pmview_show''
)

NB. =========================================================
pm_bselall_button=: 3 : 0
setshowall 1
pmview_show''
)

NB. =========================================================
pm_bupdate_button=: 3 : 0
setshowups 1
pmview_show''
)

NB. =========================================================
pm_close=: pm_exit_button=: 3 : 0
wd 'pclose'
if. 'Android'-:UNAME do.
  smact''
end.
destroy''
)

NB. =========================================================
pm_remove_button=: 3 : 0
dat=. pmview_selected''
if. 0 = #dat do.
  info 'No packages selected for removal.' return.
end.
remove_console 1{"1 pmview_selected''
pmview_show''
)

NB. =========================================================
pm_msg=: 3 : 0
MSGX=: y
pmview_showlog''
)

NB. =========================================================
pm_pac_select=: 3 : 0
DATAX=: {. 0 ". pac_click
)

NB. =========================================================
pm_prebuild_button=: 3 : 0
if. -. ONLINE do.
  getonline 'Read Catalog from Server';CHECKASK
end.
if. ONLINE do.
  log 'Updating server catalog...'
  refreshjal''
end.
log 'Rebuilding local file list...'
refreshaddins''
readlocal''
log 'Done.'
pacman_init''
pmview_show''
)

NB. =========================================================
pm_pupcat_button=: 3 : 0
if. -. ONLINE do.
  if. 0 = getonline 'Read Catalog from Server';CHECKASK do. return. end.
end.
log 'Updating server catalog...'
if. refreshweb'' do.
  log 'Done.'
end.
pacman_init''
pmview_show''
)

NB. =========================================================
pm_sel_select=: 3 : 0
SELNDX=: (0 ". sel_select) IFSECTION } SELNDX
pmview_sel''
)

NB. =========================================================
pm_bsummary_button=: pm_msg bind 0
pm_bhistory_button=: pm_msg bind 1
pm_bmanifest_button=: pm_msg bind 2
pm_blog_button=: pm_msg bind 3

pm_binfo_button=: addon_info
pm_bstatus_button=: pm_bsection_button
