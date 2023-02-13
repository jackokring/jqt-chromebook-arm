NB. util

NB. return jconsole activity if 0=y else y
getjactivity=: 3 : 0
if. 0=y do.
  try.
    if. IFQT do.
      if. app=. ('"',libjqt,'" GetClassID > x i')&cd 0 do.
        act=. ('"',libjqt,'" getqtactivity > x')&cd ''
        jniCheck DeleteLocalRef <app
        act
      else.
        0
      end.
    else.
      jniCheck app=. ('theApp LJConsoleApp;' jniStaticField) 'JConsoleApp'
      jniCheck act=. ('activity Lcom/jsoftware/j/android/AbstractActivity;' jniField) app
      jniCheck DeleteLocalRef <app
      act
    end.
  catch.
    if. 0~:exc=. ExceptionOccurred_jni_'' do.
      smoutput jniException_jni_ exc
    end.
    ExceptionClear_jni_''
    0
  end.
else.
  y
end.
)

NB. y activity
NB. return rotation, density, densityDpi, heightPixels, scaledDensity, widthPixels, xdpi, ydpi
NB. rotation: 0=portrait, 1=landscape.  width and height varies with rotation
NB. xdpi and ydpi are un-reliable
getdisplaymetrics=: 3 : 0
act=. getjactivity y
assert. 0~:act
jniCheck wm=. act ('getWindowManager ()LWindowManager;' jniMethod)~ ''
jniCheck ds=. wm ('getDefaultDisplay ()LDisplay;' jniMethod)~ ''
jniCheck dm=. '' jniNewObject 'DisplayMetrics'
jniCheck ds ('getMetrics (LDisplayMetrics;)V' jniMethod)~ dm
jniCheck density=. ('density F' jniField) dm
jniCheck densityDpi=. ('densityDpi I' jniField) dm
jniCheck heightPixels=. ('heightPixels I' jniField) dm
jniCheck scaledDensity=. ('scaledDensity F' jniField) dm
jniCheck widthPixels=. ('widthPixels I' jniField) dm
jniCheck xdpi=. ('xdpi F' jniField) dm
jniCheck ydpi=. ('ydpi F' jniField) dm
if. (xdpi>.ydpi)<densityDpi%2 do. xdpi=. ydpi=. densityDpi end.
if. APILEVEL_ja_ < 8 do.
  jniCheck rotation=. ds ('getOrientation ()I' jniMethod)~ ''
else.
  jniCheck rotation=. ds ('getRotation ()I' jniMethod)~ ''
end.
if. 0=y do.
  jniCheck DeleteLocalRef"0 act;wm;ds;dm
else.
  jniCheck DeleteLocalRef"0 wm;ds;dm
end.
rotation, density, densityDpi, heightPixels, scaledDensity, widthPixels, xdpi, ydpi
)

3 : 0''
if. (0~:JNIENV) *. ('Android'-:UNAME) do.
  'DM_density DM_densityDpi DM_scaledDensity'=: 1 2 4{ getdisplaymetrics 0

NB.   (Looper.getMainLooper().getThread() == Thread.currentThread())
  MAIN_THREAD=: 0
  l=. 'android.os.Looper' ('getMainLooper ()Landroid/os/Looper;' jniStaticMethod)~ ''
  t0=. l ('getThread ()Ljava/lang/Thread;' jniMethod)~ ''
  t1=. 'java.lang.Thread' ('currentThread ()Ljava/lang/Thread;' jniStaticMethod)~ ''
  jniCheck MAIN_THREAD=: a.i. >@{. IsSameObject t0;t1
  jniCheck DeleteLocalRef"0 l;t0;t1
end.
EMPTY
)

logcat=: empty @: (('libj.so logcat ',(IFWIN#'+'),' n *c') cd <@,)
