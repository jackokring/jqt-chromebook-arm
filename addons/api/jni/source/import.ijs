NB. =========================================================
JNI_IMPORT=: (<;._1);._2 (0 : 0)
 Boolean Ljava/lang/Boolean
 Btye Ljava/lang/Btye
 Char Ljava/lang/Char
 Class Ljava/lang/Class
 CharSequence Ljava/lang/CharSequence
 Double Ljava/lang/Double
 Float Ljava/lang/Float
 Integer Ljava/lang/Integer
 Long Ljava/lang/Long
 Object Ljava/lang/Object
 Short Ljava/lang/Short
 String Ljava/lang/String
)

jniImport=: 3 : 0
if. (<'jni') -: 18!:5'' do. EMPTY return. end.
if. 0~:4!:0<'JNI_IMPORT' do. JNI_IMPORT=: JNI_IMPORT_jni_ end.
for_b. <;._2 y do.
  d=. }. (}.~ i:&'/') c=. './' charsub >b
  if. (<d) e. {."1 JNI_IMPORT do. continue. end.
  JNI_IMPORT=: JNI_IMPORT, d;'L',c
end.
EMPTY
)

NB. x 1 remove leading L
jniResolve=: 0&$: : (4 : 0)
if. 'L'~:{.y do. y return. end.
if. 0~:4!:0<'JNI_IMPORT' do. }.^:x y return. end.
if. 0=#JNI_IMPORT do. }.^:x y return. end.
if. 1 e. './' e. y do. }.^:x y return. end.
y1=. }:^:(';'={:) }.y
a=. {."1 JNI_IMPORT
if. (i=. a i. <y1) < #a do.
  }.^:x ((';'={:y)#';'),~ (<i,1){::JNI_IMPORT
else.
  }.^:x y
end.
)

