NB. multimedia demo
NB. depends on platform support

coclass 'qtdemo'

NB. =========================================================
MULTIMEDIA=: 0 : 0
pc multimedia;
bin v;
minwh 150 150;
cc mm multimedia video;
bin h;
cc open button;cn "open local";
cc play button;cn "";set _ icon qstyle::sp_mediaplay;
cc mute checkbox;cn mute;
cc vol slider;
cc bri slider;
bin zh;
cc loop checkbox;cn loop;
cc pos slider;
bin z;
bin h;
cc openurl button;cn "open url";
cc url edit;
bin z;
bin z;
pshow;
)

NB. =========================================================
multimedia_mm_duration=: 3 : 0
duration=. 1000%~ ".sysdata
wd 'set pos max ',(":duration),';set pos min 0;set pos value 0'
)

NB. =========================================================
multimedia_mm_position=: 3 : 0
position=. 1000%~ ".sysdata
wd 'set pos value ',":position
)

NB. =========================================================
multimedia_mm_mediastatus=: 3 : 0
if. 'endofmedia'-:sysdata do.
  if. ". wd 'get loop value' do.
    wd 'set mm play'
  end.
end.
)

NB. =========================================================
multimedia_mm_error=: 3 : 0
wd 'set play icon qstyle::sp_mediapause'
wd 'set mm stop'
wd 'mb info error ',sysdata
)

NB. =========================================================
multimedia_mute_button=: 3 : 0
wd 'set mm mute ', mute
)

NB. =========================================================
multimedia_pos_changed=: 3 : 0
pos=. 1000* ". wd'get pos value'
wd 'set mm position ',":pos
)

NB. =========================================================
multimedia_bri_changed=: 3 : 0
NB. available since Qt 5.4 but unavailable in Qt6.2
if. (qtmajor<6) do.
  wd 'set mm brightness ',wd'get bri value'
end.
)

NB. =========================================================
multimedia_vol_changed=: 3 : 0
wd 'set mm volume ',wd'get vol value'
)

NB. =========================================================
multimedia_open_button=: 3 : 0
p=. 'all (*.*)|avi (*.avi)|mov (*.mov)|mp4 (*.mp4)|mpg (*.mpg)|mp3 (*.mp3)'
mmfile=. wd 'mb open1 "Open media file" "',(jpath '~/'),'" "',p,'"'
if. #mmfile do.
  wd 'set mm stop'
  wd 'set play icon qstyle::sp_mediapause'
  wd 'set pos value 0'
  if. (qtmajor<6) do.
    wd 'set mm brightness ', wd 'get bri value'
  end.
  wd 'set mm volume ', wd 'get vol value'
  wd 'set mm position 0'
  wd 'set mm media ', dquote mmfile
  wd 'set mm play'
end.
)

NB. =========================================================
multimedia_openurl_button=: 3 : 0
mmfile=. wd 'get url text'
if. #mmfile do.
  wd 'set mm stop'
  wd 'set play icon qstyle::sp_mediapause'
  wd 'set pos value 0'
  if. (qtmajor<6) do.
    wd 'set mm brightness ', wd 'get bri value'
  end.
  wd 'set mm volume ', wd 'get vol value'
  wd 'set mm position 0'
  wd 'set mm media ', dquote mmfile
  wd 'set mm play'
end.
)

NB. =========================================================
multimedia_play_button=: 3 : 0
if. 'playing' -.@-: wd 'get mm playstate' do.
  wd 'set play icon qstyle::sp_mediapause'
  wd 'set mm play'
else.
  wd 'set play icon qstyle::sp_mediaplay'
  wd 'set mm pause'
end.
)

NB. =========================================================
multimedia_close=: 3 : 0
wd 'pclose'
)

NB. =========================================================
MMdemo_run=: 3 : 0
wd MULTIMEDIA
wd 'set url text "https://archive.org/download/test-mpeg/test-mpeg_512kb.mp4"'
if. (qtmajor<6) do.
  wd 'set bri max 100;set _ min _100;set _ value 0'
end.
wd 'set vol max 100;set _ min 0;set _ value 50'
wd 'pshow'
)

NB. =========================================================
MMdemo_run''
