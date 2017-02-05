#!/bin/bash
source get_build_options.sh

build_mercurial() {
    cd $SRC_FOLDER
    MERCURIAL_VERSION=3.2.4
    MERCURIAL_FILE=mercurial-3.2.4.tar.gz
    MERCURIAL_PREFIX=$EXTERNAL_FOLDER/mercurial
    MERCURIAL=$MERCURIAL_PREFIX-$MERCURIAL_VERSION/hg

    cd $SRC_FOLDER
    if [ ! -f $MERCURIAL_FILE ]; then
        wget http://mercurial.selenic.com/release/mercurial-3.2.4.tar.gz;
    fi

    tar -xf $SRC_FOLDER/$MERCURIAL_FILE -C $EXTERNAL_FOLDER
    cd $MERCURIAL_PREFIX-$MERCURIAL_VERSION
    make local $BUILD_OPTS
    cd $EXTERNAL_FOLDER;
}

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

build_python() {
    PYTHON_FILE=Python-3.5.1
    PYTHON_SRC=$SRC_FOLDER/$PYTHON_FILE
    PYTHON_LINK=https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz
    PYTHON_PREFIX=$EXTERNAL_FOLDER/python
    cd $SRC_FOLDER
    wget $PYTHON_LINK
    tar xf $PYTHON_FILE.tgz

    cd $PYTHON_SRC
    ./configure --prefix=$PYTHON_PREFIX
    make $BUILD_OPTS CC=$CLANG CXX=$CLANGPP CFLAGS="-O4 -Wall" CXXFLAGS="-O3 -Wall"
    make install
}

# Build packages that are used to build other packages.
# sh build_using_configure.sh cmake "" "$USE_CLANG" > /dev/null &&
# sh build_using_bootstrap.sh m4 "" "$USE_CLANG" > /dev/null
# sh build_using_configure.sh zlib "" "$USE_CLANG" > /dev/null
# sh build_using_autogen.sh snappy "" "$USE_CLANG" > /dev/null
# sh build_using_autogen.sh lz4 "" "$USE_CLANG" > /dev/null
# sh build_using_autogen.sh graphviz "" "$USE_CLANG" > /dev/null

# This package does not install the library automatically.
# get_bzip2;
# sh build_using_make.sh bzip2-1.0.6 "" "$USE_CLANG" "" > /dev/null

# It might take a long time to build git
# sh build_using_make.sh  git  profile" "PROFILE=BUILD install" > /dev/null
