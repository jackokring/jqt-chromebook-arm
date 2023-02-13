NB. x intent,activity,context (locale,japparg,override will be ignored if 0~:intent)
NB. y locale;override;japparg
StartActivity=: 0&$: : (4 : 0)
'intent act ctx'=. 3{.x
'locale override japparg'=. 3{. boxopen y
locale=. >^:_ locale
assert. (0~:intent) +. *#locale
if. IFQT do.
  app=. ('"',libjqt,'" GetClassID > x i')&cd 0
else.
  app=. ('theApp LJConsoleApp;' jniStaticField) 'JConsoleApp'
end.
assert. 0~:app
if. 0= act do.
  if. IFQT do.
    cact=. ('"',libjqt,'" getqtactivity > x')&cd ''
  else.
    jniCheck cact=. ('activity LAbstractActivity;' jniField) app
  end.
else.
  cact=. act
end.
if. 0=ctx do. cctx=. app ('getApplicationContext ()LContext;' jniMethod)~ '' else. cctx=. ctx end.
if. 0=intent do.
  cintent=. 'android.content.Intent' jniNewObject~ ''
  if. IFQT do.
    jniCheck jnact=. >@{. FindClass <'com/jsoftware/jn/android/app/Activity'
  else.
    jniCheck jnact=. >@{. FindClass <'com/jsoftware/jn/android/app/Activity'
  end.
  cintent ('setClass (LContext;LClass;)LIntent;' jniMethod)~ cctx;jnact
  cintent ('putExtra (LString;LString;)LIntent;' jniMethod)~ 'locale';locale
  cintent ('putExtra (LString;LString;)LIntent;' jniMethod)~ 'override';override
  cintent ('putExtra (LString;LString;)LIntent;' jniMethod)~ 'japparg';japparg
  cact ('startActivity (LIntent;)V' jniMethod)~ cintent
  jniCheck DeleteLocalRef"0 cintent;jnact
else.
  cact ('startActivity (LIntent;)V' jniMethod)~ intent
end.
if. 0=act do. jniCheck DeleteLocalRef <cact end.
if. 0=ctx do. jniCheck DeleteLocalRef <cctx end.
jniCheck DeleteLocalRef <app
0
)

NB. y action uri mime flag
StartActivityImplicit=: 3 : 0
'action uri mime flag'=. 4{. boxopen y
flag=. <. {.flag,0
app=. cact=. cintent=. curi=. 0
try.
  if. IFQT do.
    app=. ('"',libjqt,'" GetClassID > x i')&cd 0
  else.
    jniCheck app=. ('theApp LJConsoleApp;' jniStaticField) 'JConsoleApp'
  end.
  assert. 0~:app
  if. IFQT do.
    cact=. ('"',libjqt,'" getqtactivity > x')&cd ''
  else.
    jniCheck cact=. ('activity LAbstractActivity;' jniField) app
  end.
  jniCheck cintent=. 'android.content.Intent LString;' jniNewObject~ <action
  if. #uri do.
    jniCheck curi=. 'android.net.Uri' ('parse (LString;)LUri;' jniStaticMethod)~ <uri
    if. #mime do.
      jniCheck cintent ('setDataAndType (LUri;LString;)LIntent;' jniMethod)~ curi;mime
    else.
      jniCheck cintent ('setData (LUri;)LIntent;' jniMethod)~ <curi
    end.
  else.
    jniCheck cintent ('setType (LString;)LIntent;' jniMethod)~ <mime
  end.
  if. flag do.
    jniCheck cintent ('setFlags (I)LIntent;' jniMethod)~ <flag
  end.
  jniCheck cact ('startActivity (LIntent;)V' jniMethod)~ cintent
catch.
  if. 0~:exc=. ExceptionOccurred'' do.
    if. ''-:err=. jniException exc do.
      err=. 'JNI exception'
    end.
  else.
    err=. 13!:12''
  end.
  err 13!:8[3
end.
if. curi do. jniCheck DeleteLocalRef <curi end.
if. cintent do. jniCheck DeleteLocalRef <cintent end.
if. cact do. jniCheck DeleteLocalRef <cact end.
if. app do. jniCheck DeleteLocalRef <app end.
0
)
