#!/bin/bash
source get_build_options.sh

# Build rocksdb
cd $SRC_DIR/rocksdb
git clean -df
make clean

make DEBUG_LEVEL=0 $BUILD_OPTS static_lib
cd $ROOT_DIR

