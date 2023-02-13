NB. ws handlers

NB. =========================================================
NB. default onmessage
NB.  text   - execute in base and return character result
NB.  binary - return reversed msg
ws_onmessage=: 3 : 0
logcmd y
if. encoding=1 do.
  ws_exec_z_=. ".
  try.
    t=. 6!:1''
    r=. ws_exec__ y
    t=. t -~ 6!:1''
    if. 4!:0<'r' do. 2+ end.
    r=. loguse t;boxj2utf8 flatten r
  catch.
    r=. logerror 'could not execute: ',y
  end.
else.
  t=. 6!:1''
  r=. |. y
  t=. t -~ 6!:1''
  r=. loguse t;r
end.
ws_send r
)
