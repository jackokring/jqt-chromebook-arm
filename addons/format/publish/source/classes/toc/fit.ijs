NB. fit

NB. =========================================================
NB. return list of lines
fit=: 3 : 0
r=. i.0 7
for_p. y do.
  'clr fnt txt'=. p
  txt=. u2a txt
  txt=. (- LF = {: txt) }. txt
  if. TOCALIGN=2 do.
    ndx=. txt i: ' '
    bgn=. dtb ndx {. txt
    end=. }. ndx }. txt
    bwd=. fnt fontwidth bgn
    ewd=. 0
  else.
    bgn=. txt
    end=. ''
    bwd=. fnt fontwidth bgn
    ewd=. fnt fontwidth end
  end.
  hit=. fontheight fnt
  r=. r,clr;fnt;bgn;end;bwd;ewd;hit
end.
)
