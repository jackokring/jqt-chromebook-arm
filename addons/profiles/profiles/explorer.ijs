NB. Set up config for exploring J

NB. User keys: F2=dissect F3=Dissect Error F4=lint

NB. Packages loaded: plot viewmat printf dissect lint

NB. Check for updates at every startup

pfkeydefs =. 0 : 0
F2;0;Dissect Line;dissect&.finddissectline_dissect_ 0
F3;0;Dissect Last Error;dissect&.finddissectline_dissect_ 1
F4;0;Lint;lintwindow_lint_''
)

startuptxt =. (LF,'))') (|.!.1@:-.@:E. # ]) 0 : 0
pkgstoload =. 0 : 0
plot
viewmat
format/printf
debug/dissect
debug/lint
))

3 : 0 pkgstoload
NB. Keep packages up-to-date
load 'pacman'
savlog =. LOG_jpacman_
LOG_jpacman_ =: 0
'update' jpkg ''
newpkgs =. {."1 'shownotinstalled' jpkg ''
newpkgs =. newpkgs , {."1 'showupgrade' jpkg ''
if. #newpkgs do.
  smoutput 'Installing updated addons'
  'install' jpkg ;:^:_1 newpkgs
end.
LOG_jpacman_ =: savlog

NB. Load the packages we need.  Load, not require, to get updates
load ' ' (I. LF = y)} y
))

)

3 : 0 pfkeydefs ; startuptxt
'pfs startup' =. y
NB. Read the user's startup file and PF keys.
NB. If there are non-comments, prompt for overwrite
startupd =. 1!:1 :: (''"_) startupfn =. < jpath '~config/startup.ijs'
keyd =. 1!:1 :: (''"_) keyfn =. < jpath '~config/userkeys.ijs'
startnborblank =. ((0=#) +. 'NB.' -: 3&{.)@deb@> startuplines =. <;.2 CR -.~ LF ,~^:(~: {:) startupd
keynborblank =. ((0=#) +. 'NB.' -: 3&{.)@deb@> keylines =. <;.2 CR -.~ LF ,~^:(~: {:) keyd
NB. Preserve leading comments in startup & user keys, so as to keep user-key legend
startupdnew =. (; (*./\ startnborblank) # startuplines) , startup
keydnew =. (; (*./\ keynborblank) # keylines) , pfs

NB. If no change, tell the user so they'll stop doing this
if.  (startupdnew -: startupd) *. (keydnew -: keyd) do.
  smoutput 'This profile was already installed - no need to install again'
  i. 0 0 return.
end.

if. 0 e. keynborblank , startnborblank do.
  if. 'yes' -.@-: wd 'mb query =mb_yes mb_no "Rewrite configuration?" "OK to replace your startup and user keys assignments?"' do.
    smoutput 'No changes made.'
    i.0 0 return.
  end.
end.

NB. Write out the startup and PFkey information
try.
  startupdnew 1!:2 startupfn
catch.
  smoutput 'Error writing configuration file'
  i. 0 0 return.
end.
try.
  keydnew 1!:2 keyfn
catch.
  smoutput 'Error writing user-keys file'
  i. 0 0 return.
end.

NB. Restart
wdinfo 'J must restart';'To use your new configuration you must restart J.  This window will close.'
2!:55 (0)
)