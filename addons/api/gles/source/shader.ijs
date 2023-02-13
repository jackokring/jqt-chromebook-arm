NB. ----------------------------------------------------
gl_makeshader=: 4 : 0
y=. y,{.a.
shader=. >@{. glCreateShader x
glShaderSource shader; 1; (,15!:14 <'y'); <<0
glCompileShader shader
st=. >@{: glGetShaderiv shader; GL_COMPILE_STATUS; st=. ,_1
if. ({.st) = GL_FALSE do.
  err=. gl_infolog shader
  (err,LF,y);shader
else.
  '';shader
end.
)

NB. ----------------------------------------------------
NB. 6 types of shader supported in OpenGL 4.3
NB. VERTEX_SHADER
NB. TESS_CONTROL_SHADER
NB. TESS_EVALUATION_SHADER
NB. GEOMETRY_SHADER
NB. FRAGMENT_SHADER
NB. COMPUTE_SHADER

NB. order is vertex fragment geometry tess_control tess_eval computer
NB. only the first 3 shaders are supported in OpenGL 3.2

gl_makeprogram=: 3 : 0
'vsrc fsrc gsrc tcsrc tesrc csrc'=. 6{.boxopen y
if. 0= (*#vsrc)+.(*#fsrc) do. 'no shader source';0 return. end.
try.
  program=. >@{. glCreateProgram''
catch.
  0;~ 'glCreateProgram error',LF,(5!:6<'glCreateProgram'),LF,'cder : ',":cder'' return.
end.
if. #vsrc do.
  'err shader'=. GL_VERTEX_SHADER gl_makeshader vsrc
  if. #err do. err;0 [ glDeleteProgram program return. end.
  glAttachShader program ; shader
end.
if. #fsrc do.
  'err shader'=. GL_FRAGMENT_SHADER gl_makeshader fsrc
  if. #err do. err;0 [ glDeleteProgram program return. end.
  glAttachShader program ; shader
end.
if. #gsrc do.
  'err shader'=. GL_GEOMETRY_SHADER gl_makeshader gsrc
  if. #err do. err;0 [ glDeleteProgram program return. end.
  glAttachShader program ; shader
end.
if. #tcsrc do.
  'err shader'=. GL_TESS_CONTROL_SHADER gl_makeshader tcsrc
  if. #err do. err;0 [ glDeleteProgram program return. end.
  glAttachShader program ; shader
end.
if. #tesrc do.
  'err shader'=. GL_TESS_EVALUATION_SHADER gl_makeshader tesrc
  if. #err do. err;0 [ glDeleteProgram program return. end.
  glAttachShader program ; shader
end.
if. #csrc do.
  'err shader'=. GL_COMPUTE_SHADER gl_makeshader csrc
  if. #err do. err;0 [ glDeleteProgram program return. end.
  glAttachShader program ; shader
end.
glLinkProgram program
st=. >@{: glGetProgramiv program; GL_LINK_STATUS; st=. ,_1
if. ({.st) = GL_FALSE do.
  err=. gl_infolog program
  glDeleteProgram program
  err;program
else.
  '';program
end.
)

NB. ----------------------------------------------------
NB. Display compilation errors from the OpenGL shader compiler
gl_infolog=: 3 : 0
ln=. ,_1
if. >@{. glIsShader y do.
  ln=. >@{: glGetShaderiv y; GL_INFO_LOG_LENGTH; ln
elseif. >@{. glIsProgram y do.
  ln=. >@{: glGetProgramiv y; GL_INFO_LOG_LENGTH; ln
elseif. do.
  'Not a shader or a program' return.
end.

strInfoLog=. ({.ln)#' '
if. >@{. glIsShader y do.
  strInfoLog=. >@{: glGetShaderInfoLog y; ({.ln); (<0); strInfoLog
elseif. >@{. glIsProgram y do.
  strInfoLog=. >@{: glGetProgramInfoLog y; ({.ln); (<0); strInfoLog
end.
err=. strInfoLog
)

