#!/bin/sh

ROOT=$(pwd)

mkdir -p $ROOT/install && \
\
cd $ROOT && \
cd msp430-clang && \
mkdir -p build && \
cd build && \
cmake -DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Debug -DLLVM_DEFAULT_TARGET_TRIPLE=msp430-elf -DLLVM_TARGETS_TO_BUILD=MSP430 -DCLANG_ENABLE_STATIC_ANALYZER=0 -DCLANG_ENABLE_ARCMT=0 -DCMAKE_INSTALL_PREFIX=$ROOT/install ../src/llvm && \
make -j12 && \
make install && \
\
echo $ROOT && \
cd $ROOT && \
cd binutils-gdb && \
mkdir -p build && \
cd build && \
../configure --prefix=$ROOT/install --enable-sim-msp430 && \
make -j48 && \
make install && \
export PATH=$ROOT/install/bin:$PATH && \
\
cd $ROOT && \
cd msp430-newlib && \
mkdir -p build && \
cd build && \
../configure --prefix=$ROOT/install --target=msp430-elf AR_FOR_TARGET=llvm-ar RANLIB_FOR_TARGET="llvm-ar s" CC_FOR_TARGET=clang && \
make -j48 && \
make install
