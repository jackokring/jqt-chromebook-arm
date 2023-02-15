/* Copyright 1990-2007, Jsoftware Inc.  All rights reserved.               */
/* Licensed use only. Any other use is in violation of copyright.          */
/* J console */
/* #define READLINE for Unix readline support */
#ifdef _WIN32
#include <windows.h>
#include <io.h> 
#include <fcntl.h>
#else
#include <unistd.h>
#include <sys/resource.h>
#define _isatty isatty
#define _fileno fileno
#include <dlfcn.h>
#define GETPROCADDRESS(h,p) dlsym(h,p)
#endif
#include <signal.h>
#include <stdint.h>
#include <locale.h>
#ifdef __APPLE__
#include <xlocale.h>
#endif

#include "j.h"
#include "jeload.h"

#if !defined(_WIN32) && !defined(__OpenBSD__) && !defined(__FreeBSD__) //temporary
#include "backtrace.h"
#endif

#define J_STACK  0xc00000uL // 12mb

static int runjscript=0;   /* exit after running script */
static int forceprmpt=0;   /* emit prompt even if isatty is false */
static int breadline=0;    /* 0: none  1: libedit  2: linenoise */
static int norl=0;         /* disable readline/linenoise */
static void sigint(int k){jeinterrupt();signal(SIGINT,sigint);}
static void sigint2(int k){jeinterrupt();}

char* Jinput_stdio(char* prompt)
{
  // if(!runjscript&&prompt&&strlen(prompt)){
	//fputs(prompt,stdout);
	//fflush(stdout); /* windows emacs */
  //}
	//if(!fgets(input, sizeof(input), stdin))
	//{
#ifdef _WIN32
		/* ctrl+c gets here for win */
	//	if(!(forceprmpt||_isatty(_fileno(stdin)))) return "2!:55''";
	//	fputs("\n",stdout);
	//	fflush(stdout);
	//	jeinterrupt();
#else
		/* unix eof without readline */
	//	return "2!:55''";
#endif
	//}
	//return input;
	return prompt;
}

C* _stdcall Jinput(JST* jt,C* prompt){
	return (C*)Jinput_stdio((char*)prompt);
}

/* J calls for output */
void _stdcall Joutput(JST* jt,int type, C* s)
{
 if(MTYOEXIT==type)
 {
  jefree();
  exit((int)(intptr_t)s);
 }
 if((2==type)||(4==type)){
 fputs((char*)s,stderr);
 fflush(stderr);
 }else{
 fputs((char*)s,stdout);
 fflush(stdout);
 }
}

JST* jt;

int main(int argc, char* argv[])
{
 setlocale(LC_ALL, "");
#if !(defined(ANDROID)||defined(_WIN32))
 locale_t loc;
 if ((loc = newlocale(LC_NUMERIC_MASK, "C", (locale_t) 0))) uselocale(loc);
#else
 setlocale(LC_NUMERIC,"C");
#endif
 void* callbacks[] ={Joutput,0,Jinput,0,(void*)SMCON}; int type;
 int i,poslib=0,poslibpath=0,posnorl=0,posprmpt=0,posscrpt=0; // assume all absent
 for(i=1;i<argc;i++){
  if(!poslib&&!strcmp(argv[i],"-lib")){poslib=i; if((i<argc-1)&&('-'!=*(argv[i+1])))poslibpath=i+1;}
  else if(!posnorl&&!strcmp(argv[i],"-norl")) {posnorl=i; norl=1;}
  else if(!posprmpt&&!strcmp(argv[i],"-prompt")) {posprmpt=i; forceprmpt=1;}
  else if(!posscrpt&&!strcmp(argv[i],"-jscript")) {posscrpt=i; runjscript=1; norl=1; forceprmpt=0;}
 }
// fprintf(stderr,"poslib %d,poslibpath %d,posnorl %d,posprmpt %d,posscrpt %d\n",poslib,poslibpath,posnorl,posprmpt,posscrpt);
 jepath(argv[0],(poslibpath)?argv[poslibpath]:"");
 // remove processed arg
 if(poslib||poslibpath||posnorl||posprmpt||posscrpt){
  int j=0; 
  char **argvv = malloc(argc*sizeof(char*));
  argvv[j++]=argv[0];
  for(i=1;i<argc;i++){
   if(!(i==poslib||i==poslibpath||i==posnorl||i==posprmpt||i==posscrpt))argvv[j++]=argv[i];
  }
  argc=j;
  for(i=1;i<argc;++i)argv[i]=argvv[i];
  free(argvv);
 }

#if 0
// set stack size to get limit error instead of crash
 struct rlimit lim;
 if(!getrlimit(RLIMIT_STACK,&lim)){
  if(lim.rlim_cur!=RLIM_INFINITY && lim.rlim_cur<J_STACK){
   lim.rlim_cur=(lim.rlim_max==RLIM_INFINITY)?J_STACK:(lim.rlim_max<J_STACK)?lim.rlim_max:J_STACK;
   setrlimit(RLIMIT_STACK,&lim);
  }
 }
#endif

 jt=jeload(callbacks);
 if(!jt){char m[1000]; jefail(m); fputs(m,stderr); exit(1);}
#ifndef _WIN32
 if(2==breadline){
  struct sigaction sa;
  sa.sa_flags = 0;
  sa.sa_handler = sigint2;
  sigemptyset(&(sa.sa_mask));
  sigaddset(&(sa.sa_mask), SIGINT);
  sigaction(SIGINT, &sa, NULL);
 }else
#endif
  signal(SIGINT,sigint);

	 type=0;
 if(runjscript)type|=256;
 int r=jefirst(type,"");
 if(!runjscript)while(1){r=jedo((char*)Jinput(jt,(forceprmpt||_isatty(_fileno(stdin)))?(C*)"   ":(C*)""));}
 jefree();
#if !(defined(ANDROID)||defined(_WIN32))
 if(loc)freelocale(loc);
#endif
 return r;
}
