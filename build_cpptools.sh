#!/bin/bash
source ./get_build_options.sh

install_tbb() {
    TBB_RELEASE="tbb44_20160316oss_src"
    TBB_FOLDER="tbb-2017_U5"
    TBB_LINK=https://github.com/01org/tbb/archive/2017_U5.tar.gz
    TBB_PREFIX=$ROOT_DIR/tbb
    TBB_FILE="2017_U5.tar.gz"

    cd $SRC_DIR

    # Install TBB
    if [ ! -f $TBB_FILE ]; then
        wget --no-check-certificate $TBB_LINK
    fi

    tar xf $TBB_FILE
	rm -rf $TBB_PREFIX
    mv $TBB_FOLDER $TBB_PREFIX

    cd $TBB_PREFIX
    make clean

	# Customize some variables to make this build portable.
	make $BUILD_OPTS CXXFLAGS="-O3 -march=native" LIBS="-static"
	# make $BUILD_OPTS CXXFLAGS="-O3 -march=native" LIBS="/home/hdang/.linuxbrew/lib/libm.a"

	mkdir -p lib
    cp build/linux_intel64_gcc_cc*_release/*.so* lib/
    cd $EXTERNAL_FOLDER
}

install_eigen() {
    EIGEN_SRC=$SRC_FOLDER/eigen
    EIGEN_BUILD_FOLDER=$TMP_FOLDER/eigen/
    EIGEN_PREFIX=$EXTERNAL_FOLDER/eigen

    MERCURIAL_VERSION=3.2.4
    MERCURIAL_PREFIX=$EXTERNAL_FOLDER/mercurial
    MERCURIAL=$MERCURIAL_PREFIX-$MERCURIAL_VERSION/hg

    cd $SRC_FOLDER
    if [ -d $EIGEN_SRC ];
    then
        cd $EIGEN_SRC
        $MERCURIAL pull
        $MERCURIAL update
    else
        cd $SRC_FOLDER
        $MERCURIAL clone https://bitbucket.org/eigen/eigen/
        cd $EIGEN_SRC
    fi
    rm -rf $EIGEN_BUILD_FOLDER
    mkdir $EIGEN_BUILD_FOLDER
    cd $EIGEN_BUILD_FOLDER
    $CMAKE $EIGEN_SRC -DCMAKE_INSTALL_PREFIX=$EIGEN_PREFIX $CMAKE_RELEASE_BUILD
    make install $BUILD_OPTS
    rm -rf $EIGEN_BUILD_FOLDER
}

build_libmemcached() {
    LIBMEMCACHED_LINK=https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
    LIBMEMCACHED_FILE=libmemcached-1.0.18.tar.gz
    LIBMEMCACHED_FOLDER=$SRC_FOLDER/libmemcached-1.0.18
    LIBMEMCACHED_PREFIX=$EXTERNAL_FOLDER/libmemcached

    if [ ! -f $LIBMEMCACHED_FILE ]; then
        cd $SRC_FOLDER
        tar xf $LIBMEMCACHED_FILE
    fi

    cd $LIBMEMCACHED_FOLDER
    ./configure --prefix=$LIBMEMCACHED_PREFIX --with-memcached=$MEMCACHED_PREFIX
    make $BUILD_OPTS
    make install
}

build_casablanca() {
    CPPRESTSDK_GIT=https://github.com/Microsoft/cpprestsdk.git
    CPPRESTSDK_SRC=$SRC_FOLDER/cpprestsdk
    CPPRESTSDK_PREFIX=$EXTERNAL_FOLDER/cpprestsdk
    CPPRESTSDK_BUILD=$TMP_FOLDER/cpprestsdk
    if [ ! -d $CPPRESTSDK_SRC ]; then
        cd $SRC_FOLDER
        $GIT clone $CPPRESTSDK_GIT
    fi

    cd $CPPRESTSDK_SRC
    $GIT fetch -a
    $GIT checkout hungptit      # Apply fix for clang
    $GIT merge master
    $GIT pull

    # Build Casablanca
    rm -rf $CPPRESTSDK_BUILD
    mkdir $CPPRESTSDK_BUILD
    cd $CPPRESTSDK_BUILD

    # Use customized boost libraries
    # $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD -DBOOST_ROOT=$EXTERNAL_FOLDER/boost/ -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0 $CMAKE_USE_CLANG

    $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD -DBOOST_ROOT=$EXTERNAL_FOLDER/boost/ -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0

    # Use system boost libraries
    # $CMAKE $CPPRESTSDK_SRC/Release -DCMAKE_INSTALL_PREFIX=$CPPRESTSDK_PREFIX $CMAKE_RELEASE_BUILD $CMAKE_USE_CLANG -DBoost_USE_MULTITHREADED=ON -DBUILD_SHARED_LIBS=0

    make $BUILD_OPTS
    make install
}

echo "Install TBB"
install_tbb > /dev/null

# echo "Install eigen"
# install_eigen > /dev/null

# if [ ! -d $HDF5_SRC  ]; then
#     git clone $HDF5_GIT
# fi

# # Check out the latest version
# cd $HDF5_SRC
# git pull;

# # Now build and install the library
# ./configure --prefix=$HDF5_PREFIX --with-zlib=$ZLIB_PREFIX --enable-hl --enable-production --enable-cxx --enable-static-exec --enable-shared=0
# make $BUILD_OPTS

# make install
