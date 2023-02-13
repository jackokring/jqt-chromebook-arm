
NB. =========================================================
NB. download and install liblz4.dll for windows
install=: 3 : 0
if. -. IFWIN do. return. end.
require 'pacman'
'rc p'=. httpget_jpacman_ 'http://www.jsoftware.com/download/', z=. 'winlib/',(IF64{::'x86';'x64'),'/liblz4.dll'
if. rc do.
 smoutput 'unable to download: ',z return.
end.
(jpath '~addons/arc/lz4/lib/',IF64{::'liblz4_32.dll';'liblz4.dll') 1!:2~ 1!:1 <p
1!:55 ::0: <p
smoutput 'done'
EMPTY
)

