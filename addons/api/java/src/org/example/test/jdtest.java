// put copy of com/jsoftware/j folder into your source code tree

package org.example.test;

import com.jsoftware.j.JInterface;

public class jdtest
{

// define full paths to J bin folder, shared library, and profile

// typical for macos install in home
// static String libjDir="/Users/bill/j64-807/bin";
// static String libj="libj.dylib";
// static String jprofile="/Users/bill/j64-807/bin/profile.ijs";
// static String BINPATH="/Users/bill/j64-807/bin";

// typical for linux install in home
// static String libjDir="/home/bill/j64-807/bin";
// static String libj="libj.so";
// static String jprofile="/home/bill/j64-807/bin/profile.ijs";
// static String BINPATH="/home/bill/j64-807/bin";

// typical for debian install
  static String libjDir="";  // no need to set
  static String libj="libj.so.8.07";
  static String jprofile="/etc/j/8.07/profile.ijs";
  static String BINPATH="/usr/bin";

// typical for windows install in home
// static String libjDir="/users/bill/j64-807/bin";
// static String libj="j.dll";
// static String jprofile="/users/bill/j64-807/bin/profile.ijs";
// static String BINPATH="/users/bill/j64-807/bin";

  public static void main(String[] args)
  {

// J boot up and load profile
// libjnative.so/jnative.dll must in java.library.path

    JInterface.libjDir=libjDir;
    JInterface.libj=libj;
    JInterface jInterface = new JInterface();
    StringBuilder sb = new StringBuilder();

// load j profile and stdlib

    sb.append("(3 : '0!:0 y')<'"+jprofile+"' [ ARGV_z_=: ''")
    .append(" [ BINPATH_z_ =: '"+BINPATH+"'");
    jInterface.callJ(sb.toString());

// your stuff here

// Jd example
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
