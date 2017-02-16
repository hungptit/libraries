#!/bin/bash
source ./get_build_options.sh
# Install libsodium
sh build_using_configure.sh libsodium  "" ""

# Install ZeroMQ
sh build_using_autogen.sh  libzmq "--with-libsodium=no " "LDFLAGS=-lrt -lpthread -ldl"

# Install zguide
cd $SRC_DIR/zguide
# ./bin/buildpdfs
