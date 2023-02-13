// log

"use strict"

var Dlog = [];
var DlogMax = 100;
var DlogPos = 0;

// ---------------------------------------------------------------------
function dlog_add(t) {
 t = t.trim();
 if (t.length===0) return;
 var p = Dlog.indexOf(t);
 if (p >= 0) Dlog.splice(p, 1);
 if (Dlog.length == DlogMax)
  Dlog.splice(0, 1);
 Dlog.push(t);
 DlogPos = Dlog.length;
}

// ---------------------------------------------------------------------
function dlog_scroll(m) {
 var n, p;
 n = Dlog.length;
 if (n == 0) return;
 p = Math.max(0, Math.min(n - 1, DlogPos + m));
 if (p == DlogPos) return;
 DlogPos = p;
 tcmprompt("   " + Dlog[p]);
}
