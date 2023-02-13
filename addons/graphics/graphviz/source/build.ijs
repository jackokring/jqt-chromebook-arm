
DA=: jpath '~Addons/graphics/graphviz'
da=: jpath '~addons/graphics/graphviz'

writesourcex_jp_ (DA,'/source');DA,'/graphviz.ijs'

(fread DA,'/smgraph.ijs') fwrites DA,'/smgraph.ijs'
(fread DA,'/graphview.ijs') fwrites DA,'/graphview.ijs'

NB. =========================================================
NB. copy to ~addons for testing only...
mkdir_j_ da

(fread DA,'/graphviz.ijs') fwritenew da,'/graphviz.ijs'

require 'pacman'

f=: 3 : 0
dircopy_jpacman_ (DA,'/',y);da,'/',y
)

f each ;:'fonts source testsm'