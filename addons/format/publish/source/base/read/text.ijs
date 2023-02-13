NB. text

NB. =========================================================
NB. parse text files into sections, i.e. beginning <h1 ...>
NB. returns sections;if front page
NB. runs all includes
parsetext=: 3 : 0
txt=. trimLF y
if. 0=#txt do. '';0 return. end.
msk=. Rxh1 findrx txt
msk=. msk > premask txt
front=. 0 = {.msk
msk=. 1 (0)} msk
txt=. msk <;.1 txt
txt=. trimLF each txt
txt;front
)
