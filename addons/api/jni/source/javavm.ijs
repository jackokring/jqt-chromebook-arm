NB. create new java vm
NB. only works when there are no previous instances of java vm in the process
NB. environment variables LIBJVM_APTH   file path of libjvm.so
NB.                       JAVALD_APTH   file path of native_threads/libhpi.so

NB. eg. debian 64-bit
NB. for libjvm.so
NB. exprot LIBJVM_PATH=/usr/lib/jvm/java-6-sun-1.6.0.26/jre/lib/amd64/server
NB. for native_threads/libhpi.so
NB. exprot JAVALD_PATH=/usr/lib/jvm/java-6-sun-1.6.0.26/jre/lib/amd64


NB. typedef struct JavaVMOption { 32/64 offset  size  total
NB.     char *optionString;              0    : 4/8
NB.     void *extraInfo;                 4/8  : 4/8
NB. } JavaVMOption;                                   8/16
NB.
NB. typedef struct JavaVMInitArgs {
NB.     jint version;                    0    : 4
NB.
NB.     jint nOptions;                   4    : 4
NB.     JavaVMOption *options;           8    : 4/8
NB.     jboolean ignoreUnrecognized;     12/16: 1
NB. } JavaVMInitArgs;                                 16/24
NB.
NB. typedef struct JavaVMAttachArgs {
NB.     jint version;                    0    : 4
NB.
NB.     char *name;                      4/8  : 4/8
NB.     jobject group;                   8/16 : 4/8
NB. } JavaVMAttachArgs;                               12/24

NB. jint JNI_GetDefaultJavaVMInitArgs(void *args);
NB. jint JNI_CreateJavaVM(JavaVM **pvm, void **penv, void *args);
NB. jint JNI_GetCreatedJavaVMs(JavaVM **, jsize, jsize *);
NB. jint JNI_OnLoad(JavaVM *vm, void *reserved);
NB. void JNI_OnUnload(JavaVM *vm, void *reserved);

3 : 0''
if. 0 -: jvm=. 2!:5 'LIBJVM_PATH' do. jvm=. '' end.
if. #jvm do. jvm=. jvm, (-.({:jvm)e.'/\')#'/' end.
if. 0 -: jlib=. 2!:5 'JAVALD_PATH' do. jlib=. '' end.
if. #jlib do.
  if. IFUNIX do.
    ((unxlib 'c'),' setenv > i *c *c i')&(15!:0) (('Darwin'-:UNAME){::'LD_LIBRARY_PATH';'DYLD_LIBRARY_PATH');jlib;1
  else.
    'kernel32 SetDllDirectoryW > x *w'cd <uucp jlib
  end.
end.
libjvm=. jvm, (('Darwin'-:UNAME) + IFUNIX){::'jvm.dll';'libjvm.so';'libjvm.dylib'
opt=. IFUNIX{::' + ';' '
JNI_GetDefaultJavaVMInitArgs=: ('"', libjvm, '" JNI_GetDefaultJavaVMInitArgs', opt, 'i x')&(15!:0)
JNI_CreateJavaVM=: ('"', libjvm, '" JNI_CreateJavaVM', opt, 'i *x *x x')&(15!:0)
JNI_GetCreatedJavaVMs=: ('"', libjvm, '" JNI_GetCreatedJavaVMs', opt, 'i *x i *i')&(15!:0)
JNI_OnLoad=: ('"', libjvm, '" JNI_OnLoad', opt, 'i x x')&(15!:0)
JNI_OnUnload=: ('"', libjvm, '" JNI_OnUnload', opt, 'n x x')&(15!:0)
EMPTY
)

NB. helper verb for JNI_CreateJavaVM
NB. y:  (minor version 1,2,4 or 6) ; (boxed array of string args)
NB. retrun vm,env (0 0 if failed)
CreateJavaVM=: 3 : 0
if. 0= #y=. boxxopen y do.
  args=. '' [ version=. 4
else.
  version=. >{.y [ args=. }.y
end.
assert. version e. 1 2 4 6
noptions=. #args
version=. ". 'JNI_VERSION_1_', ":version
SZI=. IF64{4 8
initargs=. mema IF64{16 24
NB. JNI_GetDefaultJavaVMInitArgs initargs
if. noptions do.
  options=. mema noptions * IF64{8 16
  pargs=. 15!:14 <'args'
  for_p. memr pargs,0,noptions,4 do.
    (p+memr p,0 1 4) memw (options + p_index*IF64{8 16),0 1 4
  end.
end.
(2 ic version) memw initargs,0 4 2
(2 ic noptions) memw initargs,4 4 2
if. noptions do. options memw initargs,8 1 4 end.
(0{a.) memw initargs,(IF64{12 16),1,2
vm=. ,2-2
env=. ,2-2
'rc vm env'=. 3{. JNI_CreateJavaVM vm;env;initargs
if. noptions do. memf options end.
memf initargs
(0>rc){::(vm,env);0 0
)
