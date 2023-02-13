NB. jdb_debug win

NB. =========================================================
jdbmain_dun=: ]
jdbmain_ini=: ]

NB. =========================================================
jdbmain_stopline_button=: 3 : 0
jdb_lxsoff''
bgn=. {. 0 ". lines_select
line=. +/ LF = bgn {. lines
opt=. (line e. CODELINES) >@{ 0;2
opt jdb_stopsetline line
jdb_lexwin''
jdb_lxson''
)

NB. =========================================================
jdbmain_stopname_button=: 3 : 0
jdb_lxsoff''
'ndx name'=. jdbmain_getname''
if. #name do.
  1 jdb_stoponall name
  jdb_wd 'set lines select ',":ndx
end.
jdb_lxson''
)

NB. =========================================================
jdbmain_stopwin_button=: 3 : 0
jdb_lxsoff''
'ndx name'=. jdbmain_getname''
name jdb_swap 'jdbstop'
jdb_lxson''
)

NB. =========================================================
jdebug_lines_button=: jdebug_stepover_button

NB. =========================================================
NB. returns: '';'' if none, or ndx;name(s)
jdbmain_getname=: 3 : 0
sel=. 0 ". lines_select
end=. I. LF=lines,LF
bgn=. 0, 1+}:end
if. sel e. bgn ,. end do.
  'ndx name'=. sel jdb_getnamesat lines
else.
  'ndx name'=. sel jdb_getnameat lines
end.
)

NB. =========================================================
jdb_writelines=: 4 : 0
len=. 0, +/\ 1 + # &> y
jdb_wd 'set lines text *',jdb_listboxed y
jdb_wd 'setscroll lines ',":SCROLL
jdb_wd 'setfocus lines'
if. x do.
  jdb_wd 'set lines select ',": 0 _1 + (MOVELINE+0 1){len
end.
jdb_minsize''
)
