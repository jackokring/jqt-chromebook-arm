NB.%testempty.ijs - text utilities
NB.-
NB.-used for testing joxygen

NB. =========================================================
NB.mydef v cut text into boxed list of paragraphs
mydef=: 3 : 0
txt=. topara y
txt=. txt,LF -. {:txt
b=. (}.b,0) < b=. txt=LF
b <;._2 txt
)
