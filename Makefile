# If RACK_DIR is not defined when calling the Makefile, default to two directories above
RACK_DIR ?= ../..
include $(RACK_DIR)/arch.mk

ARCH_DIR := linux 

ifdef ARCH_WIN
ARCH_DIR := windows
jplatform = windows
j64x = j64
export jplatform
export j64x
endif

ifdef ARCH_MAC
ARCH_DIR := macosx
endif

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

# Rebase submodule command
REBASE = git submodule update --init --rebase --recursive --
RESTORE = git restore 
SUDO = sudo apt install -y 

# Use a file deletion strategy
jsource/make2/make.txt:
	$(REBASE) jsource
	$(RESTORE) jsource
	cd jsource/make2 && ./clean.sh
	
jsource/jlibrary/bin/jconsole: jsource/make2/make.txt
	@# Making jconsole see jsource/make2/make.txt
	@# Clean up before apply
	rm jsource/jlibrary/bin/*
	cd jsource/make2 && ./build_jconsole.sh
	cd jsource/make2 && ./build_libj.sh
	cd jsource/make2 && ./build_tsdll.sh
	@# Windows unmanaged copy
	cp jsource/bin/windows/j64/* jsource/jlibrary/bin
	@# Windows fake copy
	touch jsource/jlibrary/bin/jsource
	cd jsource/make2 && ./cpbin.sh
	@# Bulk trim
	rm jsource/jlibrary/bin/jconsole-lx$(EXE_EXT)
	@# Some mac extra not required
	rm jsource/jlibrary/bin/jconsole-mac
	@# Binaries for plugin bin at jsource/jlibrary/bin/jconsole .exe?
	
j: jsource/jlibrary/bin/jconsole jsource/make2/make.txt

jclean:
	rm jsource/jlibrary/bin/jconsole
	
/usr/bin/premake4:
	$(SUDO) premake4

libefsw.a: /usr/bin/premake4
	@# Making build system for efsw
	$(REBASE) efsw
	cd efsw && premake4 gmake
	@# Building efsw
	cd efsw/make/$(ARCH_DIR) && make config=release
	cp efsw/lib/libefsw-static-release.a .
	mv libefsw-static-release.a libefsw.a
	
efsw: libefsw.a

efswclean:
	rm libefsw.a
	
/usr/bin/emacs:
	$(SUDO) emacs
	
emacs: /usr/bin/emacs

# Bump dependancy versions
bump: jclean efswclean

.PHONY: j jclean efsw efswclean emacs bump

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk

# Override all
all: j efsw emacs $(TARGET)
	@# Building project
	
# Make header based on menus.txt
plugin.hpp: menus.txt
	touch -m $@
	
.PHONY: all
