NB. build.ijs

mkdir_j_ jpath '~Addons/graphics/print'
mkdir_j_ jpath '~addons/graphics/print'

writesourcex_jp_ '~Addons/graphics/print/source';'~Addons/graphics/print/print.ijs'

f=. 3 : 0
(jpath '~addons/graphics/print/',y) (fcopynew ::0:) jpath '~Addons/graphics/print/',y
)

f 'print.ijs'

f=. 3 : 0
(jpath '~Addons/graphics/print/',y) fcopynew jpath '~Addons/graphics/print/source/',y
(jpath '~addons/graphics/print/',y) (fcopynew ::0:) jpath '~Addons/graphics/print/source/',y
)

f ;._2 (0 : 0)
manifest.ijs
history.txt
printfns.txt
)
