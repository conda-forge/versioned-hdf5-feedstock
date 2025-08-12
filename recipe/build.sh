#!/bin/bash
set -o errexit
set -o xtrace

# Let macos-arm64 cross-compilation find hdf5
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  cat > $BUILD_PREFIX/lib/pkgconfig/hdf5.pc<<EOF
prefix=$BUILD_PREFIX
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: hdf5
Description: HDF5 (Hierarchical Data Format 5) Software Library
Version: ${hdf5}

Cflags: -I\${includedir}
Libs: -L\${libdir}  -lhdf5
Requires:
Libs.private:   -lzlib-static
Requires.private:
EOF

  cat $BUILD_PREFIX/lib/pkgconfig/hdf5.pc
  export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
  pkg-config --modversion hdf5
fi

$PYTHON -m build --wheel --no-isolation --skip-dependency-check -Csetup-args=${MESON_ARGS// / -Csetup-args=}
$PYTHON -m pip install dist/*.whl
