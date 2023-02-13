NB. =========================================================
NB.*jnhandler v jn handler
NB. runs in form locale
NB. if debug is off, wraps event handler in try. catch.
NB. catch exits if error message is the last picked up by debug.
jnhandler_z_=: 4 : 0
if. 3=4!:0<'jnhandler_debug' do.
  try. x jnhandler_debug y catch. end.
  EMPTY return.
end.
jn_fn=. x
NB. if. 'Android'-:UNAME do. log_d_ja_ 'JJNI';'jnhandler ',jn_fn end.
if. 3~:(4!:0) <jn_fn do. EMPTY return. end.
if. 13!:17'' do.
  z=. jn_fn~ y
else.
  try. z=. jn_fn~ y
  catch.
    if. 0~:exc=. ExceptionOccurred_jni_'' do.
      if. ''-:jn_err=. jniException_jni_ exc do.
        jn_err=. 'JNI exception'
      end.
      jn_err=. '|', jn_err, LF
    else.
      jn_err=. 13!:12''
    end.
    if. 0=4!:0 <'ERM_j_' do.
      jn_erm=. ERM_j_
      ERM_j_=: ''
      if. jn_erm -: jn_err do. 0 return. end.
    end.
    jn_err=. LF,,LF,.}.;._2 jn_err
    smoutput 'jnhandler error in: ',jn_fn,jn_err
NB.     if. 'Android'-:UNAME do. log_d_ja_ 'JJNI';'jnhandler error in: ',,jn_fn,jn_err end.
    0
  end.
end.
)

