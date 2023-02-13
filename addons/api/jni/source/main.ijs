NB. Return values from jobjectRefType
JNIInvalidRefType=: 0
JNILocalRefType=: 1
JNIGlobalRefType=: 2
JNIWeakGlobalRefType=: 3

NB. jboolean constants
JNI_FALSE=: 0
JNI_TRUE=: 1

NB. possible return values for JNI functions.
JNI_OK=: 0                NB. success
JNI_ERR=: _1              NB. unknown error
JNI_EDETACHED=: _2        NB. thread detached from the VM
JNI_EVERSION=: _3         NB. JNI version error
JNI_ENOMEM=: _4           NB. not enough memory
JNI_EEXIST=: _5           NB. VM already created
JNI_EINVAL=: _6           NB. invalid arguments

NB. used in ReleaseScalarArrayElements
JNI_COMMIT=: 1
JNI_ABORT=: 2

JNI_VERSION_1_1=: 16b00010001
JNI_VERSION_1_2=: 16b00010002
JNI_VERSION_1_4=: 16b00010004
JNI_VERSION_1_6=: 16b00010006

NB. JNI vtable
NB. signature start at column 31
JNI_FUNCTION=: <;._2 ] 0 : 0
NULL
NULL
NULL
NULL
GetVersion                    i x
DefineClass                   x x *c x *c i
FindClass                     x x *c
FromReflectedMethod           x x x
FromReflectedField            x x x
ToReflectedMethod             x x x x c
GetSuperclass                 x x x
IsAssignableFrom              c x x x
ToReflectedField              x x x x c
Throw                         i x x
ThrowNew                      i x x *c
ExceptionOccurred             x x
ExceptionDescribe             n x
ExceptionClear                n x
FatalError                    n x *c
PushLocalFrame                i x i
PopLocalFrame                 x x x
NewGlobalRef                  x x x
DeleteGlobalRef               n x x
DeleteLocalRef                n x x
IsSameObject                  c x x x
NewLocalRef                   x x x
EnsureLocalCapacity           i x i
AllocObject                   x x x
NewObject                     x x x x
NewObjectV                    x x x x x
NewObjectA                    x x x x *x
GetObjectClass                x x x
IsInstanceOf                  c x x x
GetMethodID                   x x x *c *c
CallObjectMethod              x x x x
CallObjectMethodV             x x x x x
CallObjectMethodA             x x x x *x
CallBooleanMethod             c x x x
CallBooleanMethodV            c x x x x
CallBooleanMethodA            c x x x *x
CallByteMethod                c x x x
CallByteMethodV               c x x x x
CallByteMethodA               c x x x *x
CallCharMethod                w x x x
CallCharMethodV               w x x x x
CallCharMethodA               w x x x *x
CallShortMethod               s x x x
CallShortMethodV              s x x x x
CallShortMethodA              s x x x *x
CallIntMethod                 i x x x
CallIntMethodV                i x x x x
CallIntMethodA                i x x x *x
CallLongMethod                l x x x
CallLongMethodV               l x x x x
CallLongMethodA               l x x x *x
CallFloatMethod               f x x x
CallFloatMethodV              f x x x x
CallFloatMethodA              f x x x *x
CallDoubleMethod              d x x x
CallDoubleMethodV             d x x x x
CallDoubleMethodA             d x x x *x
CallVoidMethod                n x x x
CallVoidMethodV               n x x x x
CallVoidMethodA               n x x x *x
CallNonvirtualObjectMethod    x x x x x
CallNonvirtualObjectMethodV   x x x x x x
CallNonvirtualObjectMethodA   x x x x x *x
CallNonvirtualBooleanMethod   c x x x x
CallNonvirtualBooleanMethodV  c x x x x x
CallNonvirtualBooleanMethodA  c x x x x *x
CallNonvirtualByteMethod      c x x x x
CallNonvirtualByteMethodV     c x x x x x
CallNonvirtualByteMethodA     c x x x x *x
CallNonvirtualCharMethod      w x x x x
CallNonvirtualCharMethodV     w x x x x x
CallNonvirtualCharMethodA     w x x x x *x
CallNonvirtualShortMethod     s x x x x
CallNonvirtualShortMethodV    s x x x x x
CallNonvirtualShortMethodA    s x x x x *x
CallNonvirtualIntMethod       i x x x x
CallNonvirtualIntMethodV      i x x x x x
CallNonvirtualIntMethodA      i x x x x *x
CallNonvirtualLongMethod      l x x x x
CallNonvirtualLongMethodV     l x x x x x
CallNonvirtualLongMethodA     l x x x x *x
CallNonvirtualFloatMethod     f x x x x
CallNonvirtualFloatMethodV    f x x x x x
CallNonvirtualFloatMethodA    f x x x x *x
CallNonvirtualDoubleMethod    d x x x x
CallNonvirtualDoubleMethodV   d x x x x x
CallNonvirtualDoubleMethodA   d x x x x *x
CallNonvirtualVoidMethod      n x x x x
CallNonvirtualVoidMethodV     n x x x x x
CallNonvirtualVoidMethodA     n x x x x *x
GetFieldID                    x x x *c *c
GetObjectField                x x x x
GetBooleanField               c x x x
GetByteField                  c x x x
GetCharField                  w x x x
GetShortField                 s x x x
GetIntField                   i x x x
GetLongField                  l x x x
GetFloatField                 f x x x
GetDoubleField                d x x x
SetObjectField                n x x x x
SetBooleanField               n x x x c
SetByteField                  n x x x c
SetCharField                  n x x x w
SetShortField                 n x x x s
SetIntField                   n x x x i
SetLongField                  n x x x l
SetFloatField                 n x x x f
SetDoubleField                n x x x d
GetStaticMethodID             x x x *c *c
CallStaticObjectMethod        x x x x
CallStaticObjectMethodV       x x x x x
CallStaticObjectMethodA       x x x x *x
CallStaticBooleanMethod       c x x x
CallStaticBooleanMethodV      c x x x x
CallStaticBooleanMethodA      c x x x *x
CallStaticByteMethod          c x x x
CallStaticByteMethodV         c x x x x
CallStaticByteMethodA         c x x x *x
CallStaticCharMethod          w x x x
CallStaticCharMethodV         w x x x x
CallStaticCharMethodA         w x x x *x
CallStaticShortMethod         s x x x
CallStaticShortMethodV        s x x x x
CallStaticShortMethodA        s x x x *x
CallStaticIntMethod           i x x x
CallStaticIntMethodV          i x x x x
CallStaticIntMethodA          i x x x *x
CallStaticLongMethod          l x x x
CallStaticLongMethodV         x x x x
CallStaticLongMethodA         l x x x *x
CallStaticFloatMethod         f x x x
CallStaticFloatMethodV        f x x x x
CallStaticFloatMethodA        f x x x *x
CallStaticDoubleMethod        d x x x
CallStaticDoubleMethodV       d x x x x
CallStaticDoubleMethodA       d x x x *x
CallStaticVoidMethod          n x x x
CallStaticVoidMethodV         n x x x x
CallStaticVoidMethodA         n x x x *x
GetStaticFieldID              x x x *c *c
GetStaticObjectField          x x x x
GetStaticBooleanField         c x x x
GetStaticByteField            c x x x
GetStaticCharField            w x x x
GetStaticShortField           s x x x
GetStaticIntField             i x x x
GetStaticLongField            l x x x
GetStaticFloatField           f x x x
GetStaticDoubleField          d x x x
SetStaticObjectField          n x x x x
SetStaticBooleanField         n x x x c
SetStaticByteField            n x x x c
SetStaticCharField            n x x x w
SetStaticShortField           n x x x s
SetStaticIntField             n x x x i
SetStaticLongField            n x x x l
SetStaticFloatField           n x x x f
SetStaticDoubleField          n x x x d
NewString                     x x *w i
GetStringLength               i x x
GetStringChars                x x x *c
ReleaseStringChars            n x x *w
NewStringUTF                  x x *c
GetStringUTFLength            i x x
GetStringUTFChars             x x x *c
ReleaseStringUTFChars         n x x *c
GetArrayLength                i x x
NewObjectArray                x x i x x
GetObjectArrayElement         x x x i
SetObjectArrayElement         n x x i x
NewBooleanArray               x x i
NewByteArray                  x x i
NewCharArray                  x x i
NewShortArray                 x x i
NewIntArray                   x x i
NewLongArray                  x x i
NewFloatArray                 x x i
NewDoubleArray                x x i
GetBooleanArrayElements       x x x *c
GetByteArrayElements          x x x *c
GetCharArrayElements          x x x *c
GetShortArrayElements         x x x *c
GetIntArrayElements           x x x *c
GetLongArrayElements          x x x *c
GetFloatArrayElements         x x x *c
GetDoubleArrayElements        x x x *c
ReleaseBooleanArrayElements   n x x *c i
ReleaseByteArrayElements      n x x *c i
ReleaseCharArrayElements      n x x *w i
ReleaseShortArrayElements     n x x *s i
ReleaseIntArrayElements       n x x *i i
ReleaseLongArrayElements      n x x *l i
ReleaseFloatArrayElements     n x x *f i
ReleaseDoubleArrayElements    n x x *d i
GetBooleanArrayRegion         n x x i i *c
GetByteArrayRegion            n x x i i *c
GetCharArrayRegion            n x x i i *w
GetShortArrayRegion           n x x i i *s
GetIntArrayRegion             n x x i i *i
GetLongArrayRegion            n x x i i *l
GetFloatArrayRegion           n x x i i *f
GetDoubleArrayRegion          n x x i i *d
SetBooleanArrayRegion         n x x i i *c
SetByteArrayRegion            n x x i i *c
SetCharArrayRegion            n x x i i *w
SetShortArrayRegion           n x x i i *s
SetIntArrayRegion             n x x i i *i
SetLongArrayRegion            n x x i i *l
SetFloatArrayRegion           n x x i i *f
SetDoubleArrayRegion          n x x i i *d
RegisterNatives               i x x x i
UnregisterNatives             i x x
MonitorEnter                  i x x
MonitorExit                   i x x
GetJavaVM                     i x *x
GetStringRegion               n x x i i *w
GetStringUTFRegion            n x x i i *c
GetPrimitiveArrayCritical     x x x *c
ReleasePrimitiveArrayCritical n x x x i
GetStringCritical             x x x *c
ReleaseStringCritical         n x x *w
NewWeakGlobalRef              x x x
DeleteWeakGlobalRef           n x x
ExceptionCheck                c x
NewDirectByteBuffer           x x x l
GetDirectBufferAddress        x x x
GetDirectBufferCapacity       l x x
GetObjectRefType              x x x
)

3 : 0''
(('ID_'&,)@:(-.&' ')@:(30&{.)&.> JNI_FUNCTION)=: i.#JNI_FUNCTION
func=: (-.&' ')@:(30&{.)&.> JNI_FUNCTION
func_sig=: dtb@:(30&}.)&.> JNI_FUNCTION
opt=. IFUNIX{::' + ';' '
NB. first 4 lines are NULL
". 4}. (>func),"1 ('=: 3 : (''''''1 ',"1 (":,.i.#JNI_FUNCTION),"1 opt,"1 (>func_sig),"1 '''''&(15!:0) (<JNIENV), y''',"1 ';'':'';',"1 '''''''1 ',"1 (":,.i.#JNI_FUNCTION),"1 opt,"1 (>func_sig),"1 '''''&(15!:0) (<x), y'')')
EMPTY
)

NB. JNI VM vtable
NB. signature start at column 31
JNIVM_FUNCTION=: <;._2 ] 0 : 0
NULL
NULL
NULL
DestroyJavaVM                 i x
AttachCurrentThread           i x *x x
DetachCurrentThread           i x
GetEnv                        i x *x i
AttachCurrentThreadAsDaemon   i x *x x
)

3 : 0''
(('ID_'&,)@:(-.&' ')@:(30&{.)&.> JNIVM_FUNCTION)=: i.#JNIVM_FUNCTION
func2=: (-.&' ')@:(30&{.)&.> JNIVM_FUNCTION
func2_sig=: dtb@:(30&}.)&.> JNIVM_FUNCTION
opt=. IFUNIX{::' + ';' '
NB. first 3 lines are NULL
". 3}. (>func2),"1 ('=: 3 : (''''''1 ',"1 (":,.i.#JNIVM_FUNCTION),"1 opt,"1 (>func2_sig),"1 '''''&(15!:0) (<JNIVM), y''',"1 ';'':'';',"1 '''''''1 ',"1 (":,.i.#JNIVM_FUNCTION),"1 opt,"1 (>func2_sig),"1 '''''&(15!:0) (<x), y'')')
EMPTY
)

