NB. util

NB. =========================================================
addLF=: 3 : 0
y, (0<#y) # LF -. {: y
)

NB. =========================================================
NB. replace NB. by #
fixcmd=: 3 : 0
y rplc 'NB.';'#'
)
