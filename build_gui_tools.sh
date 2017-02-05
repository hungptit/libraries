#!/bin/bash
source get_build_options.sh
sh build_using_cmake.sh  sqlitebrowser "" "$USE_CLANG" > /dev/null
# sh build_using_make.sh  git "PROFILE=BUILD install" > /dev/null
