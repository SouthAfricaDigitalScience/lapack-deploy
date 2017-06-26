#!/bin/bash
. /etc/profile.d/modules.sh
module add ci
module add cmake
module add gcc/${GCC_VERSION}
module  add python/${PYTHON_VERSION}-gcc-${GCC_VERSION}
echo "going to $WORKSPACE/$NAME-$VERSION"
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
make test
make install
echo "In ${SOFT_DIR}-gcc-${GCC_VERSION} we have "
ls ${SOFT_DIR}-gcc-${GCC_VERSION}
# on SL6 , there is only a lib64 directory created - if the lib dir is missing, link lib64 to it.
if [ ! -d ${SOFT_DIR}-gcc-${GCC_VERSION}/lib ] ; then
  echo "linking lib dir"
  ln -s -v ${SOFT_DIR}-gcc-${GCC_VERSION}/lib64 ${SOFT_DIR}-gcc-${GCC_VERSION}/lib
fi

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
module-whatis   "$NAME $VERSION."
setenv       LAPACK_VERSION    $VERSION-gcc-${GCC_VERSION}
setenv       LAPACK_DIR        /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}
prepend-path LD_LIBRARY_PATH   $::env(LAPACK_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(LAPACK_DIR)/include
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}

mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION}-gcc-${GCC_VERSION} ${LIBRARIES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}
module avail
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
