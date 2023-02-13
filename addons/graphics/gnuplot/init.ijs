NB. init

require' task'

coclass 'pgnuplot'
NB. gnuplot
NB.
NB. Supports creating gnuplot plot files from J.
NB.
NB. This has been tested with gnuplot 4.0.
NB.
NB. For example under Windows, try:
NB.
NB.    load 'graphics/gnuplot'
NB.
NB.    GNUPLOTBIN_pgnuplot_=: 'c:\gnuplot\bin\'
NB.
NB.    load 'graphics/gnuplot/gpdemo.ijs'
NB.
NB.    gp1''

NB. =========================================================
NB.*GNUPLOTBIN n gnuplot bin directory (under Windows)
NB.
NB. This is used to determine the executable, wgnuplot.exe
NB. and the configuration file, gnuplot.ini.
NB.
NB. example:
NB.
NB.   GNUPLOTBIN_pgnuplot_=: 'c:\gnuplot\bin\'

NB. =========================================================
NB.*GNUPLOTOUT n directory for gnuplot graphics files
NB.
NB. This defaults to ~temp
GNUPLOTOUT=: jpath '~temp\'

NB. =========================================================
NB. gnuplot command buffer
SETBUFFER=: ''
