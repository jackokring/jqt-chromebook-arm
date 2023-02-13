NB. command buffers

NB. =========================================================
NB. buf
NB.
NB. form:
NB.   buf 'clear'                   clear current buffer
NB.   buf 'name';value              set item into current buffer,
buf=: 3 : 0
'sel val'=. 2 {. (boxopen y),a:
loc=. {.GDLOC

NB. ---------------------------------------------------------
select. sel
case. 'clear' do.
  GDCMD__GDLOC=: i. 0 2
case. do.
  GDCMD__GDLOC=: GDCMD__GDLOC, ('v',sel);<val
end.

NB. ---------------------------------------------------------
gdclean''
EMPTY
)

NB. =========================================================
gdaddid=: 3 : 0
gdids y, GDIDS
gdloc {: y
)

NB. =========================================================
gdclean=: 3 : 0
msk=. (1 {"1 GDIDS) e. handles''
if. -. 0 e. msk do. return. end.
ndx=. I. -. msk
coerase (18!:1[1) intersect 2 {"1 ndx { GDIDS
gdids (<<<ndx) { GDIDS
gdloc''
)

NB. =========================================================
gdids=: 3 : 0
GDIDS_jzgraph_=: y
)

NB. =========================================================
gddel=: 3 : 0
gdids GDIDS #~ (<y) ~: 1 {"1 GDIDS
gdloc''
)

NB. =========================================================
NB. ensure GDLOC is valid
gdloc=: 3 : 0
if. #y do.
  GDLOC_jzgraph_=: y
end.
if. -. GDLOC e. 2 {"1 GDIDS do.
  GDLOC_jzgraph_=: {: 2 {"1 GDIDS
end.
)
