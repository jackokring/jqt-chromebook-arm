NB. publish defaults
NB.
NB. Note: names for global nouns defined in this script must be
NB. uppercase only. Publish does not use uppercase names in the
NB. code, therefore names defined here cannot conflict with it.
NB.
NB. this script may use nouns defined in the pub script

NB. =========================================================
NB. header fonts:
FONTH0=: 'Sans 11 bold'
FONTH1=: 'Sans 11 bold'
FONTH2=: 'Sans 10 bold'
FONTH3=: 'Sans 9 bold'
FONTH4=: 'Sans 9 bold'
FONTH5=: 'Sans 9 bold'
FONTH6=: 'Sans 9 bold'

NB. corresponding table of contents:
FONTC0=: 'Sans 10 bold'  NB. TOC header
FONTC1=: 'Sans 10 bold'  NB. header level 1, etc
FONTC2=: 'Sans 9'
FONTC3=: 'Sans 9'
FONTC4=: 'Sans 9'
FONTC5=: 'Sans 9'
FONTC6=: 'Sans 9'

FONTP=: 'Sans 9'  NB. para font
FONTPF=: 'Mono 9'  NB. para fixed font
FONTTH=: 'Sans 9' NB. table header
FONTTC=: 'Sans 9' NB. table cell

NB. =========================================================
NB. table colors
NB. each row is foreground;background
NB.
NB. TCOLOR is a table with at least 3 rows
NB. the first 3 rows are defaults for:
NB.   top and col header,row label, cell
NB.
NB. there may be any number of additional rows
NB.
NB. - a color index of 0 picks the default color for that cell
NB.   from the first 3 rows.
NB. - a color index of 1 or more picks the corresponding color
NB.   from rows after the first 3
TCOLOR=: ". ;._2 (0 : 0)
0 0 0 216 216 220
0 0 0 255 255 255
0 0 0 255 255 255
0 0 0 255 255 179
0 0 0 153 153 255
255 0 0 255 255 255
255 255 255 0 128 128
)

NB. =========================================================
NB. table grid line unit point size:
TGRIDSIZE=: 0.2
TGRIDCOLOR=: 0.5 0.5 0.5

NB. =========================================================
ALIGN=: 0  NB. horizontal alignment
ALIGNV=: 0 NB. vertical alignment
AUTHOR=: '' NB. author in PDF header
BMLEVEL=: 3  NB. bookmark level
CLASS=: '' NB. default class
HYPHEN=: '~' NB. suggested hyphenation character
LEADING=: 1.2 NB. spacing between lines
LCOLOR=: 0 0 128 NB. link color
NAME=: ''
PAGEMARGINS=: 72  NB. left,top,right,bottom
PAGESIZE=: PSletter NB. width, height in points
PARASPACE=: 0.6 NB. paragraph spacing
SCALE=: 1 NB. image scale (one or two numbers)
STYLE=: '' NB. default style
TITLE=: '' NB. title in PDF header
TOCLEVEL=: 3 NB. table of contents level
