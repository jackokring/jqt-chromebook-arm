NB. build.ijs

mkdir_j_ jpath '~Addons/api/gles'
mkdir_j_ jpath '~addons/api/gles'

writesourcex_jp_ '~Addons/api/gles/source';'~Addons/api/gles/gles.ijs'

(jpath '~addons/api/gles/gles.ijs') (fcopynew ::0:) jpath '~Addons/api/gles/gles.ijs'

f=. 3 : 0
(jpath '~Addons/api/gles/',y) fcopynew jpath '~Addons/api/gles/source/',y
(jpath '~addons/api/gles/',y) (fcopynew ::0:) jpath '~Addons/api/gles/source/',y
)

f 'manifest.ijs'
f 'history.txt'
