# If RACK_DIR is not defined when calling the Makefile, default to two directories above
RACK_DIR ?= ../..

# FLAGS will be passed to both the C and C++ compiler
FLAGS +=
CFLAGS +=
CXXFLAGS += -pthread -lefsw

# Careful about linking to shared libraries, since you can't assume much about the user's environment and library search path.
# Static libraries are fine, but they should be added to this plugin's build system.
LDFLAGS += -pthread -lefsw
LDLIBS +=

# Add .cpp files to the build
SOURCES += $(wildcard src/*.cpp)

# Add files to the ZIP package when running `make dist`
# The compiled plugin and "plugin.json" are automatically added.
DISTRIBUTABLES += res
DISTRIBUTABLES += $(wildcard LICENSE*)
DISTRIBUTABLES += $(wildcard profile.*)
# J and the file watcher dynamic library
DISTRIBUTABLES += jsource/jlibrary libefsw.so

jclean:
	git submodule update --init --recursive
	cd jsource/make2 && ./clean.sh
	
sudo-emacs:
	sudo apt install emacs
	
j: 
	@# Making jconsole see jsource/make2/make.txt
	cd jsource/make2 && ./build_jconsole.sh
	cd jsource/make2 && ./build_libj.sh
	cd jsource/make2 && ./build_tsdll.sh
	cd jsource/make2 && ./cpbin.sh
	@# Bulk trim
	rm jsource/jlibrary/bin/jconsole-lx
	@# Binaries for plugin bin at jsource/jlibrary/bin/jconsole

premake:
	@# Making build system for efsw
	git submodule update --init --recursive
	cd efsw && premake4 gmake

efsw: premake
	@# Building efsw
	cd efsw/make/linux && make config=release
	cp efsw/lib/libefsw.so .

proj: j sudo-emacs efsw dist
	@# Building project

.PHONY: efsw proj premake j jclean sudo-emacs

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk
