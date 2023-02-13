#!/bin/sh
set JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
cd src
"$JAVA_HOME/bin/java" org/example/test/barebone

# or put libjnative.so in a folder and set java.library.path
# "$JAVA_HOME/bin/java" -Djava.library.path=/home/bill/lib org/example/test/barebone
