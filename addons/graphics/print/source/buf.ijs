NB. print command buffer
NB.
NB. PCMDS is a boxed list of pages
NB. PCMD is the current page, as a 2 column table:
NB.    command, parameter

NB. =========================================================
bufinit=: 3 : 0
PCMDS=: ''
PCMD=: i.0 2
)

NB. =========================================================
NB. buf
NB.
NB.   buf 'page'             end page
NB.   buf 'name';value       set item into current buffer
buf=: 3 : 0
if. y -: 'page' do.
  PCMDS=: PCMDS,<PCMD
  PCMD=: i. 0 2
else.
  PCMD=: PCMD, y
end.
empty''
)

NB. =========================================================
NB. buf execute
bufexe=: 3 : 0
for_d. y do.
  'f v'=. d
  f~v
end.
)
