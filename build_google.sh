#!/bin/bash
source get_build_options.sh 

build_leveldb() {
    LEVELDB_DIR=$SRC_DIR/leveldb
    cd $LEVELDB_DIR
    make clean
    git pull
    make $BUILD_OPTS
    cd $ROOT_DIR
}

# Build all required packages
build_leveldb > /dev/null
sh build_using_cmake.sh gtest > /dev/null 
sh build_using_cmake.sh benchmark > /dev/null
