NB. =========================================================
NB. Convert from delimited strings to arrays of boxes

NB. ---------------------------------------------------------
NB.*fixdsv v Chop multiline delimited string to array of boxed strings
NB. returns: array of boxed literals
NB. form: [fd[;sd0[,sd1]]] fixdsv dat
NB. eg: ('|';'<>') fixdsv '<hello world>|4|84.3',LF,'<Big dig>|<hello world>|4',LF
NB. y is: multiline delimited string, lines delimited by LF
NB. x is: a literal or 1 or 2-item boxed list of optional delimiters.
NB.       0{:: single literal field delimiter (fd). Defaults to TAB
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
fixdsv=: 3 : 0
  (TAB;'""') fixdsv y
  :
  dat=. ydrp=. droplComments y
  'fd sd'=. 2{. boxopen x
  if. #sd do.                    NB. string delimiter
    sd=. ~.sd
    if. 1 < #sd do.              NB. different start & end sd
      s=. {. '|`' -. fd          NB. use single sd that isn't fd
      dat=. dat charsub~ ,sd,.s
      sd=. s
    end.
    b=. dat = LF
    c=. ~:/\ dat = {.sd
    msk=. b > c
    > msk <@(x&chopstring);._2 ydrp
  else.                          NB. no string delimiter
    ([: <;._2 ,&fd);._2 ydrp
  end.
)

NB. ---------------------------------------------------------
NB.*readdsv v Reads delimiter-separated value file into a boxed array
NB. form: [fd[;sd0[,sd1]]] readdsv file
NB. returns: array of boxed literals
NB. y is: filename of file to read from
NB. x is: a literal or 1- or 2-item boxed list of optional delimiters.
NB.       0{:: single literal field delimiter (fd). Defaults to TAB
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. eg: ('|';'<>') readdsv jpath '~temp/test.csv'
readdsv=: 3 : 0
  (TAB;'""') readdsv y
  :
  x=. 2{. boxopen x
  dat=. freads y
  if. dat -: _1 do. return. end.
  x fixdsv dat
)
