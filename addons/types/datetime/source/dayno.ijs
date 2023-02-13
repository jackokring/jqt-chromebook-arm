NB. =========================================================
NB. Verbs for converting between dates and daynumbers

NB.*toDayNo v Extends verb `todayno` to handle time
NB.-eg: toDayNo 6!:0 ''
NB.-result: Numeric array as J day numbers, decimal part represent time.
NB.-y: Numeric array in date/time format specified by *x*.
NB.-x: Optional boolean specifying input format. Default 0.  
NB.-    0 : date/time format `yyyy mm dd hh mm ss.sss`  
NB.-    1 : date/time format `yyyymmdd.hhmmss.sss`
NB.-note: Dates before `1800 1 1` are not supported.
toDayNo=: 3 : 0
  0 toDayNo y
:
  ymd=. y
  if. x do.                      NB. form <yyyymmdd.hhmmss>
    hms=. 0 100 100 #: 1e_3 round 1e6 * 1||ymd
    ymd=. 0 100 100 #: <.ymd
  else.                          NB. form <yyyy mm dd hh mm ss.sss>
    hms=. 3({."1) 3}."1 ymd
    ymd=. 3{."1 ymd
    hms=. hms + (24 * 1|_1{."1 ymd) (,"1) 0 0  NB. add part day to hours
    ymd=. (* * <.@:|) ymd        NB. truncate part years or months
  end.
  hms=. 86400 %~ 0 60 60 #. hms  NB. to proportion of a day
  dayn=. 0 todayno ymd
  dayn+hms
)

NB.*toDateTime v Extends verb `todate` to handle time
NB.-eg: 1 toDateTime toDayNo 6!:0 ''
NB.-result: Numeric array in date/time format specified by *x*.
NB.-y: Array of J day numbers.
NB.-x: Optional boolean specifying output format. Default 0.  
NB.-   0 : date/time format `yyyy mm dd hh mm ss.sss`  
NB.-   1 : date/time format `yyyymmdd.hhmmss.sss`
NB.-note: Dates before `1800 1 1` are not supported.
toDateTime=: 3 : 0
  0 toDateTime y
:
  dayno=. y
  hms=. 1e_3 round 86400 * 1||dayno NB. get any decimal component
  dayno=. <.|dayno        NB. drop any decimal
  ymd=. x todate dayno    NB. get date component from todate
  if. x do.               NB. yyyymmdd.hhmmsssss
    hms=. 1e_6 * 0 100 100#. 0 60 60#: hms  NB. convert to 0.hhmmsssss
    ymd=. ymd + hms
  else.                   NB. yyyy mm dd hh mm ss.sss
    hms=. 0 60 60 #: hms  NB. convert to hh mm ss.sss
    ymd=. ymd ,"1 hms
  end.
  ymd
)

NB.*toJulian v Converts J day number to Julian day number
NB.-eg: toJulian toDayNo 6!:0 ''
NB.-note: Dates before `1800 1 1` are not supported.  
NB.- Add another 0.5 to get true Julian day number where noon is
NB.- regarded as the *start* of the day.
toJulian=: +&J0Date

NB.*fromJulian v Converts Julian day number to J day number
NB.-eg: fromJulian toJulian toDayNo 6!:0 ''
NB.-note: Dates before `1800 1 1` are not supported.
fromJulian=: -&J0Date
