#!/bin/bash
# Build given package
EXTERNAL_FOLDER=$1
PKGNAME=$2
PKGGIT=$3
CMAKE_OPTIONS=$4

SRC_FOLDER=$EXTERNAL_FOLDER/src
TMP_FOLDER=/tmp/build/

mkdir -p $TMP_FOLDER
mkdir -p $SRC_FOLDER

NCPUS=$(grep -c ^processor /proc/cpuinfo)
BUILD_OPTS=-j$((NCPUS+1))

# Setup clang
CLANG=$EXTERNAL_FOLDER/llvm/bin/clang
CLANGPP=$EXTERNAL_FOLDER/llvm/bin/clang++
if [ ! -f $CLANGPP ]; then
    # Fall back to gcc if we do not have clang installed.
    CLANG=gcc
    CLANGPP=g++
fi

# Setup CMake
CMAKE_PREFIX=$EXTERNAL_FOLDER/cmake
CMAKE=$CMAKE_PREFIX/bin/cmake
if [ ! -f $CMAKE ]; then
    # Use system CMake if we could not find the customized CMake.
    CMAKE=cmake
fi
CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE:STRING=Release"

# Setup git
GIT_PREFIX=$EXTERNAL_FOLDER/git
GIT=$GIT_PREFIX/bin/git
if [ ! -f $GIT ]; then
    # Use system CMake if we could not find the customized CMake.
    GIT=git
fi

APKG_SRC=$SRC_FOLDER/$PKGNAME
APKG_BUILD_FOLDER=$TMP_FOLDER/$PKGNAME
APKG_PREFIX=$EXTERNAL_FOLDER/$PKGNAME

echo "Src folder: " $APKG_SRC
echo "Build folder: " $APKG_BUILD_FOLDER
echo "Prefix folder: " $APKG_PREFIX
echo "Clang: " $CLANG
echo "CMake: " $CMAKE

sh install_pkg.sh $EXTERNAL_FOLDER $PKGNAME $PKGGIT $SRC_FOLDER

# Build a given package
rm -rf $APKG_BUILD_FOLDER
mkdir -p $APKG_BUILD_FOLDER
cd $APKG_BUILD_FOLDER
$CMAKE $APKG_SRC -DCMAKE_INSTALL_PREFIX=$APKG_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_OPTIONS 
make $BUILD_OPTS $EXTRA_MAKE_OPTIONS
make install
cd $EXTERNAL_FOLDER

rm -rf $APKG_BUILD_FOLDER

# Return to the external folder.
cd $EXTERNAL_FOLDER
