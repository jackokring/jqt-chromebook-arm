NB. table
align=: '<align>' , ,&'</align>'
bold=: '<bold>' , ,&'</bold>'
col=: '<col>' , ,&'</col>'
color=: '<high>' , ,&'</high>'
data=: '<data>' , ,&'</data>'
gridh=: '<gridh>' , ,&'</gridh>'
gridv=: '<gridv>' , ,&'</gridv>'
row=: '<row>' , ,&'</row>'
top=: '<top>' , ,&'</top>'
quote=: '"' , ,&'" '

PUBPATH=: jpath '~Addons/format/publish/findemo/'

NB. =========================================================
gettable=: 3 : 0
r=. ('get_',y)~''
'<table class=keskey>',r,'</table>',LF
)

NB. =========================================================
NB. 7 x 4
get_tab_1_1_1=: 3 : 0
r=. top '1-45 kV verkko'
r=. r,row '"Johtopituus yhteensä km*",Avojohto,PAS,Ilmakaapelit,Kaapelit,")* josta PJK ja /tai AJK suojattua","Avojohdoista metsässä (%)"'
r=. r,col 'Maaseutu<br/>0-30%,Taajama<br/>30-75%,City<br/>75-100%,"Kaikki yhteensä"'
r=. r,data fread PUBPATH,'data_1_1_1.txt'
r=. r, align '2 2 2 2'
r=. r,bold  ":,1 (2}) 9 5$0
r=. r,color ":,1 (8}) 9 5$0
h=. 1(0 2 3 9)}10$0
r=. r, gridh ": h
)

NB. =========================================================
NB. 6 x 4
get_tab_1_1_2=: 3 : 0
r=. top '1-45 kV verkko'
r=. r,row '"Johtopituus yhteensä km*",Avojohto,PAS,Ilmakaapelit,Kaapelit,")* josta PJK ja /tai AJK suojattua"'
r=. r,col '"Maasta erotettu","Osittain sammutettu",Sammutettu'
r=. r,data fread PUBPATH,'data_1_1_2.txt'
r=. r, align '2 2 2'
r=. r,bold  ":,1 (1}) 7 4$0
h=. 1(0 1 2 7)}8$0
r=. r, gridh ": h
)

NB. =========================================================
NB. 6 x 4
get_tab_1_1_3=: 3 : 0
r=. top '1-45 kV verkko'
r=. r,row '"Käyttöpaikat/kpl", "Energiat/MWh"'
r=. r,col 'Maaseutu<br/>0-30%,Taajama<br/>30-75%,City<br/>75-100%,"Kaikki yhteensä"'
r=. r,data fread PUBPATH,'data_1_1_3.txt'
r=. r, align '2 2 2 2'
)

NB. =========================================================
NB. 3 x 1
get_tab_1_1_4=: 3 : 0
r=. top 'Komponentti'
r=. r,row 'kpl'
r=. r,col 'Jakelumuuntopiirit, "Syöttävät sähköasemat", Johtolähdöt'
r=. r,data fread PUBPATH,'data_1_1_4.txt'
r=. r, align '2'
)

NB. =========================================================
NB. 4 x 1
get_tab_1_2=: 3 : 0
r=. top '400 V verkko'
r=. r,col 'km'
r=. r,row '"Johtopituus yhteensä km", Avojohto, Ilmakaapeli, Maakaapeli'
r=. r,data fread PUBPATH,'data_1_2.txt'
r=. r, align '2'
)

NB. =========================================================
NB. 1 x 5
get_tab_1_3=: 3 : 0
r=. top 'Johtoverkko 1 - 70 kV'
r=. r,col 'Avojohto, Ilmakaapeli, Maakaapeli, Vesistökaap. Yhteensä'
r=. r,row '"Yhteensä *)"'
r=. r,data fread PUBPATH,'data_1_3.txt'
r=. r, align '2'
)

get_tab_1_4=: 3 : 0
r=. top 'Tilastossa mukaan olevat yhtiöt'
r=. r,col ' " "," "'
r=. r,data pread_ppublish_ PUBPATH,'data_1_4.txt'
r, align '0'
)


NB. =========================================================
ROW_2_1_1=: <;._2 (0 : 0)
Oman jakeluverkon vikakeskeytykset
Muun verkon aih. keskeytykset
Pitkät vikakeskeytykset yhteensä
AJK:t
Vikakeskeytykset yhteensä
Suunnitellut keskeytykset
Kaikki ilman jälleenkytkentöjä
Kaikki keskeytykset
)

NB. =========================================================
get_tab_2_1_1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_2_1_1
r=. r, data fread PUBPATH,'data_2_1_1_tab1.txt'
r=. r, color ": _5 {. 1
h=. 1(1 4 6)}10$0
h=. 6(8 9)}h
r=. r, gridh ": h
r=. r, align '2 2 2 2'
)

NB. =========================================================
ROW_2_1_2=: <;._2 (0 : 0)
Oman jakeluverkon vikakeskeytykset
Muun verkon aih. keskeytykset
Pitkät vikakeskeytykset yhteensä
AJK:t
PJK:t
Vikakeskeytykset yhteensä
Suunnitellut keskeytykset
Kaikki ilman jälleenkytkentöjä
Kaikki keskeytykset
)
NB. =========================================================
get_tab_2_1_2=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_2_1_2
r=. r, data ; fread PUBPATH,'data_2_1_2_tab1.txt'
r=. r, color ": _5 {. 1
h=. 1(1 4 7)}11$0
h=. 6(9 10)}h
r=. r, gridh ": h
r=. r, align '2 2 2 2'
)

NB. =========================================================
ROW_2_1_3=: <;._2 (0 : 0)
Oman jakeluverkon vikakeskeytykset
Muun verkon aih. keskeytykset
Vikakeskeytykset yhteensä
Suunnitellut keskeytykset
Kaikki keskeytykset
)
NB. =========================================================
get_tab_2_1_3=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_2_1_3
r=. r, data ; fread PUBPATH,'data_2_1_3_tab1.txt'
r=. r, color ": _5 {. 1
h=. 1(1 4)}7$0
h=. 6 (6)}h
r=. r, gridh ": h
r=. r, align '2 2 2 2'
)

NB. =========================================================
get_tab_2_1_4=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_2_1_2
r=. r, data ; fread PUBPATH,'data_2_1_4_tab1.txt'
r=. r, color ": _5 {. 1
h=. 1(1 4 7)}11$0
h=. 6(9 10)}h
r=. r, gridh ": h
r=. r, align '2 2 2 2'
)


NB. =========================================================
get_tab_2_2_1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_2_1_1
r=. r, data fread PUBPATH,'data_2_2_1_tab1.txt'
r=. r, color ": _5 {. 1
h=. 1(1 4 6)}10$0
h=. 6(8 9)}h
r=. r, gridh ": h
r=. r, align '2 2 2 2'
)

NB. =========================================================
get_tab_2_2_2=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_2_1_2
r=. r, data ; fread PUBPATH,'data_2_2_2_tab1.txt'
r=. r, color ": _5 {. 1
h=. 1(1 4 7)}11$0
h=. 6(9 10)}h
r=. r, gridh ": h
r=. r, align '2 2 2 2'
)


NB. =========================================================
ROW_3_1_1=: <;._2 (0 : 0)
Oman jv:n kesk. yht.
Muut verkot
Vikakesk. yht.
Suunn. kesk. yht.
KAIKKI YHTEENSÄ
)
NB. =========================================================
get_tab_3_1=: 4 : 0
r=. top 'VIKA'
r=. r, col '"0-3 min","3-60 min","1-4 h","4-8 h","8-12 h","12-24 h","1-3 vrk","3-5 vrk","yli 5 vrk"'
r=. r, row ; quote each ROW_3_1_1
r=. r, data ; fread PUBPATH,x
r=. r, color ": _10 {. 1
h=. 7$1
h=. 6 (6)}h
r=. r, gridh ": h
r=. r, align ":9$2
)

get_tab_3_1_1=: 'data_3_1_1_tab1.txt'&get_tab_3_1
get_tab_3_1_2=: 'data_3_1_2_tab1.txt'&get_tab_3_1
get_tab_3_1_3=: 'data_3_1_3_tab1.txt'&get_tab_3_1
get_tab_3_1_4=: 'data_3_1_4_tab1.txt'&get_tab_3_1


NB. =========================================================
ROW_6_1_1=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tekniset syyt yhteensä
Muut syyt yhteensä
Oman verkon vikakeskeytykset
Oman verkon suunnitellut keskeytykset
YHTEENSÄ
)

NB. =========================================================
get_tab_6_1_1=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Avojohto","PAS","Ilmakaapeli","Maakaapeli"'
r=. r, row ; quote each ROW_6_1_1
r=. r, data ; fread PUBPATH,'data_6_1_1_tab1.txt'
r=. r, color ":,1(4 5 6)}7 5$0
h=. 8$1
h=. 6 (7)}h
r=. r, gridh ": h
r=. r, align '2'
)

NB. =========================================================
get_tab_6_1_2=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Sähköasema kpl/asema","Muuntamo kpl/100mp"'
r=. r, row ; quote each ROW_6_1_1
r=. r, data ; fread PUBPATH,'data_6_1_2_tab1.txt'
r=. r, color ":,1(4 5 6)}7 3$0
h=. 8$1
h=. 6 (7)}h
r=. r, gridh ": h
r=. r, align '2'
)

NB. =========================================================
ROW_6_2_1=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tekniset syyt yhteensä
Muut syyt yhteensä
Oman verkon vikakesk.
Oman verkon suunn. kesk.
YHTEENSÄ
)

NB. =========================================================
get_tab_6_2_1=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Avojohto","PAS","Ilmakaapeli","Maakaapeli","Sähköasema","Muuntamo","pj-verkko","as.verkko"'
r=. r, row ; quote each ROW_6_2_1
r=. r, data ; fread PUBPATH,'data_6_2_1_tab1.txt'
r=. r, color ":,1(4 5 6)}7 9$0
h=. 8$1
h=. 6 (7)}h
r=. r, gridh ": h
r=. r, align '2'
)

NB. =========================================================
get_tab_6_2_2=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Avojohto","PAS","Ilmakaapeli","Maakaapeli","Sähköasema","Muuntamo","pj-verkko","as.verkko"'
r=. r, row ; quote each ROW_6_2_1
r=. r, data ; fread PUBPATH,'data_6_2_2_tab1.txt'
r=. r, color ":,1(4 5 6)}7 9$0
h=. 8$1
h=. 6 (7)}h
r=. r, gridh ": h
r=. r, align '2'
)

NB. =========================================================
get_tab_7_1=: 3 : 0
r=. col 'Maaseutu Taajama City'
r=. r,row '"PJK:n selvittämät viat","AJK:n selvittämät viat","Pitkät keskeytykset"'
r=. r,data ; fread PUBPATH,'data_7_1_tab1.txt'
)

NB. =========================================================
get_tab_7_2=: 3 : 0
r=. col 'Maaseutu Taajama City'
r=. r,row 'AJK:t PJK:t'
r=. r,data ; fread PUBPATH,'data_7_2_tab1.txt'
)

NB. =========================================================
get_tab_7_3=: 3 : 0
r=. col 'Maaseutu Taajama City'
r=. r,row 'AJK:t PJK:t'
r=. r,data ; fread PUBPATH,'data_7_3_tab1.txt'
)

NB. =========================================================
get_tab_7_4=: 3 : 0
r=. col 'Maasta<br/>erotettu,Osittain<br/>sammutettu,Sammutettu,yhteensä'
r=. r,row 'AJK:t PJK:t'
r=. r,data ; fread PUBPATH,'data_7_4_tab1.txt'
)

NB. =========================================================
get_tab_8_1=: 3 : 0
r=. col '"alle 20 %","yli 20 %", "Yhteensä"'
r=. r,row 'Vikakeskeytykset "Suunnitellut keskeytykset" Yhteensä'
r=. r,data ; fread PUBPATH,'data_8_1_tab1.txt'
)









NB. =========================================================
ROW_L1_1_1=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tuuli ja myrsky
Lumi- ja jääkuorma
Ukkonen
Muu sää
Eläimet
Tekniset syyt yhteensä
Rakenneviat
Verkonhaltijan toiminta
Muut syyt yhteensä
Ulkopuolinen
Tuntematon
Force Majour
OMAN JAKELUVERKON VIKAKESK. YHT.
Muut verkot
Oma syöttävä verkko
Vieras syöttävä verkko
Asiakkaan verkko
PITKÄT VIKAKESKEYTYKSET YHT.
AJK:t
VIKAKESKEYTYKSET YHT.
Oman verkon työkeskeytys
Syöttävän verkon työkeskeytys
Asiakkaan verkon työkeskeytys
SUUNNITELLUT KESKEYTYKSET YHT.
KAIKKI ILMAN JÄLLEENKYT.
KAIKKI KESKEYTYKSET
)

NB. =========================================================
get_tab_L1_1_1_tab1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_L1_1_1
r=. r, data ; fread PUBPATH,'data_L1_1_1_tab1.txt'
r=. r, color ": _5 {. 1
b=. 1 (0 1 7 10 14 15 19 20 21 25 26 27})  28 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 21 25 26 27}) 28 5$0
r=. r, align '2 2 2 2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 21 22 25 26 27 28)}29$0
h=. 4(20 26 27 28)}h
h=. 6(27 28)}h
r=. r, gridh ": h
)


NB. =========================================================
ROW_L1_1_2=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tuuli ja myrsky
Lumi- ja jääkuorma
Ukkonen
Muu sää
Eläimet
Tekniset syyt yhteensä
Rakenneviat
Verkonhaltijan toiminta
Muut syyt yhteensä
Ulkopuolinen
Tuntematon
Force Majour
OMAN JAKELUVERKON VIKAKESK. YHT.
Muut verkot
Oma syöttävä verkko
Vieras syöttävä verkko
Asiakkaan verkko
PITKÄT VIKAKESKEYTYKSET YHT.
AJK:t
PJK:t
VIKAKESKEYTYKSET YHT.
Oman verkon työkeskeytys
Syöttävän verkon työkeskeytys
Asiakkaan verkon työkeskeytys
SUUNNITELLUT KESKEYTYKSET YHT.
KAIKKI ILMAN JÄLLEENKYT.
KAIKKI KESKEYTYKSET
)

NB. =========================================================
get_tab_L1_1_2_tab1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_L1_1_2
r=. r, data ; fread PUBPATH,'data_L1_1_2_tab1.txt'
b=. 1 (0 1 7 10 14 15 19 20 22 26 27 28})  29 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 22 26 27 28}) 29 5$0
r=. r, align '2 2 2 2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 22 23 26 27 28 29)}30$0
h=. 4(19 22 27 28 29)}h
h=. 6(28 29)}h
r=. r, gridh ": h
)


NB. =========================================================
ROW_L1_1_3=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tuuli ja myrsky
Lumi- ja jääkuorma
Ukkonen
Muu sää
Eläimet
Tekniset syyt yhteensä
Rakenneviat
Verkonhaltijan toiminta
Muut syyt yhteensä
Ulkopuolinen
Tuntematon
Force Majour
OMAN JAKELUVERKON VIKAKESK. YHT.
Muut verkot
Oma syöttävä verkko
Vieras syöttävä verkko
Asiakkaan verkko
VIKAKESKEYTYKSET YHT.
Oman verkon työkeskeytys
Syöttävän verkon työkeskeytys
Asiakkaan verkon työkeskeytys
SUUNNITELLUT KESKEYTYKSET YHT.
KAIKKI KESKEYTYKSET
)
NB. =========================================================
get_tab_L1_1_3_tab1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_L1_1_3
r=. r, data ; fread PUBPATH,'data_L1_1_3_tab1.txt'
r=. r, color ": _5 {. 1
b=. 1 (0 1 7 10 14 15 19 23 24})  25 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 23 24}) 25 5$0
r=. r, align '2 2 2 2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 25)}26$0
h=. 4(20 24)}h
h=. 6(25)}h
r=. r, gridh ": h
)

NB. =========================================================
get_tab_L1_1_4_tab1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_L1_1_2
r=. r, data ; fread PUBPATH,'data_L1_1_4_tab1.txt'
b=. 1 (0 1 7 10 14 15 19 20 22 26 27 28})  29 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 22 26 27 28}) 29 5$0
r=. r, align '2 2 2 2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 22 23 26 27 28 29)}30$0
h=. 4(19 22 27 28 29)}h
h=. 6(28 29)}h
r=. r, gridh ": h
)

NB. =========================================================
get_tab_L1_2_1_tab1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_L1_1_1
r=. r, data ; fread PUBPATH,'data_L1_2_1_tab1.txt'
r=. r, color ": _5 {. 1
b=. 1 (0 1 7 10 14 15 19 20 21 25 26 27})  28 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 21 25 26 27}) 28 5$0
r=. r, align '2 2 2 2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 21 22 25 26 27 28)}29$0
h=. 4(20 26 27 28)}h
h=. 6(27 28)}h
r=. r, gridh ": h
)

NB. =========================================================
get_tab_L1_2_2_tab1=: 3 : 0
r=. top 'Keskeytyslaji'
r=. r, col 'Maaseutu Taajama City "Kaikki yhteensä"'
r=. r, row ; quote each ROW_L1_1_2
r=. r, data ; fread PUBPATH,'data_L1_2_2_tab1.txt'
b=. 1 (0 1 7 10 14 15 19 20 22 26 27 28})  29 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 22 26 27 28}) 29 5$0
r=. r, align '2 2 2 2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 22 23 26 27 28 29)}30$0
h=. 4(19 22 27 28 29)}h
h=. 6(28 29)}h
r=. r, gridh ": h
)

NB. =========================================================
ROW_L2_1_1=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tuuli ja myrsky
Lumi- ja jääkuorma
Ukkonen
Muu sää
Eläimet
Tekniset syyt yht.
Rakenneviat
Verkonhalt. toiminta
Muut syyt yhteensä
Ulkopuolinen
Tuntematon
Force Majour
OMAN JV VIKAK. YHT.
Muut verkot
Oma syöttävä verkko
Vieras syöttävä verkko
Asiakkaan verkko
VIKAKESK. YHT.
Oman verk. työkesk.
Syöttävän verk. työk.
Asiakkaan verk. työk.
SUUNN. KESK. YHT.
KAIKKI KESKEYTYKSET
)
NB. =========================================================
get_tab_L2_1=: 4 : 0
r=. top 'VIKA'
r=. r, col '"0-3 min","3-60 min","1-4 h","4-8 h","8-12 h","12-24 h","1-3 vrk","3-5 vrk","yli 5 vrk"'
r=. r, row ; quote each ROW_L2_1_1
r=. r, data ; fread PUBPATH,x
b=. 1 (0 1 7 10 14 15 19 23 24})  25 10$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 19 23 24}) 25 10$0
r=. r, align '2'
h=. 1(1 2 7 8 10 11 14 15 16 19 20 23 24 25)}26$0
h=. 4(24)}h
h=. 6(25)}h
r=. r, gridh ": h
)

get_tab_L2_1_1_tab1=: 'data_L2_1_1_tab1.txt'&get_tab_L2_1
get_tab_L2_1_2_tab1=: 'data_L2_1_2_tab1.txt'&get_tab_L2_1
get_tab_L2_1_3_tab1=: 'data_L2_1_3_tab1.txt'&get_tab_L2_1


NB. =========================================================
ROW_L4_1_1=: <;._2 (0 : 0)
Luonnonilmiöt yhteensä
Tuuli ja myrsky
Lumi- ja jääkuorma
Ukkonen
Muu sää
Eläimet
Tekniset syyt yht.
Rakenneviat
Verkonhalt. toiminta
Muut syyt yhteensä
Ulkopuolinen
Tuntematon
Force Major
OMAN JV VIKAK. YHT.
OMAN JV SUUNN. YHT.
YHTEENSÄ
)

NB. =========================================================
get_tab_L4_1_1_tab1=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Avojohto","PAS","Ilmakaapeli","Maakaapeli"'
r=. r, row ; quote each ROW_L4_1_1
r=. r, data ; fread PUBPATH,'data_L4_1_1_tab1.txt'
b=. 1 (0 1 7 10 14 15 16 })  17 5$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 15 16}) 17 5$0
r=. r, align '2'
h=. 1(1 2 7 8 10 11 14 15 16 17})18$0
h=. 6(17)}h
r=. r, gridh ": ,h
r
)

NB. =========================================================
get_tab_L4_1_2_tab1=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Sähköasema kpl/asema","Muuntamo kpl/100mp"'
r=. r, row ; quote each ROW_L4_1_1
r=. r, data ; fread PUBPATH,'data_L4_1_2_tab1.txt'
b=. 1 (0 1 7 10 14 15 16 })  17 3$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 15 16}) 17 3$0
r=. r, align '2'
h=. 1(1 2 7 8 10 11 14 15 16 17})18$0
h=. 6(17)}h
r=. r, gridh ": ,h
r
)

NB. =========================================================
get_tab_L4_2_1_tab1=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Avojohto","PAS","Ilmakaapeli","Maakaapeli","Sähköasema","Muuntamo","pj-verkko"'
r=. r, row ; quote each ROW_L4_1_1
r=. r, data ; fread PUBPATH,'data_L4_2_1_tab1.txt'
b=. 1 (0 1 7 10 14 15 16})17 8$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 15 16}) 17 8$0
r=. r, align '2'
h=. 1(1 2 7 8 10 11 14 15 16 17})18$0
h=. 6(17)}h
r=. r, gridh ": ,h
r
)

NB. =========================================================
get_tab_L4_2_2_tab1=: 3 : 0
r=. top 'VIKA'
r=. r, col '"Avojohto","PAS","Ilmakaapeli","Maakaapeli","Sähköasema","Muuntamo","pj-verkko"'
r=. r, row ; quote each ROW_L4_1_1
r=. r, data ; fread PUBPATH,'data_L4_2_2_tab1.txt'
b=. 1 (0 1 7 10 14 15 16})17 8$0
r=. r,bold  ":,b
r=. r,color  ":, 1 (14 15 16}) 17 8$0
r=. r, align '2'
h=. 1(1 2 7 8 10 11 14 15 16 17})18$0
h=. 6(17)}h
r=. r, gridh ": ,h
r
)
