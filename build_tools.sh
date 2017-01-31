#/bin/bash
ROOT_DIR=$PWD
SRC_DIR=$ROOT_DIR/src
TMP_DIR=/tmp/build/
PREFIX_DIR=$SANDBOX

osType=$(uname)
case "$osType" in
    "Darwin")
        {
            NCPUS=9;
            CC=clang
            CXX=clang++
            BUILD_OPTS=-j$((NCPUS+1))
        } ;;
    "Linux")
        {
            NCPUS=$(grep -c ^processor /proc/cpuinfo)
            BUILD_OPTS=-j$((NCPUS+1))
        } ;;
    *)
        {
            echo "Unsupported OS, exiting"
            exit
        } ;;
esac

CC=gcc-6
CXX=g++-6
USE_CLANG="CC=$CC CXX=$CXX CFLAGS=-O4 CXXFLAGS=-O4"

CMAKE_RELEASE_BUILD="-DCMAKE_BUILD_TYPE=Release"
CMAKE_USE_CLANG="-DCMAKE_CXX_COMPILER=${CLANGPP} -DCMAKE_C_COMPILER=${CLANG}"

# Display verbose information
echo "Prefix dir: $PREFIX_DIR"
echo "Root dir: $ROOT_DIR"
echo "Source dir: $SRC_DIR"

# Install autoconf
cd $SRC_FOLDER
wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz
tar xf autoconf-latest.tar.gz
cd autoconf-2.69/
./configure --prefix=$PREFIX_DIR > /dev/null
make $BUILD_OPTS > /dev/null
make install > /dev/null

# CMake

