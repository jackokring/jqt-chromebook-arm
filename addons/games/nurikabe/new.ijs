NB. newboard

NB. =========================================================
NEW=: 0 : 0
pc new owner;pn "New Board";
bin hvh;
cc s1 static;cn "Rows:";
cc erows edit;
bin zh;
cc s2 static;cn "Cols:";
cc ecols edit;
bin zh;
cc s0 static;cn "Name (optional):";
cc ename edit;
bin zszv;
cc ok button;cn "OK";
cc cancel button;cn "Cancel";
bin szz;
pas 6 6;pcenter;
rem form end;
)

NB. =========================================================
new_run=: 3 : 0
wd NEW
wd 'pshow'
)

NB. =========================================================
new_close=: 3 : 0
wd 'pclose'
wd 'psel ',":HWNDP
)

NB. =========================================================
new_ok_button=: 3 : 0
rws=. {. 0 ". erows
cls=. {. 0 ". ecols
name=. deb ename
if. 0 e. ((-:<.) rws,cls), 5 <: rws,cls do.
  info 'Rows and Cols should be 5 or more'
  return.
end.
OLDBOARD=: BOARD;SHAPE;NAME;FILE
CARET=: ''
SHAPE=: rws,cls
BOARD=: (rws*cls)$0
NAME=: name
FILE=: ''
new_close''
nk_run 1
)

NB. =========================================================
newboardcancel=: 3 : 0
if. query 'OK to cancel edit?' do. return. end.
'BOARD SHAPE NAME FILE'=: OLDBOARD
nk_run 0
)

NB. =========================================================
newboardok=: 3 : 0
if. query 'OK to accept board?' do. return. end.
BOARD=: init BOARD
nk_run 0
)

NB. =========================================================
new_cancel_button=: new_close
newboard=: new_run
