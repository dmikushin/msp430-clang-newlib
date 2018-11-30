# LLVM/clang + newlib bundle for TI MSP430

## Building

```
build.sh
```

## Deployment

```
export PATH=$(pwd)/install/bin:$PATH
```

## ChibiOS testing

```
unzip ChibiOS_18.2.1.zip 
cd ChibiOS_18.2.1
git clone git@github.com:Chibios/ChibiOS.git ChibiOS-RT
cd community/demos/MSP430X/NIL-EXP430FR5969
make
```

Before running `make`, we need to alter compiler options hardcoded for gcc.

Current state is: needs libc, which is missing

```
make

clang -c -mmcu=msp430fr5969  -O0 -g  -fsigned-char -fshort-enums  -ffunction-sections -fdata-sections -fno-common  -Wall -Wextra -Wundef -Wstrict-prototypes -Wa,-alms=build/lst/ch.lst   -MD -MP -MF .dep/ch.o.d  -I. -I../../../../ChibiOS-RT/os/license -I../../../os/common/startup/MSP430X/compilers/GCC -I../../../os/common/ext/MSP430/inc -I../../../../ChibiOS-RT/os/nil/include -I../../../os/common/ports/MSP430X -I../../../os/common/ports/MSP430X/compilers/GCC -I../../../../ChibiOS-RT/os/hal/osal/nil -I../../../../ChibiOS-RT/os/hal/include -I../../../os/hal/ports/MSP430X -I../../../os/hal/boards/EXP430FR5969 -I../../../../ChibiOS-RT/test/nil/source/test -I../../../../ChibiOS-RT/os/various ../../../../ChibiOS-RT/os/nil/src/ch.c -o build/obj/ch.o
clang-8: warning: argument unused during compilation: '-mmcu=msp430fr5969' [-Wunused-command-line-argument]
In file included from ../../../../ChibiOS-RT/os/nil/src/ch.c:28:
In file included from ../../../../ChibiOS-RT/os/nil/include/ch.h:33:
In file included from ../../../os/common/ports/MSP430X/compilers/GCC/chtypes.h:29:
In file included from /home/marcusmae/acctek/install/lib/clang/8.0.0/include/stdint.h:63:
/usr/include/stdint.h:26:10: fatal error: 'bits/libc-header-start.h' file not found
#include <bits/libc-header-start.h>
```

