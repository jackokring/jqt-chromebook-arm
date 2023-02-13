NB. para
NB.
NB. each para is a 3 col table of color;font;text
NB.
NB. each text may contain HYPHEN, and line feed, both indicating
NB. how the text is to flow to the next line

NB. =========================================================
ParaTags=: <;._2 (0 : 0)
b
i
link
style
)

NB. =========================================================
j=. '<br/>';LF;'&lt;';'<';'&gt;';'>';'&nbsp';' '
Pararplc=: _2 [\ j

NB. =========================================================
NB. fix a paragraph of text into a para table
fixpara=: 3 : 0
txt=. y
txt=. delparaLF txt
txt=. deb txt
txt=. txt rplc Pararplc
txt=. ParaTags parseml txt
(Color,Font) make txt
)
