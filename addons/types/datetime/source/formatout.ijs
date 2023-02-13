NB. =========================================================
NB. Verbs for formating string representations of Dates and Times
 
NB.*fmtDate v Format a date in a given format
NB.-eg: '\Date is: DDDD, D MMM, YYYY' fmtDate toDayNumber 6!:0''
NB.-result: Formated date string (or array of boxed, formated date strings)
NB.-y: Numeric array of dates given as Day Numbers
NB.-x: Optional format string specifing format of result.
NB.-   Use the following codes to specify the date format:  
NB.-
NB.-   ------  --------  ----------   ---------------  
NB.-   `D`: 1  `DD`: 01  `DDD`: Sun   `DDDD`: Sunday  
NB.-   `M`: 1  `MM`: 01  `MMM`: Jan   `MMMM`: January  
NB.-           `YY`: 09               `YYYY`: 2009  
NB.-   ------  --------  ----------   ---------------  
NB.-
NB.-   To display any of the letters (`DMY`) that are codes, 
NB.-   "escape" them with `\`.
fmtDate=: 3 : 0
  'MMMM D, YYYY' fmtDate y
  :
  codes=. DATECODES
  pic=. x
  'unesc pic'=. '\' escaped pic
  msk=. (>./ (I. -.unesc)} ]) pic i.~ ~.;codes
  pic=. (1 , 2 ~:/\ msk) <;.1 pic                      NB. Cut into tokens
  var=. pic e. codes                                   NB. mark sections as vars

  values=. getDateFormats y

  res=. <@;"1 (|:(codes i. var#pic){values) (I. var)}"1 pic
  if. 0=#$y do. res=. ,>res else.  res=. ($y)$ res end.
  res
)

NB.*fmtTime v Format a time (in seconds) in a given format
NB.-eg: 'Ti\me i\s: hh:mm:ss' fmtTime 86400 * 1|toDayNumber 6!:0 ''
NB.-result: Formated time string (or array of boxed, formated time strings)
NB.-y: Numeric array of times given as time in seconds since start of the day.
NB.-x: Optional format string specifing format of result.
NB.-    Use the following codes to specify the date format:  
NB.-    days (`d`), hours (`h`), minutes (`m`), seconds (`s`),   
NB.-    fractions of a second (`c`), or AM/PM designator (`p`):  
NB.-
NB.-   ---- -- ---- -- ---- -- ---- ---  ---- ---  ---- ---  
NB.-      d  1    h  1    m  1    s   1     c   1     p   a  
NB.-             hh 01   mm 01   ss  01    cc  01    pp  am  
NB.-                            sss 1.2   ccc 001  
NB.-   ---- -- ---- -- ---- -- ---- ---  ---- ---  ---- ---  
NB.-
NB.-    If no `p` designator is present, 24 hour format is used.
NB.-    To display any of the letters (`dhmscp`) that are codes, 
NB.-    "escape" them with `\`.  
fmtTime=: 3 : 0
  'h:mm:ss pp' fmtTime y
  :
  codes=. TIMECODES
  pic=. x
  'unesc pic'=. '\' escaped pic
  dcp=. 'dcp' e. pic                                     NB. are days, millisecs, am/pm present
  msk=. (>./ (I. -.unesc)} ]) pic i.~ ~.;codes
  pic=. (1 , 2 ~:/\ msk) <;.1 pic                        NB. Cut into tokens
  var=. pic e. codes                                     NB. mark sections as vars
  
  values=. dcp getTimeFormats y % 86400

  res=. <@;"1 (|:(codes i. var#pic){values) (I. var)}"1 pic
  if. 0=#$y do. res=. ,>res else.  res=. ($y)$ res end.
  res
)

NB.*fmtDateTime v Formats combined date and time strings
fmtDateTime=: 3 : 0
  'YYYY/MM/DD hh:mm:sss' fmtDateTime y
:
  codes=. DATECODES,TIMECODES
  pic=. x
  'unesc pic'=. '\' escaped pic
  dcp=. 'dcp' e. pic                                     NB. are days, millisecs, am/pm present
  msk=. (>./ (I. -.unesc)} ]) pic i.~ ~.;codes
  pic=. (1 , 2 ~:/\ msk) <;.1 pic                      NB. Cut into tokens
  var=. pic e. codes                                     NB. mark sections as vars

  values=. getDateFormats y
  values=. values, dcp getTimeFormats y

  res=. <@;"1 (|:(codes i. var#pic){values) (I. var)}"1 pic
  if. 0=#$y do. res=. ,>res else.  res=. ($y)$ res end.
  res
)

NB.*fmtTimeDiff v Formated time difference
NB. y is: time difference in `YYYY MM DD hh mm ss.sss` format
NB. x is: format string
NB. eg: 'Y year\s, M \months DDD days' fmtTimeDiff y
NB. eg: 'D day\s' fmtTimeDiff y
NB. Handle part units for smallest specified unit in format string:
NB. Truncate, round, decimal
NB. How to specify? 
NB.  -additional option to format string eg:
NB.      [format string[;0 or 1 or 2]] fmtTimeDiff y
NB.  -or part of format string
NB.    * decimal: YYY, MMM, DDD, hhh, mmm, sss
NB.    * round (to nearest unit): YY, MM, DD, hh, mm, ss
NB.    * truncate (only complete units): Y, M, D, h, m, s
NB.!! TO DO
