NB.  This add-on will select appropriate version of J and check for appropriate environment

3 : 0 ''
if. IFJHS do. echo 'jig is only supported on jQt IDE at this time' return. end.
VE=.(804 < 0 ". _3 {. 0 {:: [: <;._2 '/',~ 0 {:: <;._2) JVERSION,LF  NB.to determine if Jversion is later than j804
Version=. VE{:: ('   You need to upgrade to at least J805.',LF,'   Please, see the following instructions:',LF,'   http://code.jsoftware.com/wiki/System/Installation');'' 
QT=. ('s'~: _1 {. 0 {:: [: <;._2 '/',~ 3 {:: <;._2) JVERSION,LF  NB.to determine if full build  Qt IDE: 1.5.3s/5.6.2 if slim build
jqt=.QT{:: (LF,'   You need to install the full version of jqt.',LF,'   To update your system, see the following instructions:',LF,'   http://code.jsoftware.com/wiki/Guides/Qt_IDE/Install#Slim_vs_Full_Builds');'' 
PM=. fexist '~addons/debug/jig/jig.ijs'
Jig=.PM{:: (LF,'   You need to install the Jig addon.',LF,'   To use Package Manager to download the Jig add on, see the following instructions:',LF,'   http://code.jsoftware.com/wiki/JAL/Package_Manager#Using_Package_Manager');'' 
Please=.(*./VE,QT,PM){::(LF,'   Please, address the issue(s) to use jig.');'   Please, enjoy using jig.',LF,'   There is a lab, if you would like further instruction. Help | Studio | Labs... | jig Augmented Display'
echo LF,Version,jqt,Jig,Please,LF

select. t=.4 {. 9!:14 ''
case. 'j903';'j904' do. load '~addons/debug/jig/jig903.ijs'
case. 'j901';'j902' do. load '~addons/debug/jig/jig900.ijs'
case. 'j805';'j806';'j807' do. load '~addons/debug/jig/jig800.ijs' 
case.        do. echo 'jig only supported for j805, j806, j807, j901, j902 and j903.' end.
)
