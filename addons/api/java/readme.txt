api:

public class JInterface
  public static String libjDir="";           // folder of J engine binary, may be empty
  public static String libj="";              // name of J engine binary
  public int callJ(String sentence)          // run and return error code
  public String dors(String sentence)        // run sentence and get output result
  public String dorsm(String verb, String y) // run J monad verb with Java string argument
  public String getc(String s)               // get Java string of J array
  public void setc(String s, String v)       // set J array from Java string
  public synchronized void destroyJ()        // unload J binaries
  public String getLocale()                  // get current J locale

types:
  only rank-1 string is supported.
  use json for passing numeric or boxed arrays
    J addon: convert/pjson
    Java library: javax.json or others

installation:

  download the appropriate binary from the webpage

> http://www.jsoftware.com/download/java/

  copy the jnative shared library to a folder insdie
  Java library path or run java with the java.library.path
  argument, eg.

  java -Djava.library.path=/path/folder ....

  default java.library.path depends on OS and Java versions

  Windows: PATH
    eg. c:/Windows/system32

  Linux: LD_LIBRARY_PATH or system library folders
    eg. /usr/lib/x86_64-linux-gnu

  Mac: JAVA_LIBRARY_PATH or some other folders (you google)
    eg. /Library/Java/Extensions

project source:
  put copy the folder com/jsoftware/j to project source code tree

  In your own project, initialize a JInterface object as below.

  first, define JAVA_HOME inside cmd or sh files, then

  compile sample java source files
    Windows: compile.cmd
    Linux/Mac: ./compile.sh

  run compiled class
    jd example requires jd and convert/json addon
    Windows: ./run-barebone.cmd ./run-jd.cmd
    Linux/Mac: ./run-barebone.sh ./run-jd.sh

IMPORTANT:
  before compiling, first change the
  full paths to J bin folder, shared library, and profile in
    src/org/example/test/barebone.java
    src/org/example/test/jdtest.java

  change the value of JAVA_HOME to your own Java home folder
  or comment the the if JAVA_HOME is already defined

// -------------------------------------------------------
// put copy of com/jsoftware/j folder into your source code tree

package org.example.test;

import com.jsoftware.j.JInterface;

public class test {

// define full paths to J bin folder, shared library, and profile

// typical for linux/macos install in home (dylib instead of so for macos)
// static String libjDir="/home/bill/j64-807/bin";
// static String libj="libj.so";
// static String jprofile="/home/bill/j64-807/bin/profile.ijs";
// static String BINPATH="/home/bill/j64-807/bin";

// typical for debian install
static String libjDir="";    // no need to set
static String libj="libj.so.8.07";
static String jprofile="/etc/j/8.07/profile.ijs";
static String BINPATH="/usr/bin";

// typical for windows install in home
// static String libjDir="/users/bill/j64-807/bin";
// static String libj="j.dll";
// static String jprofile="/users/bill/j64-807/bin/profile.ijs";
// static String BINPATH="/users/bill/j64-807/bin";

  public static void main(String[] args) {

// J boot up and load profile
// libjnative.so/jnative.dll must in lib path

  JInterface.libjDir=libjDir;
  JInterface.libj=libj;
  JInterface jInterface = new JInterface();
  StringBuilder sb = new StringBuilder();

// load j profile and stdlib

    sb.append("(3 : '0!:0 y')<'"+jprofile+"' [ ARGV_z_=: ''")
    .append(" [ BINPATH_z_ =: '"+BINPATH+"'");
    jInterface.callJ(sb.toString());

// your stuff here

// simple test: reverse a stringtest
   System.out.println(jInterface.dors("|.'abcde'"));

// Jd example, require data/jd and convert/pjson addons
  jInterface.callJ("load'jd convert/pjson'");
  jInterface.callJ("jdadminx'test'");

// jd'createtable';'tab2';'x int';'one int';'two int'
// argument encoded in json ["createtable","tab2","x int","one int","two int"]
 jInterface.dorsm("jd@dec_pjson_","[\"createtable\",\"tab2\",\"x int\",\"one int\",\"two int\"]");

// jd'insert';'tab2';'x';1 2 3 4 5 6;'one';23 24 25 26 27 28;'two';45 46 47 48 49 50
// argument encoded in json ["insert","tab2","x",[1,2,3,4,5,6],"one",[23,24,25,26,27,28],"two",[45,46,47,48,49,50]]
  jInterface.dorsm("jd@dec_pjson_","[\"insert\",\"tab2\",\"x\",[1,2,3,4,5,6],\"one\",[23,24,25,26,27,28],\"two\",[45,46,47,48,49,50]]");

// jd'read from tab2 where x>2'
  System.out.println(jInterface.dorsm("enc_pjson_@jd","read from tab2 where x>2"));
// J box array result encoded in json
// Java probably needs a library to convert it into Java object
// {
// "x":[3,4,5,6],
// "one":[25,26,27,28],
// "two":[47,48,49,50]
// }

  }

}
// -------------------------------------------------------
