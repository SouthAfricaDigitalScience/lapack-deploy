#!/bin/bash
. /etc/profile.d/modules.sh
module add deploy
module add cmake
module add gcc/${GCC_VERSION}
echo "going to $WORKSPACE/$NAME-$VERSION"
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
rm -rf *
cmake ../ -G "Unix Makefiles" \
-DCMAKE_INSTALL_PREFIX=${SOFT_DIR}-gcc-${GCC_VERSION} \
-DBUILD_SHARED_LIBS=ON \
 -D"SITE=${SITE}" \
 -D"USE_XBLAS=off" \
-DLAPACKE=on
make all
# how about actually install
make install
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
module add gcc/${GCC_VERSION}
module-whatis   "$NAME $VERSION. See https://github.com/SouthAfricaDigitalScience/lapack-deploy"
setenv       LAPACK_VERSION    $VERSION
setenv       LAPACK_DIR        $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}
prepend-path LD_LIBRARY_PATH   $::env(LAPACK_DIR)/lib
prepend-path LD_LIBRARY_PATH   $::env(LAPACK_DIR)/lib64
prepend-path GCC_INCLUDE_DIR   $::env(LAPACK_DIR)/include
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION}-gcc-${GCC_VERSION} ${LIBRARIES_MODULES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}
module avail
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
