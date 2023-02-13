NB. jdb_debug function keys
NB.
NB. keyboard shortcuts
NB.
NB. the ~ allows TAB to line up the entries correctly
NB. with large fonts...

j=. 0 : 0
Enter          !single step over
F5~~~~~~~~     !run
Ctrl+Shift+F5  !run from next line
F6~~~~~~~~     !single step into
F7~~~~~~~~     !single step over
F8~~~~~~~~     !step out of current definition
F9~~~~~~~~     !toggle stop on cursor line
Ctrl+Shift+F9  !remove all stops
Ctrl+T         !toggle topmost attribute
Ctrl+W         !write current line to session
)

SHORTCUTS=: ' ' (I. j='~') } TAB (I. j='!')} j

NB. =========================================================
jdb_swapfkey=: 3 : 0
jdebug_f5_fkey=: ]
jdebug_f6_fkey=: ]
jdebug_f7_fkey=: ]
jdebug_f8_fkey=: ]
jdebug_f9_fkey=: ]
jdebug_f5ctrlshift_fkey=: ]
jdebug_f9ctrlshift_fkey=: ]
if. TABCURRENT -: 'jdbmain' do.
  jdebug_f5_fkey=: jdebug_run_button
  jdebug_f6_fkey=: jdebug_stepinto_button
  jdebug_f7_fkey=: jdebug_stepover_button
  jdebug_f8_fkey=: jdebug_stepout_button
  jdebug_f9_fkey=: jdbmain_stopline_button
  jdebug_f5ctrlshift_fkey=: jdebug_runnext
  jdebug_f9ctrlshift_fkey=: jdebug_clearstops
elseif. TABCURRENT -: 'jdbstop' do.
  jdebug_f9_fkey=: jdbstop_stopline_button
end.
0
)
