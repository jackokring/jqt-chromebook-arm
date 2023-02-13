NB. build.ijs

mkdir_j_ jpath '~Addons/api/jni'
mkdir_j_ jpath '~addons/api/jni'

writesourcex_jp_ '~Addons/api/jni/source';'~Addons/api/jni/jni.ijs'

(jpath '~addons/api/jni/jni.ijs') (fcopynew ::0:) jpath '~Addons/api/jni/jni.ijs'

f=. 3 : 0
(jpath '~Addons/api/jni/',y) fcopynew jpath '~Addons/api/jni/source/',y
(jpath '~addons/api/jni/',y) (fcopynew ::0:) jpath '~Addons/api/jni/source/',y
)

f 'manifest.ijs'
f 'history.txt'
