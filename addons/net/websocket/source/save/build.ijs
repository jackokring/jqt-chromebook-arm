NB. websocket build

P=: jpath '~Addons/net/websocket/source/'
A=: jpath '~Addons/net/websocket/'

mkdir_j_ A,'demo1'
mkdir_j_ A,'demo2'
mkdir_j_ A,'demo3/codemirror'
mkdir_j_ A,'demo4'

(readsource_jp_ P,'demo1') fwritenew A,'demo1/run.ijs'
(readsource_jp_ P,'demo2') fwritenew A,'demo2/run.ijs'
(readsource_jp_ P,'demo3') fwritenew A,'demo3/run.ijs'
(readsource_jp_ P,'demo4') fwritenew A,'demo4/run.ijs'
(readsourcex_jp_ P,'server') fwritenew A,'websocket.ijs'

f=: 3 : '(A,y) fcopynew P,y'

f 'demo.css'
f 'client.ijs'
f 'demo1/index.html'
f 'demo2/index.html'
f 'demo2/demo.js'
f 'demo3/index.html'
f 'demo4/index.html'

f=: 3 : 'freads P,''demo3/'',y,''.js'''
(A,'demo3/demo.js') fwritenew~ ;f each ;: 'log term main'

f=: 3 : 'freads P,''demo4/'',y,''.js'''
(A,'demo4/demo.js') fwritenew~ ;f each ;: 'cube draw drag'

hostcmd=: [: 2!:0 '(' , ,&' || true)'

hostcmd^:IFUNIX 'rsync -r --delete ',P,'demo3/codemirror/* ',A,'demo3/codemirror'
hostcmd^:IFUNIX 'rsync -r --delete ',A,'* ',jpath '~addons/net/websocket'
