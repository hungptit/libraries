#/bin/bash

PREFIX_FOLDER=/home/$USER/sandbox
ROOT_FOLDER=$PWD
SRC_FOLDER=$ROOT_FOLDER/src
MAKE_OPTS="-j32"

# Install autoconf
cd $SRC_FOLDER
wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz
tar xf autoconf-latest.tar.gz
cd autoconf-2.69/
./configure --prefix=$PREFIX_FOLDER
make $MAKE_OPTS
make install
