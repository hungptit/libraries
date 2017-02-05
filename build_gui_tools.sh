#!/bin/bash
source get_build_options.sh
sh build_using_cmake.sh  sqlitebrowser "" "$USE_CLANG" > /dev/null

