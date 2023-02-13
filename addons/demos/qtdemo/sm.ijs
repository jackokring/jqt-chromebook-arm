NB. examples of wd 'sm'
NB. where tab index is used, ensure the index is valid

wd 'sm active tab 1' NB. active tab index 1
wd 'sm close tab 1'  NB. close tab index 1

wd 'sm get active' NB. get which window is active:
wd 'sm get edit'   NB. get text, selection, filename
wd 'sm get tabs'   NB. get list of tabs
wd 'sm get term'   NB. get text, selection
wd 'sm get xywh'   NB. get xywh of windows:

NB. set input focus:
wd 'sm focus term'         NB. same as wd 'sm act'
wd 'sm focus edit'

wd 'sm font Monospace 20'  NB. set session font

wd 'sm open edit'
wd 'sm open tab'            NB. open new tab
wd 'sm open tab ~addons/demos/qtdemo/spinbox.ijs'  NB. open file, in new tab if necessary

NB. set term prompt:
wd 'sm prompt *   i.2 3'

NB. note all tabs are automatically saved when running a line manually:
wd 'sm save edit' NB. save edit window
wd 'sm save tabs' NB. save all edit tabs

NB. set selection in window:
wd 'sm set edit select 28 46'
wd 'sm set edit select 34 34'  NB. if same, just set cursor

wd 'sm set edit scroll 5'  NB. scroll to line 5 (origin-0)

NB. set text in window - replace any existing text:
wd 'sm set term text *How grand to be a Toucan',LF,'Just think what Toucan do.'

NB. set window positions (-1 means leave unchanged):
wd 'sm set term xywh 0 0 500 500'
wd 'sm set term xywh 20 20 -1 -1'
wd 'sm set term xywh -1 -1 -1 600'

NB. the following change the current edit window
NB. run when suitable edit window is open
Note''
wd 'sm replace edit ~Qt/demo/spinbox.ijs'  NB. replace current edit window with filename
wd 'sm run edit' NB. save and run window
)
