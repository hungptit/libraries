#!/bin/bash
<<<<<<< HEAD
source $LIBRARIES/get_build_options.sh
=======
source get_build_options.sh
>>>>>>> c8a7722de8424954befd1f50972cf560daba0900

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

printf "Build help2man\n"
sh build_using_configure.sh help2man

printf "Build gettext\n"
sh build_using_autogen.sh gettext > /dev/null

printf "Build xz\n"
sh build_using_autogen.sh xz > /dev/null

# printf "Build autoconf\n"
# sh build_using_autogen.sh autoconf > /dev/null

# printf "Build automake\n"
# sh build_using_autogen.sh automake > /dev/null

printf "Build libtool\n"
sh build_using_configure.sh libtool > /dev/null

# printf "Build textinfo\n"
# sh build_using_bootstrap.sh texinfo > /dev/null

sh build_using_configure.sh cmake "" "" > /dev/null &&
sh build_using_bootstrap.sh m4 "" "" > /dev/null
sh build_using_cmake.sh zlib "" > /dev/null
sh build_using_autogen.sh snappy "" "" > /dev/null
sh build_using_make.sh lz4 "" "" > /dev/null
sh build_using_configure.sh graphviz "" "" > /dev/null
sh build_using_autogen.sh jemalloc "" "" > /dev/null 

# # This package does not install files automatically.
sh build_using_make.sh bzip2 "" "" "" > /dev/null

# Build packages that are used to build other packages.
printf "Build cmake\n"
# sh build_using_configure.sh cmake "" "$USE_CLANG" > /dev/null &&

printf  "Build m4\n"
sh build_using_bootstrap.sh m4 "" "$USE_CLANG" > /dev/null

printf "Build zlib"
sh build_using_cmake.sh zlib "" > /dev/null

printf "Build snappy\n"
sh build_using_autogen.sh snappy "" "$USE_CLANG" > /dev/null

printf "Build lz4\n"
sh build_using_autogen.sh lz4 "" "$USE_CLANG" > /dev/null

# printf "Build graphviz\n"
# sh build_using_autogen.sh graphviz "" "" > /dev/null

printf "Build jemalloc\n"
sh build_using_autogen.sh jemalloc "" "" > /dev/null 

# It might take a long time to build git
# sh build_using_make.sh  git  profile" "PROFILE=BUILD install" > /dev/null
