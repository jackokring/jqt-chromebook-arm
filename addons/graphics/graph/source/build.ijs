NB. build.ijs

cocurrent 'base'

mkdir_j_ jpath '~Addons/graphics/graph'
mkdir_j_ jpath '~addons/graphics/graph'

writesourcex_jp_ '~Addons/graphics/graph/source';'~Addons/graphics/graph/jzgraph.ijs'

f=. 3 : 0
(jpath '~addons/graphics/graph/',y) (fcopynew ::0:) jpath '~Addons/graphics/graph/',y
)

f 'jzgraph.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/graph/',y) fcopynew jpath '~Addons/graphics/graph/source/',y
(jpath '~addons/graphics/graph/',y) (fcopynew ::0:) jpath '~Addons/graphics/graph/source/',y
)

f 'graph.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/graph/',y) fcopynew jpath '~Addons/graphics/graph/source/',y
(jpath '~addons/graphics/graph/',y) (fcopynew ::0:) jpath '~Addons/graphics/graph/source/',y
)

f 'manifest.ijs'
f 'history.txt'
