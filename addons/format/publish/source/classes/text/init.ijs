NB. init
NB.
NB. A text object is a list of one or more paragraphs,
NB. all with the same alignment (except see below).
NB.
NB. Data is set by verb add
NB. Para is set by fitting the data
NB.
NB. Data is a list of tables, one item per paragraph:
NB.  color index ; font index ; text
NB.
NB. Para is a table of:
NB.  fitted lines; corresponding widths, heights
NB.
NB. text has any markup escapes converted (e.g. &lt; to <)
NB. and may have HYPHEN, LF and TAB

coclass 'ppubtext'

Data=: ''    NB. set when defined
Para=: ''    NB. set when formatted
Font=: ''    NB. default font
Color=: ''   NB. default color

NB. =========================================================
create=: 3 : 0
coinsert locP=: COCREATOR
)