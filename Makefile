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
DISTRIBUTABLES += jlibrary jconsole libj.so libtsdll.so libefsw.so

premake:
	@# Making build system for efsw
	git submodule update --init --recursive
	cd efsw
	premake4 gmake

libs: premake
	@# Building efsw
	cd efsw/make/linux
	make config=release
	cd ../../..
	cp efsw/lib/libefsw.so .

proj: libs dist
	@# Building project

.PHONY libs proj premake

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk
