#!/bin/bash
source get_build_options.sh 

LLVM_FOLDER=$SRC_DIR/llvm
LLVM_BUILD_FOLDER=$TMP_DIR/build
LLVM_PREFIX=$ROOT_DIR

echo "LLVM_FOLDER: $LLVM_FOLDER"
echo "LLVM_BUILD_FOLDER: $LLVM_BUILD_FOLDER"
echo "LLVM_PREFIX: $LLVM_PREFIX"

get_source_code() {
    ROOT_DIR=$1
    PACKAGE_NAME=$2
    GIT_LINK=$3

    cd $ROOT_DIR
    if [ ! -d $PACKAGE_NAME ]; then
        git clone $GIT_LINK $PACKAGE_NAME
    fi
    PKG_DIR=$ROOT_DIR/$PACKAGE_NAME
    cd $PKG_DIR
            
    git clean -df
    git checkout $LLVM_TAG
    git pull
}

cd $SRC_DIR

# Get LLVM source code
# LLVM_TAG="release_39"
LLVM_TAG="master"

get_source_code $SRC_DIR llvm http://llvm.org/git/llvm.git $LLVM_TAG

LLVM_SRC=$SRC_DIR/llvm
mkdir -p $LLVM_SRC/tools
mkdir -p $LLVM_SRC/projects

# Get clang and clang-extra-tools
get_source_code $LLVM_SRC/tools clang http://llvm.org/git/clang.git $LLVM_TAG
get_source_code $LLVM_SRC/tools/clang/tools extra http://llvm.org/git/clang-tools-extra.git $LLVM_TAG

# Comment below lines if the build process is failed.
get_source_code $LLVM_SRC/projects compiler-rt http://llvm.org/git/compiler-rt.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects openmp http://llvm.org/git/openmp.git $LLVM_TAG
get_source_code $LLVM_SRC/projects libcxx http://llvm.org/git/libcxx.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects libcxxabi http://llvm.org/git/libcxxabi.git $LLVM_TAG
# get_source_code $LLVM_SRC/projects test-suite http://llvm.org/git/test-suite.git $LLVM_TAG

# Build LLVM
mkdir -p $LLVM_BUILD_FOLDER
cd $LLVM_BUILD_FOLDER
$CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $CMAKE_USE_CLANG $LLVM_FOLDER 
# $CMAKE -DCMAKE_INSTALL_PREFIX:PATH=$LLVM_PREFIX -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_TESTING:BOOL=OFF $LLVM_FOLDER 
make $BUILD_OPTS
make $BUILD_OPTS install
