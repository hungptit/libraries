#!/bin/bash
source ./get_build_options.sh;  # Initialize all required variables.

build_git() {
    cd $SRC_DIR/git
    git clean -df
    git pull
    make clean
    make configure
    ./configure --prefix=$ROOT_DIR
    make install $BUILD_OPTS
    cd $ROOT_DIR
}

# Download all required packages
cd $ROOT_DIR
printf "Download all required package for build process!\n"
sh download_source_code.sh http://ftp.gnu.org/gnu/help2man/help2man-1.47.4.tar.xz help2man
sh download_source_code.sh http://ftp.gnu.org/gnu/texinfo/texinfo-6.3.tar.xz texinfo
sh download_source_code.sh http://tukaani.org/xz/xz-5.2.3.tar.gz xz
sh download_source_code.sh http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz autoconf
sh download_source_code.sh http://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz automake
sh download_source_code.sh http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz libtool
sh download_source_code.sh http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.tar.xz gettext
sh download_source_code.sh http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz bzip2
sh download_source_code.sh http://alpha.gnu.org/gnu/make/make-4.1.90.tar.gz make
sh download_source_code.sh http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz

printf "Build all required packages\n";

# We need to build git first
printf "Build git\n"
build_git > /dev/null;

printf "Build help2man\n"
sh build_using_configure.sh help2man > /dev/null

printf "Build gettext\n"
sh build_using_autogen.sh gettext > /dev/null

printf "Build make\n"
sh build_using_configure.sh make > /dev/null

printf "Build xz\n"
sh build_using_autogen.sh xz > /dev/null

printf "Build autoconf\n"
sh build_using_autogen.sh autoconf > /dev/null

printf "Build automake\n"
sh build_using_autogen.sh automake > /dev/null

printf "Build htop\n"
sh build_using_autogen.sh htop > /dev/null

printf "Build gperf\n"
sh build_using_configure.sh gperf > /dev/null 

printf "Build libtool\n"
sh build_using_configure.sh libtool > /dev/null

printf "Build coreutils\n"
sh build_using_bootstrap.sh coreutils > /dev/null

printf "Build textinfo\n"
sh build_using_bootstrap.sh texinfo > /dev/null

printf "Build cmake\n";
sh build_using_configure.sh cmake "" "" > /dev/null

printf "Build m4\n"
sh build_using_bootstrap.sh m4 "" "" > /dev/null

printf "Build zlib\n"
sh build_using_cmake.sh zlib "" > /dev/null

printf "Build snappy\n"
sh build_using_autogen.sh snappy "" "" > /dev/null

printf "Build lz4\n"
sh build_using_make.sh lz4 "" "" > /dev/null

printf "Build graphviz\n"
sh build_using_autogen.sh graphviz "" "" > /dev/null

printf "Build jemalloc\n"
sh build_using_autogen.sh jemalloc "" "" > /dev/null

printf "Build bzip2\n"
sh build_using_make.sh bzip2 "" "" "" > /dev/null

printf "Build doxygen\n";
sh build_using_cmake.sh doxygen "" > /dev/null

printf "Build Poco\n"
sh build_using_cmake.sh poco "-DPOCO_STATIC=TRUE -DENABLE_DATA_ODBC=FALSE -DENABLE_DATA_MYSQL=FALSE -DENABLE_MONGODB=FALSE" > /dev/null

printf "Build Celero\n"
./build_using_cmake.sh Celero > /dev/null

printf "Build google test\n"
./build_using_cmake.sh googletest > /dev/null

printf "Build benchmark"
./build_using_cmake.sh benchmark > /dev/null

printf "Install libsodium\n"
sh build_using_autogen.sh libsodium  "" "" > /dev/null

printf "Install ZeroMQ\n"
./build_using_cmake.sh  libzmq "-DWITH_LIBSODIUM=FALSE -DWITH_DOC=FALSE " > /dev/null

# TODO: Fix rtags build issues because cmake could not find libclang.
printf "Build rtags"
./build_using_cmake.sh rtags > /dev/null
