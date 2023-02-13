NAME=: 'Jemima Puddle Duck'

EDITNAME=: 0 : 0
pc editname;
minwh 70 10;cc name edit;
bin h;
cc OK button;
cc Cancel button;
bin zs;
pas 6 6;pcenter;pshow;ptop;
)

NB. this creates and initializes the form:
editname=: 3 : 0
wd EDITNAME
wd 'set name text *',NAME
wd 'pshow'
)

NB. this handles the Cancel button:
editname_Cancel_button=: wd bind 'pclose'

NB. this handles the OK button:
editname_OK_button=: 3 : 0
NAME=: name
wd 'pclose'
)

NB. run the form:
editname''
