# If RACK_DIR is not defined when calling the Makefile, default to two directories above

#///////////////////////////////////////////////////////////////
#// Eventual backporting to KRTPluginA and hence MIT licence
#///////////////////////////////////////////////////////////////

# Possible project dependancies which make all can make with override in project.mk
# In a sense the default is all of them, so beware to either change project.mk to match or just use some of them
# Don't forget to update project.mk as they are added
PROJ_DEPS = j efsw emacs
include project.mk

RACK_DIR ?= ../..
include $(RACK_DIR)/arch.mk

# supress errors
OK = || exit 0

MAC_PREMAKE = brew tap jackokring/premake && brew install jackokring/premake/premake4 && cd efsw && premake4 gmake $(OK)

# escape if windows support not there
ESCAPE = 

ARCH_DIR = linux 
# build server does not find packages
SUDO = apt install -y 
dowindows = rm jsource/jlibrary/bin/jconsole && touch jsource/jlibrary/bin/jconsole
jplatform = linux
# Nehalem
j64x = j64
ifdef ARCH_ARM64
jplatform = raspberry
endif

ifdef ARCH_LIN
# mac freeks on -l:libefsw.a
LDFLAGS += -pthread -L. -l:libefsw.a
endif

ifdef ARCH_WIN
ARCH_DIR = windows
# nope build requires things that can't integrate into the CI so binary from jsoftware.com
jplatform = none
ESCAPE = exit 0 ||
#j64x = j64avx512
# Use fake jconsole strategy to control build on windows to avoid .exe variable hell
# dowindows = cp jsource/bin/$(jplatform)/$(j64x)/* jsource/jlibrary/bin && touch jsource/jlibrary/bin/jconsole
dowindows = touch jsource/jlibrary/bin/jconsole && echo "Obtain a Windows binary fromjsoftware.com" > jsource/jlibrary/bin/jconsole.txt
# build server has no pacman
SUDO = pacman -Syu 
# No build on server CI with efsw
LDFLAGS += -pthread 
# BACKTRACE = cp mman-win32/mman.* jsource/libbacktrace
endif

ifdef ARCH_MAC
ARCH_DIR = macosx
jplatform = darwin
ifdef ARCH_ARM64
j64x = j64arm
endif
dowindows = touch jsource/jlibrary/bin/jconsole
SUDO = brew install 
LDFLAGS += -pthread -L. -lefsw
endif

export jplatform
export j64x

# FLAGS will be passed to both the C and C++ compiler
FLAGS +=
CFLAGS +=
CXXFLAGS += 

# Careful about linking to shared libraries, since you can't assume much about the user's environment and library search path.
# Static libraries are fine, but they should be added to this plugin's build system.
# The efsw file watcher static library see above

LDLIBS +=

# Add .cpp files to the build
SOURCES += $(wildcard src/*.cpp)

# Add files to the ZIP package when running `make dist`
# The compiled plugin and "plugin.json" are automatically added
# added presets as possibility
DISTRIBUTABLES += res

# must have some to add
DISTRIBUTABLES += $(wildcard presets/*)

DISTRIBUTABLES += $(wildcard LICENSE*)
DISTRIBUTABLES += $(wildcard profile.*)
# J
DISTRIBUTABLES += jsource/jlibrary

# Rebase submodule command
# as rebase just in case there are local edits to keep
# as it seems possible the default build script might not cover all cases
# as local edits are unlikely to be big, then this eventually saves on backups
SUB_REBASE = git submodule update --init --rebase --recursive --

# Unwind any local edits without a commit
# Yes, if it's not commited then it's gone with a clean
SUB_RESTORE = git submodule foreach "git restore ."

# Use a file deletion strategy to signal repo rebuild
jsource/make2/make.txt:
	$(SUB_REBASE) jsource
	$(SUB_RESTORE)
	@# cd jsource/make2 && ./clean.sh is not required as rebase restore does it
	
jsource/jlibrary/bin/jconsole: jsource/make2/make.txt
	@# Making jconsole see jsource/make2/make.txt
	@# Clean up before apply
	rm jsource/jlibrary/bin/*
	@# MSYS2 includes via rack a duplication of lib defs and a bug to fix dlerror
	@# copy bactrace dependency windows
	@# $(BACKTRACE)
	@# $(WIN_PKG)
	$(ESCAPE) cd jsource/make2 && ./build_jconsole.sh
	$(ESCAPE) cd jsource/make2 && ./build_libj.sh
	$(ESCAPE) cd jsource/make2 && ./build_tsdll.sh
	@# Windows/mac unmanaged copy and fake
	$(ESCAPE) cd jsource/make2 && ./cpbin.sh
	@# windows copy and all touch inc. linux delete
	$(dowindows)
	@# Binaries for plugin bin at jsource/jlibrary/bin/jconsole .exe/-lx/-mac? .txt for install win binary self
	
j: jsource/jlibrary/bin/jconsole

jclean:
	rm jsource/make2/make.txt
	rm jsource/jlibrary/bin/jconsole

libefsw.a:
	@# Building efsw
	$(MAC_PREMAKE)
	$(ESCAPE) cd efsw/make/$(ARCH_DIR) && make config=release
	@# mac name is different
	$(ESCAPE) cp efsw/lib/libefsw-static-release.a .
	$(ESCAPE) mv libefsw-static-release.a libefsw.a
	
efsw: libefsw.a

efswclean:
	rm libefsw.a
	
/usr/bin/emacs:
	@# Not critical
	$(SUDO) emacs $(OK)
	
emacs: /usr/bin/emacs

.PHONY: j jclean efsw efswclean emacs

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk

# Override all
all: $(PROJ_DEPS) $(TARGET)
	@# Building project
	
# Make header based on menus.txt to force inclusion recompilation cascade
plugin.hpp: menus.txt
	touch -m $@
	
.PHONY: all

