#!/bin/bash -e
. /etc/profile.d/modules.sh
module add ci
module add gcc/${GCC_VERSION}
module add cmake
which cmake
if [[ $? != 0 ]] ; then
  exit 1
fi
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
mkdir -p ${SRC_DIR}

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "Seems that the latest version is not available under ${SRC_DIR} - downloading from netlib.org"

  wget http://www.netlib.org/${NAME}/${NAME}-${VERSION}.tgz -O  ${SRC_DIR}/${SOURCE_FILE}
  wget http://www.netlib.org/blas/blas.tgz  -O ${SRC_DIR}/blas.tar.gz
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  # the tarball is there and has finished downlading
    echo "continuing from previous builds, using source at ${SRC_DIR}/${SOURCE_FILE}"
fi
tar xzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
mkdir -p ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
cmake ../ -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${SOFT_DIR}-gcc-${GCC_VERSION}  -DBUILD_SHARED_LIBS=ON
find . -name "*.a"
find . -name "*.so"
