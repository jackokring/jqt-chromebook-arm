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
	
j: jsource/jlibrary/bin/jconsole jsource/make2/make.txt

jclean:
	rm jsource/make2/make.txt
	
/usr/bin/premake4:
	sudo apt install premake4

efsw/make/linux/Makefile: /usr/bin/premake4
	@# Making build system for efsw
	git submodule update --init --recursive
	cd efsw && premake4 gmake

libefsw.a: efsw/make/linux/Makefile
	@# Building efsw
	cd efsw/make/linux && make config=release
	cp efsw/lib/libefsw-static-release.a .
	mv libefsw-static-release.a libefsw.a
	
efsw: libefsw.a efsw/make/linux/Makefile

efswclean:
	rm efsw/make/linux/Makefile
	
/usr/bin/emacs:
	sudo apt install emacs
	
sudoemacs: /usr/bin/emacs

.PHONY: j jclean efsw efswclean sudoemacs

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk

# Override all
all: j efsw sudoemacs $(TARGET)
	@# Building project
	
# Make headers based on menus.txt
%.hpp: menus.txt
	touch -m $@
	
.PHONY: all
