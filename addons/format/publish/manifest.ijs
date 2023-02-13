NB. publish manifest

CAPTION=: 'builds pdf reports from markup'

DESCRIPTION=: 0 : 0
Publish generates a PDF report from source in plain text files in an html-like markup language.

The markup language supports calling J expressions, for example, to allow data to be read in from various sources. Apart from this, reports can be customized without knowledge of J.
)

VERSION=: '1.0.29'

RELEASE=: ''

FOLDER=: 'format/publish'

DEPENDS=: 0 : 0
afm
bmp
colortab
general/misc/font
gl2
numeric
plot
regex
trig
)

FILES=: 0 : 0
publish.ijs
demo/
)
