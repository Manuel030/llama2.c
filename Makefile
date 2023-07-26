# Change this to whereever you keep NDK
NDK            = /home/manuel/Android/Sdk/ndk/25.2.9519653
SRCDIR         = .
OBJDIR         = .
DBG           ?= 0

# Debug/Release configuration
ifeq ($(DBG),1)
MODE_FLAGS     = -DDEBUG -g -O0
else
MODE_FLAGS     = -Os -fdata-sections -ffunction-sections
endif

## NDK configuration (clang)

# NDK Version
NDK_TARGETVER  = 27

# Target arch - here aarch64 for android
NDK_TARGETARCH = aarch64-linux-android

# Target CPU (ARMv8)
NDK_TARGETSHORTARCH = arm64

# Toolchain version
NDK_TOOLVER  = 4.9

# Architecture of a machine that does cross compilation
NDK_HOSTARCH = linux-x86_64

# Set needed preprocessor symbols
NDK_TOOLS    = $(NDK)/toolchains/llvm/prebuilt/$(NDK_HOSTARCH)/bin
NDK_SYSROOT  = $(NDK)/sysroot
# NDK_TOOL     = $(CLANG_PATH)/bin/clang
NDK_TOOL     = $(NDK_TOOLS)/clang-14
NDK_LIBS     = $(NDK)/toolchains/$(NDK_TARGETARCH)-$(NDK_TOOLVER)/prebuilt/linux-x86_64/lib/gcc/$(NDK_TARGETARCH)/4.9.x
NDK_INCLUDES = -I$(NDK)/sysroot/usr/include \
               -I$(NDK)/sysroot/usr/include/$(NDK_TARGETARCH)
NDK_SYSROOT  = $(NDK)/platforms/android-$(NDK_TARGETVER)/arch-$(NDK_TARGETSHORTARCH)

# Options common to compiler and linker
OPT          = $(MODE_FLAGS) \
               -std=c99 \
               -fPIE \
               -Wall \
               -target $(NDK_TARGETARCH)

# Compiler options
CFLAGS       = $(OPT) \
               $(NDK_INCLUDES)

# Linker options
LDFLAGS      = $(OPT) \
               $(MODE_FLAGS) \
               -pie \
               --sysroot=$(NDK_SYSROOT) \
               -B $(ANDROID_NDK)/toolchains/$(NDK_TARGETARCH)-$(NDK_TOOLVER)/prebuilt/linux-x86_64/$(NDK_TARGETARCH)/bin \
               -L$(NDK_LIBS)

all:
	echo ${NDK_TOOL}
	$(NDK_TOOL) -c $(SRCDIR)/run.c -o $(OBJDIR)/run.o $(CFLAGS)
	$(NDK_TOOL) -o run $(OBJDIR)/run.o $(LDFLAGS)

# the most basic way of building that is most likely to work on most systems
.PHONY: run
run: run.c
	gcc -O3 -o run run.c -lm

# useful for a debug build, can then e.g. analyze with valgrind, example:
# $ valgrind --leak-check=full ./run out/model.bin 1.0 3
rundebug: run.c
	gcc -g -o run run.c -lm

# https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
# https://simonbyrne.github.io/notes/fastmath/
# -Ofast enables all -O3 optimizations. 
# Disregards strict standards compliance.
# It also enables optimizations that are not valid for all standard-compliant programs. 
# It turns on -ffast-math, -fallow-store-data-races and the Fortran-specific 
# -fstack-arrays, unless -fmax-stack-var-size is specified, and -fno-protect-parens. 
# It turns off -fsemantic-interposition.
# In our specific application this is *probably* okay to use
.PHONY: runfast
runfast: run.c
	gcc -Ofast -o run run.c -lm

# additionally compiles with OpenMP, allowing multithreaded runs
# make sure to also enable multiple threads when running, e.g.:
# OMP_NUM_THREADS=4 ./run out/model.bin
.PHONY: runomp
runomp: run.c
	gcc -Ofast -fopenmp -march=native run.c  -lm  -o run

.PHONY: clean
clean:
	rm -f run
