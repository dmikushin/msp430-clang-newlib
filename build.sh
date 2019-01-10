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
../configure --prefix=$ROOT/install --target=msp430-elf --enable-sim-msp430 && \
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
make install && \
\
export PATH=$ROOT/install/bin:$PATH && \
cd $ROOT && \
cd msp430-compiler-rt && \
mkdir -p build && \
cd build && \
cmake -DBUILD_SHARED_LIBS=0 -DCMAKE_BUILD_TYPE=Debug -DLLVM_DEFAULT_TARGET_TRIPLE=msp430-elf -DLLVM_TARGETS_TO_BUILD=MSP430 -DCMAKE_INSTALL_PREFIX=$ROOT/install/msp430-elf -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY -DCOMPILER_RT_BAREMETAL_BUILD=TRUE -DCOMPILER_RT_OS_DIR="" .. && \
make -j48 && \
make install

