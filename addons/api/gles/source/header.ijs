NB.------------------------------------------------------
NB. build api.ijs

api=: 3 : 0
z=. ''
for_lx. <;._2 fread jpath 'api.txt' do.
  s=. <;._2 '(,),' charsub ';'-.~ >lx
  fn=. 0{::s
  fn=. deb (1 j.('*'=fn))#fn
  rt=. ({.~ i:&' ') fn
  fn=. }. (}.~ i:&' ') fn
  pm=. }.s
  rtt=. 1&typeof rt
  pmt=. 0&typeof&.> pm
  b=. fn,' >',rtt,;pmt
  b=. (' : ' , >lx),~ (50>.$b){.b
  z=. z, b, LF
end.
z fwrite jpath 'api-output.txt'
)

typeof=: 4 : 0
y=. deb y
if. (<y) e. typevoid do. x{::'';' n' return. end.
star=. +/ y e. '*'
t1=. <deb ('const ';'';'signed ';'';'unsigned ';'') stringreplace y-.'*'
if. 'struct '-:7{.>t1 do. z=. 'x' [ star=. <:star
elseif. t1 e. typevoid do. z=. 'x' [ star=. <:star
elseif. t1 e. type1 do. z=. '\1'
elseif. t1 e. typec do. z=. 'c'
elseif. t1 e. types do. z=. 's'
elseif. t1 e. typei do. z=. 'i'
elseif. t1 e. typex do. z=. 'x'
elseif. t1 e. typel do. z=. 'l'
elseif. t1 e. typef do. z=. 'f'
elseif. t1 e. typed do. z=. 'd'
elseif. do.
  smoutput 'typeof ',y
  assert. 0 [ 'type error'
end.
if. star<0 do.
  smoutput 'typeof ',y
  assert. star>:0 [ 'cannot handle'
end.
if. 0=star do. ' ',z return.
elseif. x do. ' x' return.
elseif. 1=star do. ' *',z return.
elseif. do. ' *x' return.
end.
)

type1=: <;._1 ' GLhandleARB'
typevoid=: <;._1 ' void GLvoid'
typec=: <;._1 ' GLchar GLbyte GLubyte GLcharARB'
types=: <;._1 ' GLshort GLushort GLboolean GLhalfNV'
typei=: <;._1 ' GLenum GLint GLuint GLbitfield GLsizei GLfixed'
typex=: <;._1 ' GLsync GLintptr GLsizeiptr GLsizeiptrARB GLintptrARB GLvdpauSurfaceNV GLeglImageOES GLDEBUGPROC GLDEBUGPROCARB GLDEBUGPROCAMD'
typel=: <;._1 ' GLint64 GLuint64 GLint64EXT GLuint64EXT'
typef=: <;._1 ' GLfloat GLclampf'
typed=: <;._1 ' GLdouble GLclampd'

NB.------------------------------------------------------
NB. build noun.ijs
const=: 3 : 0
z=. ''
for_lx. <;._2 fread jpath 'noun.txt' do.
  s=. <;._2 ' ',~ >lx
  if. 2~:#s do.
    smoutput lx
    assert. 'const format error'
  end.
  'a b'=. s
  if. (2{.b)-:'0x' do.
    b=. '16b', 'ul'-.~ tolower 2}.b
  end.
  z=. z, a,'=: ',b,LF
end.
z fwrite jpath 'noun-output.txt'
)
