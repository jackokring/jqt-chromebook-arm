NB. escape sequence of pdf
NB.
NB. \n linefeed
NB. \r carriage return
NB. \t horizontal tab
NB. \f formfeed
NB. \b backspace
NB. \\ backslash
NB. \( left parenthesis
NB. \) right parenthesis
NB. \ddd character code ddd (octal)

PDFRESC0=: LF,CR,TAB,FF,(8{a.),'\()'
PDFRESC1=: 'nrtfb\()'
PDFASC=: PDFRESC0,32}.127{.a.

NB. =========================================================
NB. pdfesc
NB.
NB. fixes backslash in text and adds any escape sequences

pdfesc=: 3 : 0

NB. add backslash
txt=. y
msk=. txt e. PDFRESC0
if. 1 e. msk do.
  ndx=. , ((I. msk) + i. +/ msk) +/ 0 1
  new=. ,'\',.PDFRESC1 {~ PDFRESC0 i. msk#txt
  txt=. new ndx } (1 + msk) # txt
end.

NB. convert nonprinting ascii characters to ddd
msk=. -. txt e. PDFASC
if. 1 e. msk do.
  new=. 1 ": 8 8 8 #: a. i. msk # txt
  ndx=. ,((I. msk) + 3 * i. +/ msk) +/ i. 4
  txt=. (,'\',"1 new) ndx } (1 + msk * 3) # txt
end.

txt
)
