#!/bin/bash
source get_build_options.sh

get_bzip2() {    
    BZIP2_STEM=bzip2-1.0.6
    BZIP2_FILE=${BZIP2_STEM}.tar.gz
    BZIP2_LINK=http://bzip.org/1.0.6/${BZIP2_STEM}.tar.gz
    cd $SRC_DIR
    echo $SRC_DIR
    if [ ! -f $BZIP2_FILE ]; then
        wget $BZIP2_LINK
    fi

    if [ ! -d $BZIP2_STEM ]; then
        tar xf $BZIP2_FILE
    fi

    cd $ROOT_DIR
}


# Build packages that are used to build other packages.
sh build_using_configure.sh cmake "" "$USE_CLANG" > /dev/null &&
sh build_using_bootstrap.sh m4 "" "$USE_CLANG" > /dev/null
sh build_using_configure.sh zlib "" "$USE_CLANG" > /dev/null
sh build_using_autogen.sh snappy "" "$USE_CLANG" > /dev/null
sh build_using_autogen.sh lz4 "" "$USE_CLANG" > /dev/null
sh build_using_autogen.sh graphviz "" "$USE_CLANG" > /dev/null
sh build_using_autogen.sh jemalloc "" "$USE_CLANG" > /dev/null 

# This package does not install files automatically.
get_bzip2;
sh build_using_make.sh bzip2-1.0.6 "" "$USE_CLANG" "" > /dev/null

# It might take a long time to build git
# sh build_using_make.sh  git  profile" "PROFILE=BUILD install" > /dev/null
