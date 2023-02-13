NB. =========================================================
NB. Verbs for working with time zones
require 'dll'

NB.*getTimeZoneInfo v function to return Windows time zone info
NB.-eg: getTimeZoneInfo ''
NB.-result: 3-item list of boxed info:  
NB.-   0{:: Daylight saving status (0 unknown, 1 standarddate, 2 daylightdate)  
NB.-   1{:: Bias (offset of local zone from UTC in minutes)  
NB.-   2{:: 2 by 3 boxed table: Standard,Daylight by Name,StartDate,Bias
getTimeZoneInfo=: 3 : 0
  'tzstatus tzinfo'=. 'kernel32 GetTimeZoneInformation i *i'&cd <(,43#0)
  NB. read TIME_ZONE_INFORMATION structure
  tzinfo=. (1 (<:+/\ 1 16 4 1 16 4 1)}43#0) <;.2 tzinfo    NB. 4 byte J integers
  tzbias=. 0{:: tzinfo
  tzinfo=. _3]\ }. tzinfo                  NB. Standard info ,: Daylight info
  'name date bias'=. i. 3                  NB. column labels for tzinfo
  tmp=. (6&u:)@(2&ic)&.> name {"1 tzinfo   NB. read names as unicode text
  tmp=. (0{a.)&taketo&.> tmp               NB. take to first NUL
  tzinfo=. tmp (<a:;name)}tzinfo           NB. amend TZ names
  tmp=. _1&ic@(2&ic)&.> date{"1 tzinfo     NB. read SYSTEMTIME structures
  tzinfo=. tmp (<a:;date)}tzinfo           NB. amend TZ dates

  tzstatus;tzbias;<tzinfo
)
