# LLVM/clang toolchain for TI MSP 430

## Building LLVM/clang

The following shall clone, build and install the MSP 430 toolchain to the local `install` folder:

```
mkdir access-softek
cd access-softek
git clone https://github.com/access-softek/msp430-clang.git
cd msp430-clang
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Debug -DLLVM_DEFAULT_TARGET_TRIPLE=msp430-elf -DLLVM_TARGETS_TO_BUILD=MSP430 -DCLANG_ENABLE_STATIC_ANALYZER=0 -DCLANG_ENABLE_ARCMT=0 -DCMAKE_INSTALL_PREFIX=$(pwd)/../../install ../src/llvm
make -j12
make install
```

## Building binutils/gdb

First, install bison, flex and texinfo, e.g.:

```
sudo apt install bison flex texinfo
```

```
cd access-softek
git clone git://sourceware.org/git/binutils-gdb.git
cd binutils-gdb
mkdir build
cd build
../configure --prefix=$(pwd)/../install --enable-sim-msp430
make -j48
make install
export PATH=$(pwd)/install/bin:$PATH
```

## Hello, world

```
cd access-softek
export PATH=$(pwd)/install/bin:$PATH
cd msp430-clang/test
make
```

## Build newlib

```
cd access-softek
git clone git://sourceware.org/git/newlib-cygwin.git
cd newlib-cygwin
mkdir build
cd build
../configure --prefix=$(pwd)/../../install --target=msp430-elf AR_FOR_TARGET=llvm-ar RANLIB_FOR_TARGET="llvm-ar s" CC_FOR_TARGET=clang
make -j48
make install
```

## ChibiOS testing


```
cd access-softek
unzip ChibiOS_18.2.1.zip 
cd ChibiOS_18.2.1
git clone git@github.com:Chibios/ChibiOS.git ChibiOS-RT
cd community/demos/MSP430X/NIL-EXP430FR5969
make
```

Before running `make`, we need to alter compiler options hardcoded for gcc.

Current state is: needs libc, which is missing

```
marcusmae@M17xR4:~/acctek/ChibiOS_18.2.1/community/demos/MSP430X/NIL-EXP430FR5969$ make

clang -c -mmcu=msp430fr5969  -O0 -g  -fsigned-char -fshort-enums  -ffunction-sections -fdata-sections -fno-common  -Wall -Wextra -Wundef -Wstrict-prototypes -Wa,-alms=build/lst/ch.lst   -MD -MP -MF .dep/ch.o.d  -I. -I../../../../ChibiOS-RT/os/license -I../../../os/common/startup/MSP430X/compilers/GCC -I../../../os/common/ext/MSP430/inc -I../../../../ChibiOS-RT/os/nil/include -I../../../os/common/ports/MSP430X -I../../../os/common/ports/MSP430X/compilers/GCC -I../../../../ChibiOS-RT/os/hal/osal/nil -I../../../../ChibiOS-RT/os/hal/include -I../../../os/hal/ports/MSP430X -I../../../os/hal/boards/EXP430FR5969 -I../../../../ChibiOS-RT/test/nil/source/test -I../../../../ChibiOS-RT/os/various ../../../../ChibiOS-RT/os/nil/src/ch.c -o build/obj/ch.o
clang-8: warning: argument unused during compilation: '-mmcu=msp430fr5969' [-Wunused-command-line-argument]
In file included from ../../../../ChibiOS-RT/os/nil/src/ch.c:28:
In file included from ../../../../ChibiOS-RT/os/nil/include/ch.h:33:
In file included from ../../../os/common/ports/MSP430X/compilers/GCC/chtypes.h:29:
In file included from /home/marcusmae/acctek/install/lib/clang/8.0.0/include/stdint.h:63:
/usr/include/stdint.h:26:10: fatal error: 'bits/libc-header-start.h' file not found
#include <bits/libc-header-start.h>
```

