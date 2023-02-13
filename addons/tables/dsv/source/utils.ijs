NB. =========================================================
NB. utils for dsv

ischar=: ] e. 2 131072 262144"_     NB. is datatype a character

isreal=: ] e. 1 4 8 64 128"_ NB. is datatype numeric real

NB. ---------------------------------------------------------
NB.*enclose v Encloses string in quotes
NB. form: [sd0[,sd1]] enclose strng(s)
NB. returns: quoted string
NB.      Internal quotes are doubled if present.
NB. y is: string or boxed strings to enclose with quotes
NB. x is: optional quote type. Default is '""'
NB.       0{ is (start) string delimiter (sd0)
NB.       1{ is end string delimiter (sd1)
enclose=: 3 : 0
  '""' enclose y
  :
  if. 0<L. y do. x&enclose &.> y return. end.
  if. -.(#x)e. 0 2 do. x=. 2$x end.
  (}:x),((>: (y e. x) *. =/x)#y),}.x
)

NB. ---------------------------------------------------------
NB.*enclosestrings v Array cells to strings with literal quoted
NB. form: [sd0[,sd1]] enclosestrings strng(s)
NB. returns: array of boxed strings with literals quoted
NB.         Only contents of literal boxes in y are quoted.
NB.         Internal quotes are doubled if present.
NB.         Numeric boxes are converted to strings
NB. y is: boxed array of mixed type
NB. x is: optional quote chars. Default is '""'
NB.       0{ is (start) string delimiter (sd0)
NB.       1{ is end string delimiter (sd1)
enclosestrings=: 3 : 0
  '""' enclosestrings y
  :
  if. 1=#sd=. x do. sd=. 2#sd end.
  dat=. ,y
  t=. #. ((0<#@$) , (isreal,.ischar)@:(3!:0)) &> dat        NB. cell data type
  dat=. ((#idx)$sd enclose idx{dat)(idx=. I. t e. 1 5)}dat  NB. quote char cells
  dat=. (8!:0 idx{dat) (idx=. I. 2=t)}dat                   NB. format numeric cells
  dat=. (":@:,@:> &.> idx{dat)(idx=. I. t e. 0 4 6)}dat     NB. handle complex, boxed, numeric rank>0
  ($y)$dat
)

NB. ---------------------------------------------------------
NB.*makenum v Converts cells in array of boxed literals to numeric where possible
NB. form: [err] makenum array
NB. returns: numeric array or array of boxed literals and numbers
NB. y is: an array of boxed literals
NB. x is: optional numeric error code. Default is _9999
makenum=: 3 : 0
  _9999 makenum y
  :
  dat=. , x&". &.> y=. boxopen y
  idx=. I. x&e.@> dat
  if. #idx do.
    dat=. (idx{,y) idx}dat  NB. amend non-numeric cells
  else.
    dat=. >dat              NB. unbox to list if all numeric
  end.
  ($y)$dat
)

NB. ---------------------------------------------------------
NB.*makenumcol v Converts columns in table of boxed literals to numeric where possible
NB. form: [err] makenumcol array
NB. returns: numeric array or array of boxed literal and numeric columns
NB. y is: an array of boxed literals
NB. x is: optional numeric error code. Default is _9999
NB. Only converts column to numeric if conversion is possible for whole column
makenumcol=: 3 : 0
  _9999 makenumcol y
  :
  dat=. x&". &.> y=. boxopen y
  notnum=. x&e.@> dat               NB. mask of boxes containing error code
  idx=. I. +./notnum                NB. index of non-numeric columns
  if. #idx do.
    dat=. (idx{"1 y) (<a:;idx)}dat  NB. amend non-numeric columns
  else.
    dat=. >dat                      NB. unbox to list if all numeric
  end.
)


NB. filter the starting block of lines in a text file
NB. where the first non-whitespace char is #
dlws=: }.~ (e.&(' ',TAB) i. 0:)             NB. delete leading whitespace
getIdxFnc=: ([: ((=&'#') i. 0:) {.@dlws;.2) NB. index of first non-comment line
droplComments=: ;@:(<;.2 }.~ getIdxFnc)     NB. drop leading comments
takelComments=: ;@:(<;.2 {.~ getIdxFnc)     NB. take leading comments
getHeader=: ;@:(<;._2 {~ getIdxFnc)         NB. retrieve header line (1st non comment line)

NB. Try to ensure that header names are valid J names
forceLeadingAlpha=: ,~ 'X' {.~ [: -.@e.&Alpha_j_ {.
replaceNonAlpha=: (-.@e.&AlphaNum_j_)`(,:&'_')}
deus=: #~ (+. (1: |. (> </\)))@('_'&~:)    NB. delete extraneous underscores
coerce2Name=: forceLeadingAlpha@deus@replaceNonAlpha@deb NB. coerce string to valid J name

NB. uniqify v Ensures all boxed literals in a list are unique by appending numeral
uniqify=: 3 : 0
  idx=. ([: I. i:~ ~: i.~) y   NB. idx of non unique items
  ((,&.> 8!:0@i.@#) idx{y) idx}y
)
