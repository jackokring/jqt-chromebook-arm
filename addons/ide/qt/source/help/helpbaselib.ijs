NB. base library help jumps

NB. =========================================================
htmlhelpbaselib=: 3 : 0
if. fexist f=. jpath '~.Main/', y do.
  open f     NB. no need to use browser
else.
  browse_j_ 'https://github.com/jsoftware/base9/tree/master/',y
end.
''
)
