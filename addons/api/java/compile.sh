#!/bin/sh
set JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
cd src
"$JAVA_HOME/bin/javac" com/jsoftware/j/JInterface.java
"$JAVA_HOME/bin/javac" org/example/test/barebone.java
"$JAVA_HOME/bin/javac" org/example/test/jdtest.java
