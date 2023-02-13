NB. pre draw

NB. =========================================================
NB. draw
NB. returncode 0=ok, 1=more to come
draw=: 3 : 0

if. y do.
  Dbal=: <;._2 Data,LF
end.

hit=. fontheight Font
max=. <. Sh % hit
rc=. max < #Dbal

NB. ---------------------------------------------------------
if. rc do.
  dat=. max {. Dbal
  Dbal=: max }. Dbal
else.
  dat=. Dbal
end.

NB. ---------------------------------------------------------
pos=. <"1 Sx,.Sy + Sh - hit * i.#dat
Textc=: Textf=: _1
r=. wraptext drawtext pos,.(<0),.(<Font),.dat
setsxywhP Sx,Sy,Sw,Sh-hit * #dat
rc;r
)