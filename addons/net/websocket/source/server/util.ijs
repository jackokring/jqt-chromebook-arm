NB. util

binchar=: (8$2)#:a.&i.
charbin=: a. {~ #.
jfe=: 0 0$15!:16
intersect=: e. # [
remLF=: }.~ [: - LF = {:
sha1sum=: 1 & (128!:6)

BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'
MaxRep=: 100

NB. =========================================================
NB. convert strings with J box chars to utf8
NB. rank < 2
boxj2utf8=: 3 : 0
if. 1 < #$y do. y return. end.
b=. (16+i.11) { a.
if. -. 1 e. b e. y do. y return. end.
y=. ucp y
a=. ucp '┌┬┐├┼┤└┴┘│─'
x=. I. y e. b
utf8 (a {~ b i. x { y) x } y
)

NB. =========================================================
checktimes=: 3 : 0
for_loc. servers intersect conl 1 do.
  try.
    checklastuse__loc''
    checktermtime__loc''
  catch. end.    NB. locale error
end.
)

NB. =========================================================
cutval=: 3 : 0
deb each <;._1 ',',tolower y
)

NB. =========================================================
flatten=: 3 : 0
dat=. ": y
select. # $ dat
case. 1 do.
case. 2 do.
  }. , LF ,. dat
case. do.
  dat=. 1 1}. _1 _1}. ": < dat
  }: (,|."1 [ 1,.-. *./\"1 |."1 dat=' ')#,dat,.LF
end.
)

NB. =========================================================
hasher=: 3 : 0
s=. y,'258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
tobase64 a.{~ 16 #. _2[\ '0123456789abcdef' i. sha1sum s
)

NB. =========================================================
NB. fix problems with mac sockets
NB. can be removed with newer base libraries
macinit=: 3 : 0
if. UNAME-:'Darwin' do.
  ioctlsocketJ_jsocket_=: 'ioctl i i x *i' scdm_jsocket_
  FIONBIO_jdefs_=: 16b8004667e
end.
)

NB. =========================================================
mrep=: 3 : 0
y=. (LF={.y)}.(-LF={:y)}.y
r=. y rplc LF;','
if. MaxRep<#r do.
  (MaxRep{.r),'..'
end.
)

NB. =========================================================
setimmex=: 3 : 0
9!:27 y
9!:29 [ 1
EMPTY
)

NB. =========================================================
srep=: 3 : 0
y=. (-LF={:y)}.y
if. LF e. y do.
  r=. y rplc LF;','
else.
  r=. 5!:5 <'y'
end.
if. MaxRep<#r do.
  (MaxRep{.r),'..'
end.
)

NB. =========================================================
NB.*tobase64 v To base64 representation
tobase64=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)

NB. =========================================================
wsreset=: 3 : 0
for_loc. servers intersect conl 1 do.
  destroy__loc''
end.
)
