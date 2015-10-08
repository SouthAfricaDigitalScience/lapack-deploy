#!/bin/bash
. /usr/share/modules/init/bash
module add ci
module add gcc/${GCC_VERSION}
module add cmake
which cmake
if [[ $? != 0 ]] ; then
  exit 1
fi
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
mkdir -p ${SRC_DIR}
if [[ ! -s ${SRC_DIR}/${SOURCE_FILE} ]] ; then
  echo "Seems that the latest version is not available under ${SRC_DIR} - downloading from netlib.org"
  wget http://www.netlib.org/${NAME}/${NAME}-${VERSION}.tgz -O  ${SRC_DIR}/${SOURCE_FILE}
  wget http://www.netlib.org/blas/blas.tgz  ${SRC_DIR}/blas.tar.gz
  tar xzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE}
fi
cd $NAME-$VERSION
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=$SOFT_DIR  -DBUILD_SHARED_LIBS=ON
nice -n20 make

find . -name "*.a"
find . -name "*.so"
