NB. gnuplot utils

deb=: #~ (+. 1: |. (> </\))@(' '&~:)
fexist=: 1:@(1!:4)@boxopen ::0:
fslash=: 3 : '''/'' (I. y=''\'') } y'
isboxed=: 0: < L.
itemize=: ,:^:(2: > #@$)

NB. =========================================================
cutstring=: ','&$: : (4 : 0)
if. 0 = #y do. '' return. end.
if. L. y do. y return. end.
txt=. y, {.x
msk=. txt = ''''
com=. (txt e. x) > ~: /\ msk
msk=. (msk *. ~:/\msk) < msk <: 1 |. msk
deb each (msk # com) <;._2 msk # txt
)

NB. =========================================================
getbinfiles=: 3 : 0
res=. '';''
if. 0 ~: 4!:0 <'GNUPLOTBIN' do. return. end.
if. 0 = #GNUPLOTBIN do. return. end.
bin=. jhostpath GNUPLOTBIN
bin=. bin, PATHSEP_j_ -. {: bin
exe=. bin,'wgnuplot.exe'
ini=. bin,'gnuplot.ini'
exe=. (fexist exe) # exe
ini=. (fexist ini) # ini
exe;ini
)

NB. =========================================================
gpflatten=: [: _2&}. [: ; ,&CRLF@, each @ < @ (,"1&CRLF @ ":)"2

NB. =========================================================
NB. getdata
NB.
NB. this function mimics the behaviour of J Plot
getdata=: 4 : 0
dat=. y
p3d=. 's' e. x

NB. ---------------------------------------------------------
if. p3d do.
  if. isboxed dat do.
    select. #dat
    case. 1 do.
      z=. 0 pick dat
      x=. i.#z
      y=. i.{:$z
    case. 2 do.
      'y z'=. dat
      x=. i.#z
    case. 3 do.
      'x y z'=. dat
    end.
  else.
    z=. itemize dat
    y=. i. {:$ z
    x=. i. # z
  end.
  (x ,"0/ y),"1 0 z
  
NB. ---------------------------------------------------------
else.
  if. isboxed dat do.
    select. #dat
    case. 1 do.
      y=. 0 pick dat
      x=. i.{:$y
    case. 2 do.
      'x y'=. dat
    end.
  else.
    y=. itemize dat
    x=. i. {:$ y
  end.
  x ,. |: y
end.
)

NB. =========================================================
NB. following builds a shell script for running gnuplot
NB. but cannot get this to work.  cdb dec 2006
gphost=: 3 : 0
return.
f=. jpath '~temp/shell.sh'
y=. y, LF -. {:y
y 1!:2 <f
'rwx------' 1!:7 <f
2!:0 f
1!:55 <f
)

