NB. =========================================================
NB. va_list will automatically promote short,char to integer, float to double
NB. if Call<type>Method etc cannot handle promotion of float, need to use Call<type>MethodV instead
va_list=: 3 : 0
(3!:0 &> y) va_list y
:
assert. (#x)=#y [ 'va_list_jni'
z=. ''
for_i. i.#x do.
  select. i{x
  case. 1 do. z=. z, (IF64{2 3)&ic i{::y
  case. 2 do. z=. z, i{::y
  case. 4 do. z=. z, (IF64{2 3)&ic i{::y
  case. 8 do. z=. z, 2&fc i{::y
  case. 16 do. z=. z, 2&fc +. i{::y
  case. do. assert. 0 [ 'va_list_jni'
  end.
end.
z
)

NB. =========================================================
NB. helper verb for variable argument
NB. m   vtable index
NB. x   signiture
NB. y   argument (first argument JNIENV is implied)
jniVararg=: 1 : 0
:
opt=. IFUNIX{::' + ';' '
((":1,m), opt, x)&(15!:0) (<JNIENV), y
)

NB. =========================================================
NB. helper verb for variable argument
NB. m   vtable index
NB. n   env
NB. x   signiture
NB. y   argument (first argument taken from n)
jniVarargs=: 2 : 0
:
opt=. IFUNIX{::' + ';' '
((":1,m), opt, x)&(15!:0) (<n), y
)

NB. =========================================================
NB. normalize signiture/classname, add # in signiture between every paramemter
jniSigniture=: 3 : 0
if. '#' e. y=. deb y do. y return. end.
if. '('={.y do.
  w1=. }. ({.~ i.&')') y
  w2=. }. (}.~ i.&')') y
  '(', (jniSigniture w1), ')', jniSigniture w2 return.
end.
z=. ''
i=. 0 [ ar=. 0
while. i<#y do.
  if. '[' = (tp=. i{y) do.
    i=. >:i [ ar=. 1 continue.
  else.
    if. tp e. 'BSIJFDZCV' do.
      z=. z, '#', (ar#'['), i{y
      i=. >:i [ ar=. 0
    else.
      assert. 'L'=tp [ 'jniSigniture'
      if. (#k) = j=. ';' i.~ k=. i}.y do.
        z=. z, '#', (ar#'['), (jniResolve k), ';' break.
      else.
        z=. z, '#', (ar#'['), (jniResolve j{.k), ';'
        i=. i + j + 1 [ ar=. 0
      end.
    end.
  end.
end.
z
)

NB. =========================================================
NB. x 1 coerce short,float to int,double
jniSigx15=: 1&$: : (4 : 0)
z=. ''
for_t. <;._1 y do.
  t1=. >t
  if. ar=. '['={.t1 do.
    t1=. }.t1
    if. (t2=. {.t1) e. 'BSIJFDZC' do.
NB.       z=. z, (ar#'*'), ('BSIJFDZC' i. t2){'csilfdic'
      z=. z, ' x'
    else.
      z=. z, ' x'
    end.
  else.
    if. (t2=. {.t1) e. 'BSIJFDZC' do.
      z=. z, ' ', ('BSIJFDZC' i. t2){ x{::'csilfdic';'ciilddic'
    else.
      z=. z, ' x'
    end.
  end.
end.
}.z
)

NB. =========================================================
jniSigarg=: 4 : 0
y=. boxxopen y
assert. (#y) = +/ '#'=x [ 'jniSigarg'
z=. 0$<''
for_t. <;._1 x do.
  a1=. t_index{::y
  t1=. >t
  if. ar=. '['={.t1 do.
    assert. 1 4 e.~ 3!:0 a1 [ 'jniSigarg array not object'
    z=. z, < a1
  else.
    a1=. {.a1
    if. (t2=. {.t1) e. 'BZ' do.
      if. 2=3!:0 a1 do.
        z=. z, < a.i.a1
      else.
        assert. 1 4 e.~ 3!:0 a1 [ 'jniSigarg'
        z=. z, < a1
      end.
    elseif. t2 e. 'C' do.
      assert. 2 131072 262144 e.~ 3!:0 a1 [ 'jniSigarg'
      z=. z, <{. uucp a1
    elseif. t2 e. 'SIJFD' do.
      assert. 1 4 8 e.~ 3!:0 a1 [ 'jniSigarg'
      z=. z, <a1
    elseif. t2 e. 'L' do.
      assert. 1 4 32 e.~ 3!:0 a1 [ 'jniSigarg'
      z=. z, <>a1
    elseif. do.
      assert. 0 [ 'jniSigarg'
    end.
  end.
end.
z
)
