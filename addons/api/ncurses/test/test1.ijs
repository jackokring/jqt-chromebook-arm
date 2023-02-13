cocurrent 'base'
coinsert 'ncurses'

test=: 3 : 0
stdscr=: initscr''
clear''
start_color''
raw''
keypad stdscr;1{a.
noecho''
nonl''
init_pair 1, COLOR_GREEN, COLOR_BLACK
move 0 0
addstr memr 0 _1,~ termname''
move 1 0
addstr memr 0 _1,~ longname''
whilst. ch~:KEY_F 1 do.
  move 2 5
  attron A_BOLD (23 b.) COLOR_PAIR 1
  addstr 'Hello world!'
  move 3 5
  attroff COLOR_PAIR 1
  addstr 'Настройки поиска Fruit Sales 特價生果'
  move 4 10
  attroff A_BOLD
  addstr 'press F1 to exit'
  refresh ''
  ch=: getch''
  move 5 0
  addstr (":ch),' ', a.{~(ch>255){ch,32
  refresh ''
end.
endwin''
0
)

test''
