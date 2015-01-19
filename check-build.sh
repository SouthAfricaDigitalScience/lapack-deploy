#!/bin/bash
module add ci
module add cmake
echo "going to $WORKSPACE/$NAME-$VERSION"
cd $WORKSPACE/$NAME-$VERSION
make test
python lapack_testing.py
echo "Making modulefile"
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
  puts stderr "       This module does nothing but alert the user"
  puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       LAPACK_VERSION       $VERSION
setenv       LAPACK_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(LAPACK_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(LAPACK_DIR)/include
MODULE_FILE
) > modules/$VERSION

mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME
module avail
module add lapack
