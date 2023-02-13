NB. plot
NB.
NB. functions in this script build plot files that
NB. can be referenced in <image></image> tags. The file
NB. extension is *.jpf. Use normal pd commands to build
NB. the plot, and then pd 'jpf {filename} {size}' to write
NB. the plot file. Size is the width,height in points.
NB. For example:
NB.
NB.   pd 'reset'
NB.   pd 'type bar'
NB.   pd 2 3 5 7
NB.   pd 'jpf c:\demo\plot71.jpf 300 150'
NB.
NB. Note: in the demo, this script is not loaded when
NB. the report is built. It is assumed that the script
NB. has already been run.
NB.
NB. set PUBPATH as appropriate

PUBPATH=: jpath '~Addons/format/publish/findemo/'
PIECOLORS=: 'color red,blue,green,yellow,teal,brown,cyan,gray, jade, HotPink'

fmtc=: 3 : 0
($r)$',' (I. (,r) e. '.')} ,r=. ": y
:
($r)$',' (I. (,r) e. '.')} ,r=. x ": y
)

freadnum=: 3 : '". CRLF -.~ fread y'

NB. =========================================================
SBARSTYLE=: 0 : 0
reset
type sbarv
barwidth 0.5
captionfont arial 11
framebackcolor silver
gridcolor black
gridpattern 1
grids 1
keypos rmo
keystyle b
ticmajor 4
ticminor 3
)

NB. =========================================================
plot_2_1_1_pic1=: 3 : 0
pd SBARSTYLE
pd 'ycaption tuntia'
key=. ' "Muut syyt yhteensä" "Tekniset syyt" "Luonnon ilmiöt" '
pd 'key ',key
pd 'title Keskeytysajan aiheuttajat<br/>(jälleenkytkennät ei mukana)'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'yrange 0 4'
pd 'yticpos ',": 0.5 * i.9
pd 'xlabel Maaseutu Taajama City Yhteensä'
dat=. |. 3 4$0 (I. d e. __)} d=.freadnum PUBPATH,'data_2_1_1_pic1.txt'
pd dat
f=. PUBPATH,'plot_2_1_1_pic1.jpf'
pd 'jpf ',f,' 400 200'
)

NB. =========================================================
plot_2_1_2_pic1=: 3 : 0
pd SBARSTYLE
pd 'ycaption kpl'
key=. ' "Muut syyt yhteensä" "Tekniset syyt" "Luonnon ilmiöt" '
pd 'key ',key
pd 'title Keskeytysmäärän aiheuttajat<br/>(jälleenkytkennät ei mukana)'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'yrange 0 5'
pd 'yticpos ',": 0.5 * i.11
pd 'xlabel Maaseutu Taajama City Yhteensä'
dat=. |. 3 4$0 (I. d e. __)} d=.freadnum PUBPATH,'data_2_1_2_pic1.txt'
pd dat
f=. PUBPATH,'plot_2_1_2_pic1.jpf'
pd 'jpf ',f,' 400 200'
)

NB. =========================================================
KEY_2_1_1=: <;._2 (0 : 0)
Tuuli ja myrsky
Lumi- ja jääkuorma
Ukkonen
Muu sää
Eläimet
Rakenne- ja käyttövirhe
Tuntematon
Ulkopuoliset
Suunnitellut
)

NB. =========================================================
plot_2_1_1_pic2=: 3 : 0
dat=. freadnum PUBPATH,'data_2_1_1_pic2.txt'
key=. KEY_2_1_1 ,each ' ' ,each (":each dat) ,each <'%'
key=. ;'"',each key ,each <'" '
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Keskeytysajan aiheuttajat<br/>(kaikki verkot, jälleenkytkennät ei mukana)'
pd 'keypos rmo;keystyle bf;keyfont arial 12'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'key ', key
pd dat
f=. PUBPATH,'plot_2_1_1_pic2.jpf'
pd 'jpf ',f,' 400 250'
)

NB. =========================================================
plot_2_1_2_pic2=: 3 : 0
dat=. freadnum PUBPATH,'data_2_1_2_pic2.txt'
key=. KEY_2_1_1 ,each ' ' ,each (":each dat) ,each <'%'
key=. ;'"',each key ,each <'" '
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Keskeytysmäärien osuudet aiheuttajittain<br/>(jälleenkytkennät ei mukana)'
pd 'titlefont arial 12'
pd 'labelfont arial 12'
pd 'keypos rmo;keystyle bf;keyfont arial 12'
pd 'key ', key
pd dat
f=. PUBPATH,'plot_2_1_2_pic2.jpf'
pd 'jpf ',f,' 400 250'
)

NB. =========================================================
plot_2_1_2_pic3=: 3 : 0
dat=. freadnum PUBPATH,'data_2_1_2_pic3.txt'
key=. ('PJK:n selvittämät viat';'AJK:n selvittämät viat';'Pitkät keskeytykset') ,each ' ' ,each (":each dat) ,each <'%'
key=. ;'"',each key ,each <'" '
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Keskeytysmäärän jakauma'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'keypos rmo;keystyle bf;keyfont arial 12'
pd 'key ', key
pd dat
f=. PUBPATH,'plot_2_1_2_pic3.jpf'
pd 'jpf ',f,' 250 100'
)

NB. =========================================================
plot_2_1_4_pic2=: 3 : 0
dat=. freadnum PUBPATH,'data_2_1_4_pic2.txt'
key=. KEY_2_1_1 ,each ' ' ,each (":each dat) ,each <'%'
key=. ;'"',each key ,each <'" '
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Keskeytykseen johtaneiden vikojen aiheuttajat'
pd 'titlefont arial 12'
pd 'labelfont arial 12'
pd 'keypos rmo;keystyle bf;keyfont arial 12'
pd 'key ', key
pd dat
f=. PUBPATH,'plot_2_1_4_pic2.jpf'
pd 'jpf ',f,' 400 250'
)

NB. =========================================================
plot_2_2_1_pic1=: 3 : 0
pd SBARSTYLE
pd 'ycaption tuntia'
key=. ' "Muut syyt yhteensä" "Tekniset syyt" "Luonnon ilmiöt" '
pd 'key ',key
pd 'title Keskeytysajan aiheuttajat<br/>(jälleenkytkennät ei mukana)'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'yrange 0 4'
pd 'yticpos ',": 0.5 * i.9
pd 'xlabel Maaseutu Taajama City Yhteensä'
dat=. |. 3 4$0 (I. d e. __)} d=.freadnum PUBPATH,'data_2_2_1_pic1.txt'
pd dat
f=. PUBPATH,'plot_2_2_1_pic1.jpf'
pd 'jpf ',f,' 400 200'
)

NB. =========================================================
plot_2_2_2_pic1=: 3 : 0
pd SBARSTYLE
pd 'ycaption kpl'
key=. ' "Muut syyt yhteensä" "Tekniset syyt" "Luonnon ilmiöt" '
pd 'key ',key
pd 'title Keskeytysmäärän aiheuttajat<br/>(jälleenkytkennät ei mukana)'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'yrange 0 5'
pd 'yticpos ',": 0.5 * i.11
pd 'xlabel Maaseutu Taajama City Yhteensä'
dat=. |. 3 4$0 (I. d e. __)} d=.freadnum PUBPATH,'data_2_2_2_pic1.txt'
pd dat
f=. PUBPATH,'plot_2_2_2_pic1.jpf'
pd 'jpf ',f,' 400 200'
)

NB. =========================================================
BARSTYLE=: 0 : 0
reset
type bar
barwidth 0.5
captionfont arial 11
framebackcolor white
gridcolor black
gridpattern 1
grids 1
keypos rmo
keystyle b
ticmajor 4
ticminor 3
)
NB. =========================================================
plot_3_1_1_pic1=: 3 : 0
pd BARSTYLE
pd 'ycaption kpl/a'
key=. '"Maaseutu" "Taajama" "City"'
pd 'key ',key
pd 'keypos right top inside'
pd 'title Keskeytysmäärän aikajakauma asiakkaalla vuodessa kpl/a<br/>(ei jälleenkytkentöjä)'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'yrange 0 2.5'
pd 'yticpos ',": 0.5 * i.6
pd 'xlabel "0-3 min","3-60 min","1-4  h","4-8 h","8-12 h","12-24 h","1-3 vrk","3-5 vrk","yli 5 vrk"'
dat=. 3 9$0 (I. d e. __)} d=.freadnum PUBPATH,'data_3_1_1_pic1.txt'
pd dat
f=. PUBPATH,'plot_3_1_1_pic1.jpf'
pd 'jpf ',f,' 500 200'
)

NB. =========================================================
plot_4_1_pic1=: 3 : 0
pd 'reset'
pd 'type dot'
pd 'pensize 2'
pd 'backcolor white'
pd 'ycaption yhtiön kokonaiskaapelointiaste'
pd 'yrange 0 100'
pd 'xcaption keskeytysaika h/a'
d=.>". each <;._2    freads PUBPATH,'data_4_1_pic1.txt'
dat=.<"1 |:(-. +./"1 d e. __)#d
pd dat
f=. PUBPATH,'plot_4_1_pic1.jpf'
pd 'jpf ',f,' 500 190'
)

NB. =========================================================
plot_4_2_pic1=: 3 : 0
pd 'reset'
pd 'type dot'
pd 'pensize 2'
pd 'backcolor white'
pd 'ycaption yhtiön kokonaiskaapelointiaste'
pd 'yrange 0 100'
pd 'xcaption keskeytysmäärä kpl/a'
d=.>". each <;._2    freads PUBPATH,'data_4_2_pic1.txt'
dat=.<"1 |:(-. +./"1 d e. __)#d
pd dat
f=. PUBPATH,'plot_4_2_pic1.jpf'
pd 'jpf ',f,' 500 190'
)

NB. =========================================================
plot_4_3_pic1=: 3 : 0
pd 'reset'
pd 'type stick'
pd 'backcolor white'
pd 'color black'
pd 'ycaption kpl/100 km'
NB. pd 'yrange 0 100'
pd 'xcaption 1.1. ... 31.12.'
dat=.0 (I. d e. __)} d=.freadnum PUBPATH,'data_4_3_pic1.txt'
pd dat
f=. PUBPATH,'plot_4_3_pic1.jpf'
pd 'jpf ',f,' 500 190'
)

NB. =========================================================
plot_5_1_1_pic1=: 3 : 0
pd 'reset'
key=. '"Maaseutu 2005-" "Taajama 2005-" "City 2005-" "Maaseutu 1973-2004" "Taajama 1973-2004"'
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption kpl/100 km'
pd 'yrange 0 25'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_5_1_1_pic1.txt'
dat=.<"1 |:0 3 {"1 (-. (3{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 4 {"1 (-. (4{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 5 {"1 (-. (5{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
pd dat
f=. PUBPATH,'plot_5_1_1_pic1.jpf'
pd 'jpf ',f,' 500 180'
)

NB. =========================================================
plot_5_1_2_pic1=: 3 : 0
pd 'reset'
key=. '"Maaseutu 2005-" "Taajama 2005-" "City 2005-" "Maaseutu 1973-2004" "Taajama 1973-2004"'
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption kpl/100 km'
pd 'yrange 0 25'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_5_1_2_pic1.txt'
dat=.<"1 |:0 3 {"1 (-. (3{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 4 {"1 (-. (4{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 5 {"1 (-. (5{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
pd dat
f=. PUBPATH,'plot_5_1_2_pic1.jpf'
pd 'jpf ',f,' 500 180'
)

NB. =========================================================
plot_5_1_3_pic1=: 3 : 0
pd 'reset'
key=. '"Maaseutu 2005-" "Taajama 2005-" "City 2005-"'
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption kpl/100 km'
pd 'yrange 0 25'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_5_1_3_pic1.txt'
dat=.<"1 |:0 3 {"1 (-. (3{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 4 {"1 (-. (4{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 5 {"1 (-. (5{"1 d) e. __)#d
pd dat
NB. dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
NB. pd dat
NB. dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
NB. pd dat
f=. PUBPATH,'plot_5_1_3_pic1.jpf'
pd 'jpf ',f,' 500 180'
NB. pd 'show'
)

NB. =========================================================
plot_5_2_1_pic1=: 3 : 0
pd 'reset'
key=. '"Maaseutu 2005-" "Taajama 2005-" "City 2005-" "Maaseutu 1973-2004" "Taajama 1973-2004"'
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption h/a'
pd 'yrange 0 10'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_5_2_1_pic1.txt'
dat=.<"1 |:0 3 {"1 (-. (3{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 4 {"1 (-. (4{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 5 {"1 (-. (5{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
pd dat
f=. PUBPATH,'plot_5_2_1_pic1.jpf'
pd 'jpf ',f,' 500 190'
)

NB. =========================================================
plot_5_2_2_pic1=: 3 : 0
pd 'reset'
key=. '"Maaseutu 2005-" "Taajama 2005-" "City 2005-"'
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption h/a'
pd 'yrange 0 10'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_5_2_2_pic1.txt'
NB. dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
NB. pd dat
NB. dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
NB. pd dat
dat=.<"1 |:0 3 {"1 (-. (3{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 4 {"1 (-. (4{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 5 {"1 (-. (5{"1 d) e. __)#d
pd dat
f=. PUBPATH,'plot_5_2_2_pic1.jpf'
pd 'jpf ',f,' 500 190'
)

NB. =========================================================
plot_6_1_1_pic1=: 3 : 0
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'captionfont arial 12 bold'
pd 'labelfont arial 12;keyfont arial 12'
pd 'ycaption Avojohto PAS Ilmakaapeli Maakaapeli'
pd 'key Luonnonilmiöt "Tekniset syyt" "Ulkopuoliset syyt" "Suunnitellut keskeytykset"'
pd 'keypos rmo;keystyle bf'
dat=. |:4 4$0 (I. d e. __)} d=.freadnum PUBPATH,'data_6_1_1_pic1.txt'
pd dat
f=. PUBPATH,'plot_6_1_1_pic1.jpf'
pd 'jpf ',f,' 475 125'
)

NB. =========================================================
plot_6_1_2_pic1=: 3 : 0
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'captionfont arial 12 bold'
pd 'labelfont arial 12;keyfont arial 12'
pd 'key Luonnonilmiöt "Tekniset syyt" "Ulkopuoliset syyt" "Suunnitellut keskeytykset"'
pd 'keypos rmo;keystyle bf'
dat=. |:4 2$0 (I. d e. __)} d=.freadnum PUBPATH,'data_6_1_2_pic1.txt'
pd dat
f=. PUBPATH,'plot_6_1_2_pic1.jpf'
pd 'jpf ',f,' 475 125'
)

NB. =========================================================
KEY_6_2_1=: <;._2 (0 : 0)
Avojohto
PAS
Ilmakaapeli
Maakaapeli
Sähköasema
Muuntamo
Pj-verkko
Asiakasverkko
)
NB. =========================================================
plot_6_2_1_pic1=: 3 : 0
dat=. <.0.5+100*(%+/d)*d=.freadnum PUBPATH,'data_6_2_1_pic1.txt'
key=. KEY_6_2_1 ,each ' ' ,each (":each dat) ,each <'%'
key=. ;'"',each key ,each <'" '
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Keskeytysajan jakauma vian sijainnin perusteella'
pd 'keypos rmo;keystyle bf;keyfont arial 12'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'key ', key
pd dat
f=. PUBPATH,'plot_6_2_1_pic1.jpf'
pd 'jpf ',f,' 400 250'
)

NB. =========================================================
plot_6_2_1_pic2=: 3 : 0
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Eri verkon osien keskeytyksien aiheuttajat keskeytysajan suhteen'
pd 'captionfont arial 12 bold'
pd 'labelfont arial 12;keyfont arial 12'
pd 'ycaption Avojohto PAS Ilmakaapeli Maakaapeli Sähköasema Muuntamo Pj-verkko Asiakasverkko'
pd 'key Luonnonilmiöt "Tekniset syyt" "Ulkopuoliset syyt" "Suunnitellut keskeytykset"'
pd 'keypos rmo;keystyle bf'
dat=. |:4 8$0 (I. d e. __)} d=.freadnum PUBPATH,'data_6_2_1_pic2.txt'
pd dat
f=. PUBPATH,'plot_6_2_1_pic2.jpf'
pd 'jpf ',f,' 500 250'
)


NB. =========================================================
plot_6_2_2_pic1=: 3 : 0
dat=. <.0.5+100*(%+/d)*d=.freadnum PUBPATH,'data_6_2_2_pic1.txt'
key=. KEY_6_2_1 ,each ' ' ,each (":each dat) ,each <'%'
key=. ;'"',each key ,each <'" '
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Keskeytysmäärän jakauma vian sijainnin perusteella'
pd 'keypos rmo;keystyle bf;keyfont arial 12'
pd 'titlefont arial 12'
pd 'labelfont arial 12;keyfont arial 12'
pd 'key ', key
pd dat
f=. PUBPATH,'plot_6_2_2_pic1.jpf'
pd 'jpf ',f,' 400 250'
)

NB. =========================================================
plot_6_2_2_pic2=: 3 : 0
pd 'reset'
pd 'type pie'
pd 'piepercent 1'
pd 'title Eri verkon osien keskeytyksien aiheuttajat keskeytysmäärän suhteen'
pd 'captionfont arial 12 bold'
pd 'labelfont arial 12;keyfont arial 12'
pd 'ycaption Avojohto PAS Ilmakaapeli Maakaapeli Sähköasema Muuntamo Pj-verkko Asiakasverkko'
pd 'key Luonnonilmiöt "Tekniset syyt" "Ulkopuoliset syyt" "Suunnitellut keskeytykset"'
pd 'keypos rmo;keystyle bf'
dat=. |:4 8$0 (I. d e. __)} d=.freadnum PUBPATH,'data_6_2_2_pic2.txt'
pd dat
f=. PUBPATH,'plot_6_2_2_pic2.jpf'
pd 'jpf ',f,' 475 250'
)

NB. =========================================================
plot_7_1_pic1=: 3 : 0
dat=. |.0.01 * _3 [\ freadnum PUBPATH,'data_7_1_pic1.txt'
key=. '"Pitkät keskeytykset" "AJK:n selvittämät viat" "PJK:n selvittämät viat"'
pd SBARSTYLE
pd 'grids 0'
pd 'keypos rmo;keystyle b'
pd 'labelfont arial 12;keyfont arial 12'
pd 'key ',key
pd 'framebackcolor silver'
pd 'color 255 255 204,153 51 102,153 153 255 '
pd 'xlabel Maaseutu Taajama City'
pd 'yticpos ',": 0.1 * i.11
pd 'ylabel ', ;(": each 10*i.11) ,each <'% '
pd dat
f=. PUBPATH,'plot_7_1_pic1.jpf'
pd 'jpf ',f,' 400 200'
)

NB. =========================================================
plot_L3_1_pic1=: 3 : 0
pd 'reset'
pd 'title Asiakkaiden keskimääräinen häiriökeskeytysaika (h/a) vuosina 1973...2005'
pd 'titlefont arial 12'
key=. '"Maaseutu" "Taajamat" '
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption h/a'
pd 'yrange 0 15'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_L3_1_pic1.txt'
dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
pd dat
f=. PUBPATH,'plot_L3_1_pic1.jpf'
pd 'jpf ',f,' 500 200'
)

NB. =========================================================
plot_L3_2_pic1=: 3 : 0
pd 'reset'
pd 'title Keskeytyksistä asiakkaille aiheutunut sähkötön aika (h/a) vuosina 1973...2003'
pd 'titlefont arial 12'
key=. '"Maaseutu" "Taajamat" '
pd 'key ',key
pd 'keypos center bottom outside'
pd 'keystyle left boxed horizontal fat'
pd 'type line'
pd 'backcolor white'
pd 'ycaption h/a'
pd 'yrange 0 15'
pd 'xrange 1970 2010'
pd 'xcaption vuosi'
pd 'pensize 2'
d=.>". each <;._2    freads PUBPATH,'data_L3_2_pic1.txt'
dat=.<"1 |:0 1{"1 (-. (1{"1 d) e. __)#d
pd dat
dat=.<"1 |:0 2{"1 (-. (2{"1 d) e. __)#d
pd dat
f=. PUBPATH,'plot_L3_2_pic1.jpf'
pd 'jpf ',f,' 500 200'
)


NB. =========================================================
plot_2_1_1_pic1''
plot_2_1_1_pic2''
plot_2_1_2_pic1''
plot_2_1_2_pic2''
plot_2_1_2_pic3''
plot_2_1_4_pic2''
plot_2_2_1_pic1''
plot_2_2_2_pic1''
plot_3_1_1_pic1''
plot_4_1_pic1''
plot_4_2_pic1''
plot_5_1_1_pic1''
plot_5_1_2_pic1''
plot_5_1_3_pic1''
plot_5_2_1_pic1''
plot_5_2_2_pic1''
plot_6_1_1_pic1''
plot_6_1_2_pic1''
plot_6_2_1_pic1''
plot_6_2_1_pic2''
plot_6_2_2_pic1''
plot_6_2_2_pic2''
plot_L3_1_pic1''
plot_L3_2_pic1''
plot_7_1_pic1''
