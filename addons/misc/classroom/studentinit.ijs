NB. This script initializes the user's configuration for subsequent automated
NB. profile updates.  This script runs when loaded, and should be run only once.
NB. The user needs to be ready with the URL of the actual profile.

NB. The idea is that the teacher can update the shared profile at any time
NB. and the student will automatically get the new version.

cocurrent 'base'
3 : 0''
NB. Bring in and initialize the web-read system
require 'sockets/sockutils/webio'
initialize 0
NB. Loop till we get a valid URL
whilst. 0 = #url do.
  NB. Prompt user for URL
  url =. wd 'mb input text "Script URL?" "What is the URL of your profile?" "www.raleighcharterhs.org/faculty/hhrich/rchs.ijs"'
  NB. If user gave no URL, abort
  if. 0 = #url do. break. end.
  NB. Make sure it can be read
  'domain page' =. '/' (taketo ; dropto) url
  'rc text' =. 2 {. ((<,<'') ; domain ; page) webgetform 0 2 $ a:
  if. (rc ~: 0) +. (0 = #text) do.
    NB. URL not found, try again
    wdinfo 'Try again';'That URL is unreadable'
    url =. ''
  end.
end.
if. #url do.
  NB. URL was readable - update it and the startup script
  scriptname =. '/' taketo&.|. url
  text 1!:2 scriptfn =. < jpath '~config/' , scriptname
  NB. Append initialization to the config file
  initline =. < 'remoteprofile ' , (quote url) , '[ require ''misc/classroom/remoteprofile''' , LF
  configfn =. < jpath '~config/startup.ijs'
  NB. If the script already contains remoteprofile, replace that
  configlines =. <;.2 LF ,~^:(~: {:) CR -.~ (1!:1 :: (''"_)) configfn
  if. 1 e. prevmsk =. 'remoteprofile '&([ -: #@[ {. ])&> configlines do.
    configlines =. initline (prevmsk i. 1)} configlines
  else.
    configlines =. configlines , initline
  end.
  (;configlines) 1!:2 configfn
  NB. Execute the profile to save a restart
  script scriptfn
else.
  smoutput 'No URL given - configuration not updated'
end.
0 0$0
)
