#!/bin/bash
sh get_build_options.sh;

# Build given package
APKG_SRC=$SRC_DIR/$PKGNAME
APKG_BUILD_FOLDER=$APKG_SRC/build
APKG_PREFIX=$PREFIX

echo "Src folder: " $APKG_SRC
echo "Build folder: " $APKG_BUILD_FOLDER
echo "Prefix folder: " $APKG_PREFIX

# Build a given package
cd $APKG_SRC
make clean
make $BUILD_OPTS $EXTRA_MAKE_OPTIONS
make PREFIX=$APKG_PREFIX install

# Return to the external folder.
cd $ROOT_DIR
