NB. lib version

NB. =========================================================
NB. library:
NB. First part of this script is making sure the library is loaded
3 : 0''
if. UNAME-:'Linux' do.
  liblapacke=: 'liblapacke.so.3'
elseif. UNAME-:'Android' do.
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  if. IF64 < arch-:'arm64-v8a' do.
    arch=. 'armeabi-v7a'
  elseif. IF64 < arch-:'x86_64' do.
    arch=. 'x86'
  end.
  liblapacke=: (jpath'~bin/../libexec/',arch,'/liblapacke.so')
elseif. do.
  ext=. (('Darwin';'Win') i. <UNAME) pick ;:'dylib dll so'
  liblapacke=: jpath '~addons/api/lapacke/lib/liblapacke',((-.IF64)#'_32'),'.',ext
end.
)

NB. =========================================================
checklibrary=: 3 : 0
if. UNAME-:'Linux' do.
  if. 0-: (liblapacke, ' LAPACKE_get_nancheck i ')&cd ::0: '' do.
    sminfo 'liblapacke package has not yet been installed.'
  end.
  return.
end.
if. +./ IFIOS,(UNAME-:'Darwin'),(UNAME-:'Android') do. NB. not yet
  sminfo 'LAPACKE';'The api/lapacke addon is not available for this platform.' return.
end.
if. -. fexist liblapacke do.
  getbinmsg 'The api/lapacke binary has not yet been installed.',LF2,'To install, ' return.
end.
)

NB. =========================================================
NB. get lapacke binary
NB. uses routines from pacman
getbin=: 3 : 0
if. +./ IFIOS,(UNAME-:'Linux') do. return. end.
if. IFWIN *. -. fexist '~addons/math/lapack/jlapack',(IF64#'64'),'.dll' do.
  smoutput 'Install math/lapack first. Need jlapack',(IF64#'64'),'.dll'
  return.
end.
require 'pacman'
path=. 'http://www.jsoftware.com/download/lapackebin/'
arg=. HTTPCMD_jpacman_
tm=. TIMEOUT_jpacman_
dq=. dquote_jpacman_ f.
to=. liblapacke_jlapacke_
if. UNAME-:'Android' do.
  path=. 'http://www.jsoftware.com/download/'
  arch=. LF-.~ 2!:0'getprop ro.product.cpu.abi'
  if. IF64 < arch-:'arm64-v8a' do.
    arch=. 'armeabi-v7a'
  elseif. IF64 < arch-:'x86_64' do.
    arch=. 'x86'
  end.
  fm=. path,'android/libs/',z=. arch,'/liblapacke.so'
  'res p'=. httpget_jpacman_ fm
  if. res do.
    smoutput 'Connection failed: ',z return.
  end.
  (<to) 1!:2~ 1!:1 <p
  2!:0 ::0: 'chmod 644 ', dquote to
  1!:55 ::0: <p
  smoutput 'LAPACKE binary installed.'
  return.
end.
fm=. path,(IFRASPI#'raspberry/'),1 pick fpathname to
lg=. jpath '~temp/getbin.log'
cmd=. arg rplc '%O';(dquote to);'%L';(dquote lg);'%t';'3';'%T';(":tm);'%U';fm
res=. ''
fail=. 0
try.
  fail=. _1-: res=. shellcmd cmd
  2!:0 ::0:^:(UNAME-:'Linux') 'chmod 644 ', dquote to
catch. fail=. 1 end.
if. fail +. 0 >: fsize to do.
  if. _1-:msg=. freads lg do.
    if. (_1-:msg) +. 0=#msg=. res do. msg=. 'Unexpected error' end. end.
  ferase to,lg
  smoutput 'Connection failed: ',msg
else.
  ferase lg
  if. IFWIN do.
    '~bin/liblapack.dll' fcopynew '~addons/math/lapack/jlapack',(IF64#'64'),'.dll'
  end.
  smoutput 'LAPACKE binary installed.'
end.
)

NB. =========================================================
getbinmsg=: 3 : 0
msg=. y,' run the getbin_jlapacke_'''' line written to the session.'
smoutput '   getbin_jlapacke_'''''
sminfo 'LAPACKE';msg
)

NB. =========================================================
shellcmd=: 3 : 0
if. IFUNIX do.
  hostcmd_j_ y
else.
  spawn_jtask_ y
end.
)
