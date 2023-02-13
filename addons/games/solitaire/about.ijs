NB. J Solitaire
NB. This is the about script for J Solitare.
NB. This loads the about form.

NB. Creating the form
ABOUT=: 0 : 0
pc about nosize owner;pn "About Solitaire";
bin vhv;
minwh 72 96;cc aboutpic isigraph flush;
bin sz;
cc t static;
bin sz;
cc ok button;cn "OK";
bin z;
pas 6 3;pcenter;
rem form end;
)

NB. Loads the form and displays it
about_run=: 3 : 0
wd ABOUT
NB. initialize form here
wd 'psel about'
NB. commands to prepare the isigraph to display deck card(ace of spades)
wd 'set aboutpic wh ',": cardWH
wd 'set t text *J Solitaire',LF,LF,'Version 3.0 - August 2004',LF,LF,LF,LF,'Created by: Ken Cramer'
wd 'pshow;'
)

NB. Closes the about form
about_close=: 3 : 0
wd 'psel about'
wd 'pclose'
)

NB. triggers the about_close'' verb
about_ok_button=: 3 : 0
about_close''
)

about_aboutpic_paint=: 3 : 0
glpixels 0 0, cardWH, ,3 { CARDS NB. Display card
glpaintx^:IFJA ''   NB. asyncj
0
)
