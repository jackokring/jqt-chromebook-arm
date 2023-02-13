# tables_dsv
Th `tables/dsv` addon reads/writes/appends Delimiter-separated value (DSV) files and strings.
Supports user-defined field and string delimiters.

## Example usage
```j
   freads '~addons/tables/dsv/test/mixed.tsv'
1       "The ""big, black"" dog"        "R"     3.221   "Lolly" 6       7
8       "likes to"      "W"     3.4     "A"     13      14
15      "eat"   "T"     ""      ""      20      21
22      "juicy, 'red' bones"    "I"     91991.3 "CAT"   27      28

   require 'tables/dsv'
   ]mixed_array=: makenum (TAB;'""') readdsv '~addons/tables/dsv/test/mixed.tsv'
┌──┬────────────────────┬─┬───────┬─────┬──┬──┐
│1 │The "big, black" dog│R│3.221  │Lolly│6 │7 │
├──┼────────────────────┼─┼───────┼─────┼──┼──┤
│8 │likes to            │W│3.4    │A    │13│14│
├──┼────────────────────┼─┼───────┼─────┼──┼──┤
│15│eat                 │T│       │     │20│21│
├──┼────────────────────┼─┼───────┼─────┼──┼──┤
│22│juicy, 'red' bones  │I│91991.3│CAT  │27│28│
└──┴────────────────────┴─┴───────┴─────┴──┴──┘
   ]mixed_string=: (',') makedsv mixed_array
1,The "big, black" dog,R,3.221,Lolly,6,7
8,likes to,W,3.4,A,13,14
15,eat,T,,,20,21
22,juicy, 'red' bones,I,91991.3,CAT,27,28

```
