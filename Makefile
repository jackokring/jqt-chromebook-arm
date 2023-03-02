# If RACK_DIR is not defined when calling the Makefile, default to two directories above
RACK_DIR ?= ../..

# FLAGS will be passed to both the C and C++ compiler
FLAGS +=
CFLAGS +=
CXXFLAGS += 

# Careful about linking to shared libraries, since you can't assume much about the user's environment and library search path.
# Static libraries are fine, but they should be added to this plugin's build system.
# The efsw file watcher static library
LDFLAGS += -pthread -L. -l:libefsw.a
LDLIBS +=

# Add .cpp files to the build
SOURCES += $(wildcard src/*.cpp)

# Add files to the ZIP package when running `make dist`
# The compiled plugin and "plugin.json" are automatically added.
DISTRIBUTABLES += res
DISTRIBUTABLES += $(wildcard LICENSE*)
DISTRIBUTABLES += $(wildcard profile.*)
# J
DISTRIBUTABLES += jsource/jlibrary

macjig:
	@# Special files which affect the build of plugin.cpp
	@# Force removal of a dependent output so as to make it again with includes
	@# and all because the VSCode lady prog loves application of parser non-exlusions but .txt like wow, oft \'change grovener? 
	rm -rf build/src/*
	
jsource/make2/make.txt:
	git submodule update --init --recursive
	cd jsource/make2 && ./clean.sh
	
jsource/jlibrary/bin/jconsole: jsource/make2/make.txt
	@# Making jconsole see jsource/make2/make.txt
	cd jsource/make2 && ./build_jconsole.sh
	cd jsource/make2 && ./build_libj.sh
	cd jsource/make2 && ./build_tsdll.sh
	cd jsource/make2 && ./cpbin.sh
	@# Bulk trim
	rm jsource/jlibrary/bin/jconsole-lx
	@# Binaries for plugin bin at jsource/jlibrary/bin/jconsole
	
j: jsource/jlibrary/bin/jconsole

jclean:
	rm jsource/make2/make.txt

efsw/make/linux/Makefile:
	@# Making build system for efsw
	git submodule update --init --recursive
	cd efsw && premake4 gmake

libefsw.a: efsw/make/linux/Makefile
	@# Building efsw
	cd efsw/make/linux && make config=release
	cp efsw/lib/libefsw-static-release.a .
	mv libefsw-static-release.a libefsw.a
	
efsw: libefsw.a

efswclean:
	rm efsw/make/linux/Makefile
	
/usr/bin/emacs:
	sudo apt install emacs
	
sudoemacs: /usr/bin/emacs

.PHONY: j jclean efsw efswclean sudoemacs macjig

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk

# Override all
all: j efsw sudoemacs $(TARGET)
	@# Building project
	
.PHONY: all
