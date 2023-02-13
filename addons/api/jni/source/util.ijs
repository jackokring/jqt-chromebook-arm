NB. util

NB. =========================================================
NB.*jniCheck v check jni for exceptions
jniCheck=: 3 : 0
]`('JNI exception' (13!:8) 3:)@.(0 ~: a. i. >@{.@ExceptionCheck_jni_@(''"_)) y
:
]`('JNI exception' (13!:8) 3:)@.(0 ~: a. i. (x&(>@{.@ExceptionCheck_jni_)@(''"_)) y
)

NB. =========================================================
NB.*jniToJString v get utf-8 string from jstring object
jniToJString=: 3 : 0
if. 0=y do. '' return. end.
jniCheck str=. >@{. GetStringUTFChars y;<<0
z=. utf8@:ucp memr str,0,_1
jniCheck ReleaseStringUTFChars y;<<str
z
)

NB. =========================================================
NB.*jniFromObjarr v get objects from array object
jniFromObjarr=: 3 : 0
jniCheck >@{.@GetObjectArrayElement"1 y;"0 i. GetArrayLength <y
)

NB. =========================================================
NB.*jniToObjarr v new array object from objects
jniToObjarr=: 3 : 0
jniCheck clz=. >@{. FindClass <'java/lang/Object'
jniCheck z=. >@{. NewObjectArray (#y);clz;0
jniCheck DeleteLocalRef <clz
for_i. i.#y do.
  jniCheck SetObjectArrayElement z;i;i{y
end.
z
)

NB. =========================================================
NB.*jniToStringarr v new string array from utf8 string
jniToStringarr=: 3 : 0
jniCheck clz=. >@{. FindClass <'java/lang/String'
jniCheck z=. >@{. NewObjectArray (#y);clz;0
jniCheck DeleteLocalRef <clz
for_i. i.#y do.
  jniCheck SetObjectArrayElement z;i;s=. >@{. NewStringUTF utf8@:(3&u:)@:ucp@,&.> i{y
  jniCheck DeleteLocalRef <s
end.
z
)

NB. =========================================================
NB.*jniException v get exception message
jniException=: 3 : 0
try.
  ExceptionClear''
  jniCheck cls=. >@{. GetObjectClass <y
  jniCheck mid=. >@{. GetMethodID cls;'getMessage';'()Ljava/lang/String;'
  jniCheck jstr=. >@{. 'x x x x' (ID_CallObjectMethod jniVararg) y ; mid
  z=. jniToJString jstr
  jniCheck DeleteLocalRef <jstr
  jniCheck DeleteLocalRef <cls
  jniCheck DeleteLocalRef <y
  ExceptionClear''
  z
catch.
  jniCheck DeleteLocalRef <y
  ExceptionClear''
  '' return.
end.
)

NB. =========================================================
NB.*jniClassName v get class name of an object
jniClassName=: 0&$: : (4 : 0)
try.
  jniCheck ccls=. >@{. FindClass <'java/lang/Class'
  jniCheck mid=. >@{. GetMethodID ccls;'getName';'()Ljava/lang/String;'
  if. 0=x do.
    jniCheck ecls=. >@{. GetObjectClass <y
  else.
    ecls=. y
  end.
  jniCheck jstr=. >@{. 'x x x x' (ID_CallObjectMethod jniVararg) ecls ; mid
  z=. jniToJString jstr
  if. 0=x do. DeleteLocalRef <ecls end.
  jniCheck DeleteLocalRef <jstr
  jniCheck DeleteLocalRef <ccls
  ExceptionClear''
  z
catch.
  ExceptionClear''
  '' return.
end.
)

NB. =========================================================
NB. jniField
NB. m field type
NB. y object
NB. x new value
jniField=: 1 : 0
NB. get
'field sig'=. <;._1 ' ', deb m
rt=. field,' ',jniSigniture sig
assert. 1 4 e.~ 3!:0 y [ 'jniField'
assert. 0-.@-:y [ 'jniField'
jniCheck cls=. >@{. GetObjectClass_jni_ <y
z=. rt jniCallField_jni_ 0;y;cls
jniCheck DeleteLocalRef_jni_ <cls
z
:
NB. set
'field sig'=. <;._1 ' ', deb m
rt=. field,' ',jniSigniture sig
assert. 1 4 e.~ 3!:0 y [ 'jniField'
assert. 0-.@-:y [ 'jniField'
jniCheck cls=. >@{. GetObjectClass_jni_ <y
rt jniCallField_jni_ (0;y;cls), boxxopen x
jniCheck DeleteLocalRef_jni_ <cls
EMPTY
)

NB. =========================================================
NB. jniStaticField
NB. m field type
NB. y object
NB. x new value
jniStaticField=: 1 : 0
NB. get
'field sig'=. <;._1 ' ', deb m
rt=. field,' ',jniSigniture sig
newcls=. 1
if. 32 e.~ 3!:0 y do.
  assert. 1 4 e.~ 3!:0 >y [ 'jniStaticField'
  newcls=. 0
  cls=. {.>y
elseif. 1 4 e.~ 3!:0 y do.
  assert. 0-.@-:y [ 'jniStaticField'
  jniCheck cls=. >@{. GetObjectClass_jni_ <y
elseif. do.
  assert. ''-.@-:y [ 'jniStaticField'
  class=. './' charsub y -. ';'
  class=. 1&jniResolve 'L',class
  jniCheck cls=. >@{. FindClass_jni_ <class
end.
z=. rt jniCallField_jni_ 1;y;cls
if. newcls do.
  jniCheck DeleteLocalRef_jni_ <cls
end.
z
:
NB. set
'field sig'=. <;._1 ' ', deb m
rt=. field,' ',jniSigniture sig
newcls=. 1
if. 32 e.~ 3!:0 y do.
  assert. 1 4 e.~ 3!:0 >y [ 'jniStaticField'
  newcls=. 0
  cls=. {.>y
elseif. 1 4 e.~ 3!:0 y do.
  assert. 0-.@-:y [ 'jniStaticField'
  jniCheck cls=. >@{. GetObjectClass_jni_ <y
elseif. do.
  assert. ''-.@-:y [ 'jniStaticField'
  class=. './' charsub y -. ';'
  class=. 1&jniResolve 'L',class
  jniCheck cls=. >@{. FindClass_jni_ <class
end.
rt jniCallField_jni_ (1;y;cls), boxxopen x
if. newcls do.
  jniCheck DeleteLocalRef_jni_ <cls
end.
EMPTY
)

jniCallField=: 4 : 0
'field sig'=. <;._1 ' ', deb x
'attr obj cls'=. 3{.y
static=. {.attr
y=. 3}.y

assert. 1=+/'#'=sig [ 'jniCallField'
rt=. sig-.'#'
jniCheck mid=. >@{. GetFieldID`GetStaticFieldID@.static cls;field;({.a.),~ rt
if. static do. obj=. cls end.
if. 0=#y do.
  if. '[' e. rt do.
    jniCheck rc=. >@{. ('x x x x ') ((static{ID_GetObjectField,ID_GetStaticObjectField) jniVararg) (obj ; mid)
  else.
    select. {.rt
    case. 'V' do. jniCheck rc=. >@{. ('x x x x ') ((static{ID_GetVoidField,ID_GetStaticVoidField) jniVararg) (obj ; mid)
    case. 'L' do. jniCheck rc=. >@{. ('x x x x ') ((static{ID_GetObjectField,ID_GetStaticObjectField) jniVararg) (obj ; mid)
    case. 'B' do. jniCheck rc=. >@{. ('c x x x ') ((static{ID_GetByteField,ID_GetStaticByteField) jniVararg) (obj ; mid)
    case. 'Z' do. jniCheck rc=. >@{. ('i x x x ') ((static{ID_GetBooleanField,ID_GetStaticBooleanField) jniVararg) (obj ; mid)
    case. 'I' do. jniCheck rc=. >@{. ('i x x x ') ((static{ID_GetIntField,ID_GetStaticIntField) jniVararg) (obj ; mid)
    case. 'J' do. jniCheck rc=. >@{. ('l x x x ') ((static{ID_GetLongField,ID_GetStaticLongField) jniVararg) (obj ; mid)
    case. 'S' do. jniCheck rc=. >@{. ('s x x x ') ((static{ID_GetShortField,ID_GetStaticShortField) jniVararg) (obj ; mid)
    case. 'F' do. jniCheck rc=. >@{. ('f x x x ') ((static{ID_GetFloatField,ID_GetStaticFloatField) jniVararg) (obj ; mid)
    case. 'D' do. jniCheck rc=. >@{. ('d x x x ') ((static{ID_GetDoubleField,ID_GetStaticDoubleField) jniVararg) (obj ; mid)
    case. 'C' do. jniCheck rc=. >@{. ('w x x x ') ((static{ID_GetCharField,ID_GetStaticCharField) jniVararg) (obj ; mid)
    case. do. assert. 0 [ 'jniCallField return type'
    end.
  end.
else.
  if. '[' e. rt do.
    jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_SetObjectField,ID_SetStaticObjectField) jniVararg) (obj ; mid), sig jniSigarg y
  else.
    select. {.rt
    case. 'V' do. jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_SetVoidField,ID_SetStaticVoidField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'L' do. jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_SetObjectField,ID_SetStaticObjectField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'B' do. jniCheck rc=. >@{. ('c x x x ', jniSigx15 sig) ((static{ID_SetByteField,ID_SetStaticByteField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'Z' do. jniCheck rc=. >@{. ('i x x x ', jniSigx15 sig) ((static{ID_SetBooleanField,ID_SetStaticBooleanField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'I' do. jniCheck rc=. >@{. ('i x x x ', jniSigx15 sig) ((static{ID_SetIntField,ID_SetStaticIntField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'J' do. jniCheck rc=. >@{. ('l x x x ', jniSigx15 sig) ((static{ID_SetLongField,ID_SetStaticLongField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'S' do. jniCheck rc=. >@{. ('s x x x ', jniSigx15 sig) ((static{ID_SetShortField,ID_SetStaticShortField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'F' do. jniCheck rc=. >@{. ('f x x x ', jniSigx15 sig) ((static{ID_SetFloatField,ID_SetStaticFloatField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'D' do. jniCheck rc=. >@{. ('d x x x ', jniSigx15 sig) ((static{ID_SetDoubleField,ID_SetStaticDoubleField) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'C' do. jniCheck rc=. >@{. ('w x x x ', jniSigx15 sig) ((static{ID_SetCharField,ID_SetStaticCharField) jniVararg) (obj ; mid), sig jniSigarg y
    case. do. assert. 0 [ 'jniCallField return type'
    end.
  end.
end.
rc
)

NB. =========================================================
NB. jniMethod
NB. m  'method signiture'
NB. x  parameter
NB. y  object
jniMethod=: 1 : 0
:
if. (0 4 -.@e.~ 3!:0 y) +. 0-:y do.
  smoutput 'method signiture: ',m
end.
assert. 0 4 e.~ 3!:0 y [ 'jniMethod'
assert. 0-.@-:y [ 'jniMethod'
jniCheck cls=. >@{. GetObjectClass_jni_ <y
assert. 0~:cls [ 'jniMethod'

'method proto'=. <;._1 ' ', deb m
proto=. jniSigniture proto
sig=. }. ({.~ i.&')') proto
rt=. }. (}.~ i.&')') proto
m=. method,' ',proto

rc=. m jniCall_jni_ (boxxopen x),~ 2 0 0;y;cls
jniCheck DeleteLocalRef_jni_ <cls
rc
)

NB. =========================================================
NB. jniStaticMethod
NB. m  'method signiture'
NB. x  parameter
NB. y  object|classname
jniStaticMethod=: 1 : 0
:
if. 1 4 e.~ 3!:0 y do.
  assert. 0-.@-:y [ 'jniStaticMethod'
  jniCheck cls=. >@{. GetObjectClass_jni_ <y
else.
  assert. ''-.@-:y [ 'jniStaticMethod'
  class=. './' charsub }.^:('L'={.) y -. ';'
  jniCheck cls=. >@{. FindClass_jni_ <class
end.
assert. 0~:cls [ 'jniStaticMethod'

'method proto'=. <;._1 ' ', deb m
proto=. jniSigniture proto
sig=. }. ({.~ i.&')') proto
rt=. }. (}.~ i.&')') proto
m=. method,' ',proto

rc=. m jniCall_jni_ (boxxopen x),~ 2 1 0;y;cls
jniCheck DeleteLocalRef_jni_ <cls
rc
)

NB. =========================================================
NB. jniCall
NB. x  'method signiture'
NB. y  attr;object;cls;parameter
jniCall=: 4 : 0
'method proto'=. <;._1 ' ', deb x
sig=. }. ({.~ i.&')') proto
rt=. '#'-.~ }. (}.~ i.&')') proto
'attr obj cls'=. 3{.y
'member static nonvirtual'=. attr
y=. 3}.y
if. -. (+/'#'=sig) = #y do. smoutput 'jniCall : ',x end.
assert. (+/'#'=sig) = #y [ 'jniCall incorrect number of arguments'

str=. stri=. 0$0
jniCheck mid=. >@{. GetMethodID`GetStaticMethodID@.static cls;method;({.a.),~ proto-.'#'
if. 1 e. s1=. ((<'Ljava/lang/CharSequence;') = sig1) +. (<'Ljava/lang/String;') = sig1=. <;._1 sig do.
  for_i. I. s1 do.
    if. 2 131072 262144 e.~ 3!:0 y1=. i{::y do.
      str=. str, < >@{. NewStringUTF < utf8@:(3&u:)@:ucp ,y1
      stri=. stri, i
    end.
  end.
  if. #stri do. y=. str stri}y end.
end.
if. '<init>'-:method do.
  jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) (ID_NewObject jniVararg) (cls ; mid), sig jniSigarg y
else.
  if. static do. obj=. cls end.
  if. '[' e. rt do.
    jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_CallObjectMethod,ID_CallStaticObjectMethod) jniVararg) (obj ; mid), sig jniSigarg y
  else.
    select. {.rt
    case. 'V' do. jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_CallVoidMethod,ID_CallStaticVoidMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'L' do. jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_CallObjectMethod,ID_CallStaticObjectMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'B' do. jniCheck rc=. >@{. ('c x x x ', jniSigx15 sig) ((static{ID_CallByteMethod,ID_CallStaticByteMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'Z' do. jniCheck rc=. >@{. ('i x x x ', jniSigx15 sig) ((static{ID_CallBooleanMethod,ID_CallStaticBooleanMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'I' do. jniCheck rc=. >@{. ('i x x x ', jniSigx15 sig) ((static{ID_CallIntMethod,ID_CallStaticIntMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'J' do. jniCheck rc=. >@{. ('x x x x ', jniSigx15 sig) ((static{ID_CallLongMethod,ID_CallStaticLongMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'S' do. jniCheck rc=. >@{. ('s x x x ', jniSigx15 sig) ((static{ID_CallShortMethod,ID_CallStaticShortMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'F' do. jniCheck rc=. >@{. ('f x x x ', jniSigx15 sig) ((static{ID_CallFloatMethod,ID_CallStaticFloatMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'D' do. jniCheck rc=. >@{. ('d x x x ', jniSigx15 sig) ((static{ID_CallDoubleMethod,ID_CallStaticDoubleMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. 'C' do. jniCheck rc=. >@{. ('w x x x ', jniSigx15 sig) ((static{ID_CallCharMethod,ID_CallStaticCharMethod) jniVararg) (obj ; mid), sig jniSigarg y
    case. do. assert. 0 [ 'jniCall return type'
    end.
  end.
end.
for_js. str do. DeleteLocalRef js end.
rc
)

NB. =========================================================
NB. jniNewObject
NB. x  parameter
NB. y  class signiture'
jniNewObject=: 4 : 0
if. ' ' e. y do.
  'class sig'=. <;._1 ' ', deb y
else.
  class=. y [ sig=. '()V'
end.
if. ')' -.@e. sig do. sig=. '(', ')V',~ sig end.
sig=. jniSigniture sig
class=. './' charsub class -. ';'
class=. 1&jniResolve 'L',class
jniCheck cls=. >@{. FindClass_jni_ <class
assert. 0~:cls [ 'jniNewObjet'
rc=. ('<init> ',sig) jniCall_jni_ (boxxopen x),~ 1 0 0;0;cls
jniCheck DeleteLocalRef <cls
rc
)

NB. =========================================================
NB. jniOverride new object from override class
NB. x  parameter
NB. y  class_signiture ; locale [; childid [; override]]
jniOverride=: 4 : 0
x=. boxxopen x
assert. 32=3!:0 y [ 'jniOverride: y must be box'
assert. 2 3 4 e.~ #y [ 'jniOverride: y must be class_signiture ; locale [; childid [; override]]'
if. 0=#x do.
  class=. >@{.y
  sig=. 'Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;'
else.
  'class sig'=. <;._1 ' ', >@{.y
  if. ')' e. sig do.
    sig=. '(' -.~ ({.~ i.&')') sig
  end.
  sig=. sig, 'Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;'
end.
if. ')' -.@e. sig do. sig=. '(',sig,')V' end.
class=. './' charsub }.^:('L'={.) class -. ';'

obj=. ((3{.}.y),~ x) jniNewObject class, ' ', sig
)

NB. =========================================================
NB.*jniProxy v create proxy object to implement interface
jniProxy=: 4 : 0
cls=. >@{. GetObjectClass <x
mid=. >@{. GetMethodID cls;'CreateProxy';'(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;'
s1=. >@{. NewStringUTF utf8@:(3&u:)@:ucp , {.y
s2=. >@{. NewStringUTF utf8@:(3&u:)@:ucp , {:y
s=. >@{. 'x x x x x x' (ID_CallObjectMethod jniVararg) x;mid;s1;s2
jniCheck DeleteLocalRef <s1
jniCheck DeleteLocalRef <s2
jniCheck DeleteLocalRef <cls
s
)
