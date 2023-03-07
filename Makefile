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

ARCH_DIR = linux 
SUDO = sudo apt install -y 
PREMAKE = premake4
PREMAKE_RUN = premake4
CLUE =
dowindows = rm jsource/jlibrary/bin/jconsole && touch jsource/jlibrary/bin/jconsole
jplatform = linux
# Nehalem
j64x = j64
ifdef ARCH_ARM64
jplatform = raspberry
endif

ifdef ARCH_WIN
ARCH_DIR = windows
# nope
jplatform = windows
#j64x = j64avx512
# Use fake jconsole strategy to control build on windows to avoid .exe variable hell
dowindows = cp jsource/bin/$(jplatform)/$(j64x)/* jsource/jlibrary/bin && touch jsource/jlibrary/bin/jconsole
SUDO = pacman -Syu 
endif

ifdef ARCH_MAC
ARCH_DIR = macosx
jplatform = darwin
PREMAKE = tonyseek/premake/premake4
#PREMAKE_RUN = premake5
# install tonyseek
CLUE = brew tap tonyseek/premake
ifdef ARCH_ARM64
j64x = j64arm
endif
dowindows = touch jsource/jlibrary/bin/jconsole
SUDO = brew install 
endif

export jplatform
export j64x

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
# The compiled plugin and "plugin.json" are automatically added
# added presets as possibility
DISTRIBUTABLES += res presets
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

# Use rebase instead of merge for version bump
# Same rebase reasons, ...
SUB_PULL = git submodule foreach "git pull --rebase"

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
	cd jsource/make2 && ./build_jconsole.sh
	cd jsource/make2 && ./build_libj.sh
	cd jsource/make2 && ./build_tsdll.sh
	@# Windows/mac unmanaged copy and fake
	$(dowindows)
	cd jsource/make2 && ./cpbin.sh
	@# windows/mac does not make
	@# rm jsource/jlibrary/bin/jconsole-lx
	@# actual mac bin
	@# rm jsource/jlibrary/bin/jconsole-mac
	@# Binaries for plugin bin at jsource/jlibrary/bin/jconsole .exe/-lx/-mac?
	
j: jsource/jlibrary/bin/jconsole

jclean:
	rm jsource/make2/make.txt
	rm jsource/jlibrary/bin/jconsole
	
/usr/bin/premake4:
	@# mac will keep doing this and needs repo from xtra remote
	$(CLUE)
	$(SUDO) $(PREMAKE)

# Use a file deletion strategy to signal repo rebuild
efsw/premake5.lua: /usr/bin/premake4
	@# Making build system for efsw
	$(SUB_REBASE) efsw
	$(SUB_RESTORE)
	cd efsw && $(PREMAKE_RUN) gmake

libefsw.a: efsw/premake5.lua
	@# Building efsw
	cd efsw/make/$(ARCH_DIR) && make config=release
	@# mac name is different
	cp efsw/lib/libefsw-static-release.a .
	mv libefsw-static-release.a libefsw.a
	
efsw: libefsw.a

efswclean:
	rm efsw/premake5.lua
	rm libefsw.a
	
/usr/bin/emacs:
	$(SUDO) emacs
	
emacs: /usr/bin/emacs

# Bump dependancy versions by clean with a pull
bump:
	git pull
	$(SUB_PULL)

.PHONY: j jclean efsw efswclean emacs bump

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk

# Override all
all: $(PROJ_DEPS) $(TARGET)
	@# Building project
	
# Make header based on menus.txt to force inclusion recompilation cascade
plugin.hpp: menus.txt
	touch -m $@
	
.PHONY: all

