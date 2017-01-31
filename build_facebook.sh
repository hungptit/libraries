#!/bin/bash
SANDBOX=$HOME/sandbox
ROOT_DIR=$PWD
SRC_DIR=$ROOT_DIR/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_DIR

osType=$(uname)
case "$osType" in
    "Darwin")
        {
            NCPUS=$(sysctl -n hw.ncpu);
            CC=clang
            CXX=clang++
            BUILD_OPTS=-j$((NCPUS+1))
        } ;;
    "Linux")
        {
            NCPUS=$(grep -c ^processor /proc/cpuinfo)
            BUILD_OPTS=-j$((NCPUS+1))
        } ;;
    *)
        {
            echo "Unsupported OS, exiting"
            exit
        } ;;
esac

CLANG=clang
CLANGPP=clang++
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Rocksdb
ROCKSDB_GIT=https://github.com/hungptit/rocksdb.git
ROCKSDB_SRC=$SRC_DIR/rocksdb

cd $ROCKSDB_SRC
make clean >> /dev/null
make DEBUG_LEVEL=0 $BUILD_OPTS static_lib CC=$CC CXX=$CXX EXTRA_CXXFLAGS="-O4" EXTRA_CFLAGS="-O4" > /dev/null
cd $ROOT_DIR

# Build jemalloc
JEMALLOC_PREFIX=$SANDBOX
JEMALLOC_SRC=$SRC_DIR/jemalloc
JEMALLOC_BUILD=$SRC_DIR/jemalloc
cd $JEMALLOC_SRC
sh autogen.sh > /dev/null
cd $JEMALLOC_BUILD
$JEMALLOC_SRC/configure --prefix=$JEMALLOC_PREFIX CC=$CC CXX=$CXX > /dev/null
make build_lib_static $BUILD_OPTS > /dev/null
make install
