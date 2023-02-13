NB. manifest for lint
CAPTION=: 'Load a script and check its syntax'
VERSION=: '1.18.16'
PLATFORMS=: ''
FILES=: 0 : 0
lint.ijs
)
RELEASE=: ''

FOLDER=: 'debug/lint'

DEPENDS=: 0 : 0
)
DESCRIPTION=: 0 : 0
lint tries to find errors before a script is run.  The idea is for 'lint' to replace 'load'
during debugging.  The errors it looks for are the following:
 explicit definitions lacking trailing )
 undefined names, including names not defined in all paths
 verbs used with invalid valences
 non-noun results at the end of condition blocks and verbs
 syntax errors
 sentences with no effect on execution (eg verb verb)

See the program header for description and directives.
)
