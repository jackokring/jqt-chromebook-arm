NB. graphviz

coclass 'pgraphview'

TITLE=: 'Graph View'
TEMPFILE=: 'graphview'
TEMPDIR=: jpath '~temp'
ADDONDIR=: jpath '~addons/graphics/graphviz'
FILTER=: IFWIN pick ('Graph File .gv (*.gv)|Graph File .dot (*.dot)|All Files (*.*)');'Graph File (*.gv)|Graph File (*.dot)|All Files (*.*)'
PATHSEP=: '/'
OLDDIR=: ADDONDIR

graphview_z_=: [: empty conew&'pgraphview'
create=: graphviz_run
destroy=: graphviz_close_button=: graphviz_close
