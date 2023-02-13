coclass'jni'

NB. JNIENV_z_ JNIVM_z_ will be defined by users

GetJNIENV=: 3 : 0
if. 'Android'-:UNAME do.
  try.
    'JNIVM_z_ JNIENV_z_'=: ; }. 'libj.so GetJavaVM i *x *x'&cd (,_1);,_1
    JNIENV_z_
  catch.
    0 return.
  end.
else.
  0
end.
)
