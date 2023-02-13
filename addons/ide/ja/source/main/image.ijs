NB. image

NB. Format              Description               JAndroid's support
NB. JPG    Joint Photographic Experts Group       Read/write
NB. JPEG   Joint Photographic Experts Group       Read/write
NB. PNG    Portable Network Graphics              Read/write

NB. =========================================================
NB. reading file images from memory to argb matrix
NB. y raw image data
getimg=: 3 : 0
wdgetimg_jni_ y
)

NB. =========================================================
NB. reading file images to argb matrix
NB. y image file name
readimg=: 3 : 0
wdreadimg_jni_ (utf8 ,y)
)

NB. =========================================================
NB. write image data to memory
NB. x rgb matrix
NB. y 'jpeg|png' [ ; '[0,100]|_1' ]
putimg=: 4 : 0
if3=. (3=#$x) *. 3={:$x
if. if3 do.
  x=. setalpha 256&#. x
end.
'h w'=. $x
d=. ,x
type=. 'jpeg'
opt=. ''
quality=. _1
if. 1= #y=. boxxopen y do.
  type=. >@{.y
elseif. 2< #y do.
  type=. >@{.y
  opt=. 2{.}.y
end.
if. 'jpg'-:type do. type=. 'jpeg'
end.
type=. toupper type
if. #opt do. quality=. <. >@{:opt end.
if. (_1=quality) *. ('JPEG'-:type) do. quality=. 75 end.
if. (_1=quality) *. ('PNG'-:type) do. quality=. 100 end.
d=. fliprgb^:(-.RGBSEQ_j_) d
r=. wdputimg_jni_ d; w; h; type; quality
)

NB. =========================================================
NB. write image data to file
NB. x rgb matrix
NB. y filename [ ; 'jpeg|png' [ ; [0,100]|_1 ]]
writeimg=: 4 : 0
if3=. (3=#$x) *. 3={:$x
if. if3 do.
  x=. setalpha 256&#. x
end.
'h w'=. $x
d=. ,x
y=. boxopen y
f=. > fboxname {. y
type=. 'jpeg'
opt=. ''
quality=. _1
if. 1= #y do.
  type=. }. (}.~ i:&'.') f
else.
  type=. >1{y
  opt=. 2{.2}.y
end.
type=. tolower type
if. 'jpg'-:type do. type=. 'jpeg'
end.
type=. toupper type
if. #opt do. quality=. <. >@{:opt end.
if. (_1=quality) *. ('JPEG'-:type) do. quality=. 75 end.
if. (_1=quality) *. ('PNG'-:type) do. quality=. 100 end.
d=. fliprgb^:(-.RGBSEQ_j_) d
r=. wdwriteimg_jni_ d; w; h; f; type; quality
EMPTY
)

wdreadimg_jni_=: 3 : 0
try.
  buffer=. ''
  jniCheck app=. ('theApp Lcom/jsoftware/j/android/JConsoleApp;' jniStaticField) 'com/jsoftware/j/android/JConsoleApp'
  jniCheck cls=. >@{. FindClass <'java/lang/Object'
  jniCheck arr=. >@{. NewObjectArray 3; cls; 0
  jniCheck SetObjectArrayElement arr; 0; 0
  jniCheck SetObjectArrayElement arr; 1; 0
  jniCheck SetObjectArrayElement arr; 2; 0
  jniCheck rc=. app ('wdreadimg (Ljava/lang/String;[Ljava/lang/Object;)I' jniMethod)~ y;arr
  if. rc=0 do.
    jniCheck array=. >@{. GetObjectArrayElement arr; 0
    jniCheck len=. >@{. GetArrayLength <array
    jniCheck buffer=. >@{: GetIntArrayRegion array; 0; len; buffer=. len#2-2
    jniCheck width=. >@{. GetObjectArrayElement arr; 1
    jniCheck w=. width ('intValue ()I' jniMethod)~ ''
    jniCheck height=. >@{. GetObjectArrayElement arr; 2
    jniCheck h=. height ('intValue ()I' jniMethod)~ ''
    jniCheck DeleteLocalRef"0 app;cls;arr;array;width;height
  else.
    jniCheck DeleteLocalRef"0 app;cls;arr
  end.
catch.
  rc=. _3
  if. 0~:exc=. ExceptionOccurred'' do.
    if. ''-:err=. jniException exc do.
      err=. 'JNI exception'
    end.
  else.
    err=. 13!:12''
  end.
end.
res=. 0 0$2-2
select. rc
case. 0 do.
  res=. (h,w)$ fliprgb^:(-.RGBSEQ_j_) buffer
case. _3 do.
  smoutput 'JNI error: ', err
  err (13!:8) 3
case. do.
  'wdreadimg error' (13!:8) 3
end.
res
)

wdgetimg_jni_=: 3 : 0
try.
  buffer=. ''
  jniCheck app=. ('theApp Lcom/jsoftware/j/android/JConsoleApp;' jniStaticField) 'com/jsoftware/j/android/JConsoleApp'
  jniCheck cls=. >@{. FindClass <'java/lang/Object'
  jniCheck arr=. >@{. NewObjectArray 3; cls; 0
  jniCheck SetObjectArrayElement arr; 0; 0
  jniCheck SetObjectArrayElement arr; 1; 0
  jniCheck SetObjectArrayElement arr; 2; 0
  jniCheck iarr=. >@{. NewByteArray <#y
  jniCheck SetByteArrayRegion iarr; 0; (#y); ,y
  jniCheck rc=. app ('wdgetimg ([B[Ljava/lang/Object;)I' jniMethod)~ iarr;arr
  if. rc=0 do.
    jniCheck array=. >@{. GetObjectArrayElement arr; 0
    jniCheck len=. >@{. GetArrayLength <array
    jniCheck buffer=. >@{: GetIntArrayRegion array; 0; len; buffer=. len#2-2
    jniCheck width=. >@{. GetObjectArrayElement arr; 1
    jniCheck w=. width ('intValue ()I' jniMethod)~ ''
    jniCheck height=. >@{. GetObjectArrayElement arr; 2
    jniCheck h=. height ('intValue ()I' jniMethod)~ ''
    jniCheck DeleteLocalRef"0 app;cls;arr;iarr;array;width;height
  else.
    jniCheck DeleteLocalRef"0 app;cls;arr;iarr
  end.
catch.
  rc=. _3
  if. 0~:exc=. ExceptionOccurred'' do.
    if. ''-:err=. jniException exc do.
      err=. 'JNI exception'
    end.
  else.
    err=. 13!:12''
  end.
end.
res=. 0 0$2-2
select. rc
case. 0 do.
  res=. (h,w)$ fliprgb^:(-.RGBSEQ_j_) buffer
case. _3 do.
  smoutput 'JNI error: ', err
  err (13!:8) 3
case. do.
  'wdgetimg error' (13!:8) 3
end.
res
)

wdwriteimg_jni_=: 3 : 0
'data w h f type quality'=. y
try.
  jniCheck app=. ('theApp Lcom/jsoftware/j/android/JConsoleApp;' jniStaticField) 'com/jsoftware/j/android/JConsoleApp'
  jniCheck iarr=. >@{. NewIntArray <#data
  jniCheck SetIntArrayRegion iarr; 0; (#data); data
  jniCheck rc=. app ('wdwriteimg ([IIILjava/lang/String;Ljava/lang/String;I)I' jniMethod)~ iarr;w;h;f;type;quality
  jniCheck DeleteLocalRef"0 app;iarr
catch.
  rc=. _3
  if. 0~:exc=. ExceptionOccurred'' do.
    if. ''-:err=. jniException exc do.
      err=. 'JNI exception'
    end.
  else.
    err=. 13!:12''
  end.
end.
select. rc
case. 0 do.
case. _3 do.
  smoutput 'JNI error: ', err
  err (13!:8) 3
case. do.
NB.  'wdwriteimg error' (13!:8) 3
end.
rc
)

wdputimg_jni_=: 3 : 0
'data w h type quality'=. y
try.
  buffer=. ''
  jniCheck app=. ('theApp Lcom/jsoftware/j/android/JConsoleApp;' jniStaticField) 'com/jsoftware/j/android/JConsoleApp'
  jniCheck cls=. >@{. FindClass <'java/lang/Object'
  jniCheck arr=. >@{. NewObjectArray 1; cls; 0
  jniCheck SetObjectArrayElement arr; 0; 0
  jniCheck iarr=. >@{. NewIntArray <#data
  jniCheck SetIntArrayRegion iarr; 0; (#data); data
  jniCheck rc=. app ('wdputimg ([IIILjava/lang/String;I[Ljava/lang/Object;)I' jniMethod)~ iarr;w;h;type;quality;arr
  if. rc=0 do.
    jniCheck array=. >@{. GetObjectArrayElement arr; 0
    jniCheck len=. >@{. GetArrayLength <array
    jniCheck buffer=. >@{: GetByteArrayRegion array; 0; len; buffer=. len#{.a.
    jniCheck DeleteLocalRef"0 app;cls;iarr;arr;array
  else.
    jniCheck DeleteLocalRef"0 app;cls;iarr;arr
  end.
catch.
  rc=. _3
  if. 0~:exc=. ExceptionOccurred'' do.
    if. ''-:err=. jniException exc do.
      err=. 'JNI exception'
    end.
  else.
    err=. 13!:12''
  end.
end.
select. rc
case. 0 do.
case. _3 do.
  smoutput 'JNI error: ', err
  err (13!:8) 3
case. do.
NB.  'wdputimg error' (13!:8) 3
end.
buffer
)
