#!/bin/bash

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

build_bzip2() {
    BZIP2_FILE=bzip2-1.0.6.tar.gz
    BZIP2_LINK=http://www.bzip.org/1.0.6/${BZIP2_FILE}
    BZIP2_SRC=$SRC_FOLDER/bzip2-1.0.6
    BZIP2_BUILD=$TMP_FOLDER/bzip2
    BZIP2_PREFIX=$EXTERNAL_FOLDER/bzip2

    cd $SRC_FOLDER
    if [ ! -f $BZIP2_FILE ]; then
        wget $BZIP2_LINK
    fi

    if [ ! -d $BZIP2_SRC ]; then
        tar xf $BZIP2_FILE
    fi

    cd $BZIP2_SRC
    make clean
    make $BUILD_OPTS CC=$CLANG CXX=$CLANGPP CFLAGS="-O4 -Wall" CXXFLAGS="-O4 -Wall" 
    rm -rf $BZIP2_PREFIX
    make install PREFIX=$BZIP2_PREFIX
    cd $EXTERNAL_FOLDER;
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

# Build packages
echo "Build CMake"
sh build_using_configure.sh cmake "" "$USE_CLANG"

# echo "Build sqlitebrowser"
# sh build_using_cmake.sh $EXTERNAL_FOLDER sqlitebrowser https://github.com/sqlitebrowser/sqlitebrowser "" > /dev/null

# echo "Build graphviz"
# sh build_using_autogen.sh graphviz https://github.com/ellson/graphviz.git "$USE_CLANG"  > /dev/null

# echo "Build lz4"
# sh build_using_make.sh $EXTERNAL_FOLDER lz4 https://github.com/Cyan4973/lz4 "" "$USE_CLANG"  > /dev/null

# echo "Build zlib"
# sh build_using_configure_notmpdir.sh $EXTERNAL_FOLDER zlib https://github.com/madler/zlib "" "$USE_CLANG"  > /dev/null

# echo "Build mercurial"
# build_mercurial > /dev/null;

# echo "Build bzip2"
# build_bzip2 > /dev/null;

# echo "Build Git"
# sh build_using_make.sh $EXTERNAL_FOLDER git https://github.com/git/git.git "" "profile" "PROFILE=BUILD install" > /dev/null
