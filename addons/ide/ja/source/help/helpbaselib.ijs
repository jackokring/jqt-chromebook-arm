NB. base library help jumps

NB. =========================================================
htmlhelpbaselib=: 3 : 0
  if. fexist f=. jpath '~.Main/', y do.
    open f     NB. no need to use browser
  else.
    browse_j_ 'http://www.jsoftware.com/wsvn/base8/trunk/', y
  end.
''
)
