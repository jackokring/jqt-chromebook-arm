// term

"use strict";

var tcm;
var cmdlist=[];

// ----------------------------------------------------------------------
function clearterm() {
 tcm.getDoc().setValue("");
 tcmprompt("   ");
 tcm.focus();
}

// ----------------------------------------------------------------------
function docmd(cmd, show) {
 cmd = cmd.trim();
 dlog_add(cmd);
 if (show) tcmappend(cmd + "\n");
 ws.send(cmd);
}

// ----------------------------------------------------------------------
function docmds(cmds, show) {
 cmdlist=cmds.map(function(e){return [e,show];});
 docmdnext();
}

// ----------------------------------------------------------------------
function docmdnext() {
 if (cmdlist.length === 0) return;
 var t = cmdlist.shift();
 if (t.length===0)
  tcmappend("\n   ");
 else
  docmd.apply(null,t);
}

// ----------------------------------------------------------------------
function initterm() {
 tcm=CodeMirror(getid("term"), {
  cursorScrollMargin: 18,
  electricChars: false,
  lineWrapping: false,
  readOnly:true,
  styleActiveLine: true
 });

 var keys = {};
 keys["Enter"]=tcmenter;
 keys["Shift-Ctrl-Down"] = tcmlogdown;
 keys["Shift-Ctrl-Up"] = tcmlogup;
 tcm.setOption("extraKeys", keys);
}

// ----------------------------------------------------------------------
function tcmappend(t) {
 tcm.setCursor(tcm.lineCount())
 tcm.replaceSelection(t, "end");
 tcm.focus();
}

// ----------------------------------------------------------------------
function tcmenter() {
 var n, t;
 n = tcm.getCursor().line
 t = tcm.getLine(n);
 if (n === tcm.lastLine()) {
  tcmappend("\n");
  docmd(t, false);
 } else
  tcmprompt(t);
}

// ----------------------------------------------------------------------
function tcmlogdown() {
 dlog_scroll(1);
}

// ----------------------------------------------------------------------
function tcmlogup() {
 dlog_scroll(-1);
}

// ---------------------------------------------------------------------
function tcmprompt(t) {
 var n, doc, len;
 var doc=tcm.getDoc();
 n = tcm.lineCount() - 1;
 len = tcm.getLine(n).length;
 doc.setSelection({line:n,ch:0},{line:n,ch:len})
 tcm.replaceSelection(t)
 tcm.setCursor(tcm.lineCount())
 tcm.scrollIntoView(n, 0)
}

// ---------------------------------------------------------------------
function tcmreturn(e) {
 if (e.length===0) return;
 var t=Number(e[0]);
 if (t !== 3)
  tcmappend(e.slice(1));
 if (t===0)
  docmdnext();
}
