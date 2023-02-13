NB. =========================================================
NB. Convert from arrays of boxes to delimited strings

NB. ---------------------------------------------------------
NB.*joindsv v Unbox and delimit a list of boxed items y with x
NB. form: Delimiter joindsv BoxedList
NB. eg: '","' joindsv 'item1';'item2'
NB. eg: LF joindsv 'item1';'item2'
NB. eg: 99 joindsv <"0 i.8
NB. based on forum post
NB. http://www.jsoftware.com/pipermail/programming/2007-June/007077.html
joindsv=: ' '&$: : (4 : '(;@(#^:_1!.(<x))~  1 0$~0 >. _1 2 p.#) y')

NB. ---------------------------------------------------------
NB.*delimitarray v Delimits and quotes an array of boxed of mixed type items
NB. makedsv performs better for large arrays
NB. returns: delimited, quoted string
NB.       Only arrays with rank>1 have trailing LF
NB.       Rows of arrays with rank>1 are delimited by LF
NB.       Fields within rows delimited by fd
NB.       Only contents of literal boxes in y are quoted.
NB.       Internal quotes are doubled if present.
NB. form: [fd[;sd0[,sd1]]] delimitarray arrayofboxes
NB. y is: boxed array of mixed type
NB. x is: literal list or 1 or 2-item boxed list of optional delimiters.
NB.       0{:: single literal field delimiter (fd). Defaults to 'TAB'
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '""
delimitarray=: 3 : 0
  (TAB;'""') delimitarray y
  :
  'fd sd'=. 2{. boxopen x
  if. (#sd) +. -. *./ ,ischar 3!:0 &>y do. NB. if sd not empty or y not all boxed strings
    y=. sd enclosestrings y                NB. quote strings & non-strings to string
  end.
  dat=. LF joindsv ,<@(fd&joindsv)"1 y
  dat, (1<#$y)#LF                          NB. append LF for arrays rank >1
)

--------------------------------------------------
NB.*appenddsv v Appends an array to a delimiter-separated value file
NB. returns: number of bytes appended or _1 if unsuccessful
NB. form: dat appenddsv file[;fd[;sd0[,sd1]]]
NB. eg: (3 2$'hello world';4;84.3;'Big dig') appenddsv (jpath '~temp/test.csv');'|';'<>'
NB. y is: literal list or a 2 or 3-item list of boxed literals
NB.       0{ filename of file to append dat to
NB.       1{ optional field delimiter. Default is TAB
NB.       2{ optional string delimiters, sd0 & sd1. Defaults are '""'
NB. x is: a J array
appenddsv=: 4 : 0
 args=. boxopen y
  'fln fd sd'=. args,(#args)}.'';TAB;'""'
  dat=. (fd;sd) makedsv x
  dat fappends fln
)

NB. ---------------------------------------------------------
NB.*makedsv v Makes a delimiter-separated value string from an array
NB. returns: DSV string
NB.          Results of all arrays except empty have trailing LF
NB. form: [fd[;sd0[,sd1]]] makedsv array
NB. eg: ('|';'<>') makedsv  3 2$'hello world';4;84.3;'Big dig'
NB. y is: an array
NB. x is: literal(s), or 1 or 2-item boxed list of optional delimiters.
NB.       0{:: literal field delimiter(s) (fd). Defaults to TAB
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. Arrays are flattened to a max rank of 2.
makedsv=: 3 : 0
  (TAB;'""') makedsv y
  :
  dat=. y=. ,/^:(0>. _2+ [:#$) y   NB. flatten to max rank 2
  dat=. y=. ,:^:(2<. 2- [:#$) y    NB. raise to min rank 2
  'fd sd'=. 2{. boxopen x
  if. 1=#sd do. sd=. 2#sd end.
  NB. delim=. ',';',"';'",';'","';'';'"';'"'
  delim=. fd ; (fd,}:sd) ; ((}.sd),fd) ; ((}.sd),fd,}:sd) ; '' ; (}:sd) ; }.sd

  NB. choose best method for column datatypes
  try. type=. ischar 3!:0@:>"1 |: dat
    if. ({.!.a: sd) e. ;(<a:;I. type){dat do. assert.0 end. NB. sd in field
    if. -. +./ type do.          NB. all columns numeric
      dat=. 8!:0 dat
      delim=. 0{ delim
    else.                        NB. columns either numeric or literal
      idx=. I. -. type
      if. #idx do.               NB. format numeric cols
        dat=. (8!:0 tmp{dat) (tmp=. <a:;idx)}dat
      elseif. 0=L.dat do.        NB. y is literal array
        dat=. ,each 8!:2 each dat
      end.
      dlmidx=. 2#.\ type         NB. type of each column pair
      dlmidx=. _1|.dlmidx, 4&+@(2 1&*) ({:,{.) type
      delim=. (#dat)# ,: dlmidx { delim
    end.
  catch.                         NB. handle mixed-type columns
    dat=. sd enclosestrings dat
    delim=. 0{ delim
  end.
  NB. make an expansion vector to open space between cols
  d=. 0= 4!:0 <'dlmidx'           NB. are there char cols that need quoting
  c=. 0>. (+:d)+ <:+: {:$dat      NB. total num columns incl delims
  b=. c $d=0 1                    NB. insert empty odd cols if d, else even
  dat=. b #^:_1"1 dat             NB. expand dat
  if. #idx=. I.-.b do.
    dat=. delim (<a:;idx)}dat     NB. amend with delims
  end.
  ;,dat,.(1=#$dat){LF;a:          NB. add EOL if dat not empty & vectorise
)

NB. ---------------------------------------------------------
NB.*writedsv v Writes an array to a delimiter-separated value file
NB. returns: number of bytes written (_1 if write error)
NB.          An existing file will be written over.
NB. form: dat writedsv file[;fd[;sd0[,sd1]]]
NB. eg: (i.2 3 4) writedsv (jpath ~temp/test);'|';'{}'
NB. y is: literal list or a 2 or 3-item list of boxed literals
NB.       0{ filename of file to append dat to
NB.       1{ optional field delimiter. Default is TAB
NB.       2{ optional string delimiters, sd0 & sd1. Defaults are '""'
NB. x is: an array
writedsv=: 4 : 0
  args=. boxopen y
  'fln fd sd'=. args,(#args)}.'';TAB;'""'
  dat=. (fd;sd) makedsv x
  dat fwrites fln
)
