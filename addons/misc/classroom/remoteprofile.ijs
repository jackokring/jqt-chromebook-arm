NB. Load and execute remote profile

NB. y is the url of the remote profile.  We load it and run it.
NB. The profile is backed up in ~config, so that if the Internet is unavailable
NB. the last-saved copy will be used.  Thus, we try to load the remote
NB. profile; update the saved if necessary; then run the saved.

NB. We have to initialize the web system before reading.

require 'sockets/sockutils/webio'
cocurrent 'base'
remoteprofile =: 3 : 0
url =. y
scriptfn =. < jpath '~config/' , '/' taketo&.|. url  NB. fn of local copy
NB. Make sure webio is initialized
initialize 0
NB. Read from the URL
if. 0 = #url do. smoutput 'error loading profile - no URL' return. end.

NB. Make sure it can be read
'domain page' =. '/' (taketo ; dropto) url
'rc text' =. 2 {. ((<,<'') ; domain ; page) webgetform 0 2 $ a:

NB. If the data was read OK, update the local copy in ~config
if. (rc = 0) *. (0 ~: #text) do.
  NB. Update only if data changed, so as to keep old date
  if. text -.@-: (1!:1 :: (''"_)) scriptfn do.
    text 1!:2 scriptfn
  end.
end.

NB. Execute the local copy
script scriptfn
i.0 0
)