NB. test parsing

wdp=. {:"1 @ wd @ ('parse '&,)
SOH=. 1{a.

NB. simple
('one';'two') -: wdp 'one two'

NB. contains * as a remaining parameter (so SOH and LF are ignored):
('one';SOH,'two three',LF,'four') -: wdp 'one *',SOH,'two three',LF,'four'

NB. contains SOH as delimiter
('one';'two three';'four') -: wdp 'one',SOH,'two three',SOH,'four'

NB. contains LF as delimiter
('one';'two three';'four') -: wdp 'one',LF,'two three',LF,'four'

NB. uses "" as delimiters
('one';'two three';'four') -: wdp 'one "two three"',TAB,' four'

NB. LF in delimiters
('one';('two',LF,'three');'four') -: wdp 'one "two',LF,'three"',TAB,'four'

NB. trailing spaces are themselves a parameter
('one';'two three';'four';'') -: wdp 'one "two three" four '

NB. binary data may be given after *
NB. 0{a. not used here as it delimits the wd result
('one';}.a.) -: wdp 'one *',}.a.