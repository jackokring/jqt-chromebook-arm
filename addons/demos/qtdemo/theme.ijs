NB. controls demo in dark theme

coclass 'qtdemo'

dat=. freads '~addons/demos/qtdemo/controls.ijs'
dat=. dat rplc 'pc controls;';'pc controls;pn "dark theme";ptheme dark;'
dat=. dat rplc '#eeeeee';'#31363b'
0!:100 dat
