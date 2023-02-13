NB. log

LOG=: jpath '~temp/publish.log'

NB. =========================================================
loginit=: 3 : 0
if. _1 -: '' fwrite LOG do.
  throw 'Unable to write to log file: ',LOG
end.
)

NB. =========================================================
log=: 3 : 0
((,":y),LF) fappends LOG
)
