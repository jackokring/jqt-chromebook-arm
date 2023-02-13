NB. zdef
NB.
NB. cover functions defined in z

NB. =========================================================
NB.*gplot v main verb for gnuplot
NB.
NB. form:  options gplot data
NB.
NB. example:
NB.
NB. 'with line' gplot sin steps 0 5 60
gplot_z_=: gplot_pgnuplot_

NB. =========================================================
NB.*gsplot v main verb for surface gnuplot
NB.
NB. form:  options gsplot data
NB.
NB. example:
NB.
NB. gsplot sin */~ steps 0 5 60
gsplot_z_=: gsplot_pgnuplot_

NB. =========================================================
NB.*gset v set gnuplot options
NB.
NB. form:  gset data
NB.
NB. example:
NB.
NB.    gset 'grid'
NB.    gset 'title "sin(exp) vs cos(exp)"'
NB.    gplot mydata
gset_z_=: gset_pgnuplot_
