NB. multimedia lab viewer for JHS platform 
coclass 'video'

size=: 3 : 0
'WM HM'=: >('sml'i.y) {400 225;800 450;1600 900;400 225 NB. invalid input results in small size
)

NB. === verb used to show video if new or resized - y argument is youtube code for video, x is start [stop] if they exist
display=: 3 : 0
'' display y
:
 if. (2 = 3!:0  > x)*.(L. x) do. x =. ((24 60 60 {.~ #) #. ])@: (,@:(". ;. _1))"1 >  ':', each x end. NB. convert 'hh:mm:ss' to seconds
 if. -.x-:''do. 'start stop'=.x
            if. start-:stop do. time=.'?start=',(": start),'&' 
                            else. time=.'?start=',(": start),'&end=',(": stop),'&' end.
            else. time=.'?' end.
 play 'https://www.youtube.com/embed/',y,time,'feature=oembed;rel=0&amp;'
)

NB. === verb used to play video given the youtube url
play=: 3 : 0 
 jhtml_jhs_ '<iframe width="',(":WM) ,'" height="',(":HM) ,'" src="',(embed y),'"></iframe><text font-size="12"><br> size_video_ ''s'' NB. small display -- 400 225<br> size_video_ ''m'' NB. medium display - 800 450<br> size_video_ ''l'' NB. large display -- 1600 900'
)

NB. === verb will convert youtube url to embedded url, if already embedded with return original value
embed=: 3 : 0
 first=. ({.~ 4 + I.@: ('.com/'&E.))y
 last=. (}.~ >:@{.@I.@('='&=)) y 
 if. -. +./ '/embed/' E. y do. first,'/embed/',last else. y end.  NB. converts to embedded video if not already embedded
)
NB. === verb used to play video given the video url
watch=: 3 : 0
 launch y
)
size 's' NB. sets small size initially
