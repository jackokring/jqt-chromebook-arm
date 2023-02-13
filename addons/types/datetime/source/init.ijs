NB. =========================================================
NB.% types/datetime
NB.% Ric Sherlock
NB.% 2009 09 09
NB. Some of the verbs in this script were derived from 
NB. APL+Win functions written by Davin Church.

require 'dates dll strings numeric'

coclass 'rgsdatetime'

NB. =========================================================
NB. Constants

NB.*J0Date n Add to J's day number to get Julian day number
NB.-note: For astronomical use, the start of a [Julian day](http://en.wikipedia.org/wiki/Julian_day)
NB.- is noon. So for an accurate representation of a Julian day/time
NB.- combination 2378496.5 should be added instead.
J0Date=: 2378497

NB.*MS0Date n Add to Microsoft date to get a J day number
NB.-note: The first date supported by Microsoft Excel is 1900 1 1
NB.- but dates between 1900 1 1 and 1900 1 28 will not convert properly
NB.- because Excel incorrectly denotes 1900 as a leap year, 
NB.- <http://support.microsoft.com/kb/214326>
MS0Date=: 36522

NB.*Linux0DateTime n Add to Linux-style date to get a J day number
Linux0DateTime=: 62091

NB. Look ups
WKDAYS=: ;:'Sunday Monday Tuesday Wednesday Thursday Friday Saturday'
MONTHS=: ''; ;:'January February March April May June July August September October November December'
DATECODES=: ;:'D DD DDD DDDD M MM MMM MMMM YY YYYY'
TIMECODES=: ;:'d h hh m mm s ss sss c cc ccc p pp'
