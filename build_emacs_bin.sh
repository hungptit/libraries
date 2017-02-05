# ********************************
#  Build emacs related packages  *
# ********************************
#!/bin/bash
source get_build_options.sh 

# Build silver searcher
SILVER_SEARCH_GIT=https://github.com/ggreer/the_silver_searcher.git
SILVER_SEARCH_FOLDER=$SRC_DIR/the_silver_searcher
SILVER_SEARCH_PREFIX=$PREFIX

# Prepare the source code
cd $SILVER_SEARCH_FOLDER
git pull

# Now build and install the_silver_searcher
sh build.sh
./configure --prefix=$SILVER_SEARCH_PREFIX CFLAGS="-O4 -Wall"
make $BUILD_OPTS
make install

# ctags
sh build_using_autogen.sh ctags ""

# Build global
GLOBAL_LINK=http://tamacom.com/global/
GLOBAL_FILE=global-6.5.2

cd $SRC_FOLDER
if [ ! -f $GLOBAL_FILE.tar.gz ]; then
    wget $GLOBAL_LINK/$GLOBAL_FILE.tar.gz
fi

# Pull the latest version
tar xf $GLOBAL_FILE.tar.gz
cd $GLOBAL_FILE
make configure
./configure --prefix=$PREFIX"-O3 -Wall" --with-sqlite3 --with-exuberant-ctags=ctags
make $BUILD_OPTS
make install
