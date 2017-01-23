[![Build Status](http://ci.sagrid.ac.za/buildStatus/icon?job=lapack-deploy)](http://ci.sagrid.ac.za/job/lapack-deploy)

# lapack-deploy

Build, test and  scripts necessary to deploy [LAPACK libraries](http://www.netlib.org/lapack/) for CODE-RADE.

# Versions

We build the following versions:

  * 3.7.0

# Dependencies

This project depends on :

  * cmake
  * gcc

## Compilers

Lapack is built with several gcc compilers:

  * 4.9.2
  * 5.4.0
  * 6.3.0

# Configuration

The followig configuration flags are used :

```
cmake ../ -G "Unix Makefiles" \
-DCMAKE_INSTALL_PREFIX=${SOFT_DIR}-gcc-${GCC_VERSION} \
-DBUILD_SHARED_LIBS=ON \
 -D"SITE=${SITE}" \
 -D"USE_XBLAS=off" \
-DLAPACKE=on
```

# Citing
