NB. mb (message box) demo
NB.
NB. the message box syntax is:
NB.   wd 'mb type buttons title message'
NB.
NB. type specifies the icon and default behaviour:
NB.  info      (default OK button)
NB.  warn      (default OK button)
NB.  critical  (default OK button)
NB.  query     (requires two or three buttons, default is first given)
NB.             note - display order is platform-dependent
NB.
NB. if 1 button, there is no result,
NB. otherwise the result is the lowercase button label
NB.
NB. buttons are from the set, a button starts with = is the default:
NB.  mb_ok
NB.  mb_open
NB.  mb_save
NB.  mb_cancel
NB.  mb_close
NB.  mb_discard
NB.  mb_apply
NB.  mb_reset
NB.  mb_restoredefaults
NB.  mb_help
NB.  mb_saveall
NB.  mb_yes
NB.  mb_yestoall
NB.  mb_no
NB.  mb_notoall
NB.  mb_abort
NB.  mb_retry
NB.  mb_ignore

coclass 'qtdemo'

demo1=: 3 : 0
wd 'mb info *Job finished.',LF,LF,'Goodbye.'
)

demo2=: 3 : 0
wd 'mb warn "Model Run" "Job finished early."'
)

demo3=: 3 : 0
wd 'mb critical "Model Run" "Job failed."'
)

demo4=: 3 : 0
wd 'mb query mb_ok mb_cancel "Model Run" "OK to save?"'
)

demo5=: 3 : 0
wd 'mb query mb_yes =mb_no mb_cancel "Model Run" "OK to continue?"'
)

demo1''
demo2''
demo3''
smoutput demo4''
smoutput demo5''
