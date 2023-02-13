NB. print methods
NB.
NB. main method:
NB. printit

NB. =========================================================
NB. printit
NB. print text
printit=: 4 : 0
bufinit''       NB. print buffer
PRINTFILES=: '' NB. filenames list
PRINTFILE=: ''
P2UP=: 0

NB. ---------------------------------------------------------
PRINTOPT=: 0 pick x
select. 1 pick x
case. 'print' do.
  PRINTTXT=: y
  printform 0
case. 'print2' do.
  PRINTTXT=: y
  P2UP=: 1
  printform 0
case. 'printfile' do.
  getprintfiles y
  printform 1
case. 'printfile2' do.
  getprintfiles y
  P2UP=: 1
  printform 1
end.

NB. ---------------------------------------------------------
)

NB. =========================================================
printclose=: 3 : 0
if. #PRINTFILES do.
  PRINTFILE=: 0 pick PRINTFILES
  PRINTFILES=: }. PRINTFILES
NB.   printform''
else.
  codestroy''
end.
)

NB. =========================================================
printform=: 3 : 0
prnfile=. y
if. 0 e. $opt=. P2UP printopts PRINTOPT do. 1 return. end.
'Ascii Cols Filename Fit Font Header Footer Orient Ruler Tab Printer Printfile'=: opt
opt=. ; dq each '';Printer;Printfile
if. Orient do.
  glzorientation 2=Orient
end.
NB. glzprint opt
NB. OFFSET=: <. 1440 * 2{. glzqltrb 2
SCALE=: (glzqwh 6)%(1440 * glzqwh 2)
if. prnfile do.
  glzstartdoc''
  getcf''
  dirty=. 0
  while. #PRINTFILES do.
    PRINTFILE=: 0 pick PRINTFILES
    PRINTFILES=: }. PRINTFILES
    if. 0= printinit1`printinit2@.(1=P2UP)'' do.
      while. #PCMDS do.
        if. dirty do. glznewpage'' end.
        bufexe 0 pick PCMDS
        PCMDS=: }. PCMDS
        dirty=. 1
      end.
    end.
  end.
  glzenddoc''
else.
  glzstartdoc''
  getcf''
  if. 0= printinit1`printinit2@.(1=P2UP)'' do.
    dirty=. 0
    while. #PCMDS do.
      if. dirty do. glznewpage'' end.
      bufexe 0 pick PCMDS
      PCMDS=: }. PCMDS
      dirty=. 1
    end.
  end.
  glzenddoc''
end.
codestroy''
)
