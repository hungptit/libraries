#!/bin/bash
source ./get_build_options.sh
sh build_using_cmake.sh  sqlitebrowser "" "" > /dev/null
sh build_using_cmake.sh tidy-html5 "" > /dev/null
