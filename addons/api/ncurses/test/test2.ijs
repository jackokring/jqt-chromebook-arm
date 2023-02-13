cocurrent 'base'
coinsert 'ncurses'

test=: 3 : 0
if. UNAME-:'Linux' do.
  'libc.so.6 setlocale > x i *c'&cd 6;''
  'libc.so.6 setlocale > x i *c'&cd 1;,'C'
elseif. UNAME-:'Darwin' do.
  'libc.dylib setlocale > x i *c'&cd 0;''
  'libc.dylib setlocale > x i *c'&cd 4;,'C'
elseif. UNAME-:'Win' do.
  'msvcrt.dll setlocale > + x i *c'&cd 0;''
  'msvcrt.dll setlocale > + x i *c'&cd 4;,'C'
end.
stdscr=: initscr''
clear''
start_color''
raw''
keypad stdscr;1{a.
noecho''
nonl''
init_pair 1, COLOR_GREEN, COLOR_BLACK
move 0 0
addwstr memr 0 _1,~ termname''
move 1 0
addwstr memr 0 _1,~ longname''
ch=: ,_1
whilst. cch~:KEY_F 1 do.
  move 2 5
  attron A_BOLD (23 b.) COLOR_PAIR 1
  addstr 'Hello world! 特價生果'
  move 3 5
  attroff COLOR_PAIR 1
  addwstr 'Настройки поиска Fruit Sales 特價生果'
  move 4 10
  attroff A_BOLD
  addwstr 'press F1 to exit'
  refresh ''
  get_wch ch
  move 5 0
  cch=. {.ch
  addwstr (":cch),' ', u:cch
  refresh ''
end.
endwin''
0
)

test''
