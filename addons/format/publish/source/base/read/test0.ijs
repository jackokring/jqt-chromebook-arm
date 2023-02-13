NB. test0

TEST=: 0 : 0
<h1>heading1</h1>
<newpage/>
abc<b>def</b>123
abc<b><i>def</i></b>123
)

dbg 1
dbstops''
smoutput StructTags parseml dat
