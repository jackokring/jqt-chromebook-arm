NB. test
NB.
NB. This builds html docs in the Target directory, that should match
NB. those distributed in ~addons/docs/joxygen/testdocs

require 'docs/joxygen'

NB. source directory (used to find source files,
NB. but not used in the html docs)
Source=: jpath '~addons/docs/joxygen/testscripts'

NB. target directory
Target=: jpath '~temp/joxygen'

NB. source files under the source directory
NB. (may be more than one level down)
Files=: cutopen 0 : 0
compare.ijs
dir.ijs
text.ijs
)

NB. header for main page index.htm
IndexHdr=: 0 : 0
This is the header for the main index page.
)

NB. ensure the Target directory is created
mkdir_j_ Target

NB. copy the css file to the Target directory
(Target,'/joxygen.css') fcopynew '~addons/docs/joxygen/joxygen.css'

NB. make the docs
makedocs''
