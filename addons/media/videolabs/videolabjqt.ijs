NB. multimedia lab viewer for jqt platform - video processes (even when closed) remain until jqt has exited. 
coclass 'video'

NB. === form description
MULTIMEDIA=: 0 : 0
pc multimedia;
pcenter;
bin h;
bin vs;
cc SI static;cn "Size";set _ tooltip "Available Display Sizes";
maxwh 20 20;cc s radiobutton;cn "";set _ tooltip "Extra small screen size - 400 X 225";set _ wh 20 20;
maxwh 20 20;cc m radiobutton group;cn "";set _ tooltip "Medium screen size - 800 X 450";set _ wh 20 20;
maxwh 20 20;cc l radiobutton group;cn "";set _ tooltip "Large screen size - 1600 X 900";set _ wh 20 20;
bin sz;
cc mm webview;set mm sizepolicy expanding;
bin z;
)

NB. === button controls
multimedia_s_button=: 3 : 'init 0'
multimedia_m_button=: 3 : 'init 1'
multimedia_l_button=: 3 : 'init 2'

NB. === close button 
multimedia_close=: 3 : 0
if. wdisparent 'multimedia' do. 
                         wd 'psel ',QThandle,';'
                         wd 'pshow hide;' end. NB. Select video form,  hide so there is not a new ghost window 
)
ScreenD=: 400 225;800 450;1600 900  NB. screen dimension defaults
QThandle=: 1 NB. set to trigger initialization on first display

NB. === initializing verb triggered from first display with '' argument or from multimedia size buttons with 1,2,3
init =: 3 : 0
 if.y-:'' do. VM=. _300 + 2 { ". wd 'qscreen' NB. establish screen width with 300 px allowance    
              'SS MS LS'=:  ": each VM>400 800 1600
              'WM HM'=:>(VM=.<: 2<.+/VM) { ScreenD NB. set medium size as default if possible
         else.'WM HM'=:> (VM =. y){ ScreenD NB. sets viewmode to size called from size buttons
               wd 'psel ', QThandle ,'; pclose;' NB. gets rid of previous window for size change
         end. 
 wd MULTIMEDIA NB. opens new video form at the beginning of lab or when size changes
 QThandle=: wd 'qhwndp'  NB. Establishes handle for the video window
 wd 'setp wh ',":80 60 + WM , HM
 wd 'set s visible ',SS,';set m visible ',MS,';set l visible ',LS,';' NB. only displays allowable size buttons
 wd 'set ',(VM{'sml'),' value 1;'     NB. sets size button as selected
if. -. y -: '' do. play VIDEO end. NB. when resizing don't forget to reload the current video
i. 0 0
)

NB. === verb used to show video if new or resized - y argument is youtube code for video, x is start [stop] if they exist

display=: 3 : 0
'' display y
:
 if. (2 = 3!:0  > x)*.(L. x) do. x =. ((24 60 60 {.~ #) #. ])@: (,@:(". ;. _1))"1 >  ':', each x end. NB. convert 'hh:mm:ss' to seconds
 if. -.x-:''do. 'start stop'=.x
            if. start-:stop do. insert=.'?start=',(": start),'&' 
                            else. insert=.'?start=',(": start),'&end=',(": stop),'&' end.
            else. insert=.'?' end.
 play 'https://www.youtube.com/embed/',y,insert,'feature=oembed;rel=0&amp;'
)

NB. === verb used to play video given the youtube url

play=: 3 : 0
 VIDEO=:embed y  NB. creates VIDEO address in embedded form
 try. wd 'psel ', QThandle catch. init ''[ erase < 'QThandle' end. NB. if the window doesn't exist then create it
 wd 'set mm html <iframe width="',(":WM) ,'" height="',(":HM) ,'" src="',VIDEO,'"></iframe>;set mm visible;set mm minwh ',(":WM , HM),' ;'
 wd 'pshow;'
)

NB. === verb will convert youtube url to embedded url, if already embedded with return original value
embed=: 3 : 0
 first=. ({.~ 4 + I.@: ('.com/'&E.))y
 last=. ({.~ {.@I.@('&'&=)) (}.~ >:@{.@I.@('='&=)) y NB. strips off everything after the id
 if. -. +./ '/embed/' E. y do. first,'/embed/',last else. y end.  NB. converts to embedded video if not already embedded
)

NB. light version that does not require webview
NB. === verb used to show video if new or resized - y argument is youtube code for video, x is start [stop] if they exist
displayl=: 3 : 0
'' displayl y
:
 if. (2 = 3!:0  > x)*.(L. x) do. x =. ((24 60 60 {.~ #) #. ])@: (,@:(". ;. _1))"1 >  ':', each x end. NB. convert 'hh:mm:ss' to seconds
 if. -.x-:''do. 'start stop'=.x
            if. start-:stop do. time=.'?start=',(": start),'&' 
                            else. time=.'?start=',(": start),'&end=',(": stop),'&' end.
            else. time=.'?' end.
 playl 'https://www.youtube.com/embed/',y,time,'feature=oembed;rel=0&amp;'
)
playl=: 3 : 0
launch embed y
)
NB. === verb used to play video given the video url
watch=: 3 : 0
 launch y
)
