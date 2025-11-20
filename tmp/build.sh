#!/bin/bash
set -xe

# Make Homebrew bison take priority
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/flex/bin:$PATH"
export PATH="/usr/local/swig-4.1.0/bin:$PATH"

bison --version
flex --version
swig -version

cmake -DCMAKE_BUILD_TYPE=DEBUG \
  -DTCL_LIBRARY=/opt/homebrew/Cellar/tcl-tk@8/8.6.17/lib/libtcl8.6.dylib \
  -DTCL_HEADER=/opt/homebrew/Cellar/tcl-tk@8/8.6.17/include/tcl-tk/tcl.h \
  -DFLEX_INCLUDE_DIR=/opt/homebrew/opt/flex/include \
  -S . -B build
  
cmake --build build
