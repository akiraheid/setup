#!/bin/bash
set -e

# Install nodejs package to ~/bin, ~/include, and ~/lib

NODE_URL="https://nodejs.org/download/release/latest"
PACKAGE="node-v8.2.1-linux-x64"

HOME_DIR="$(readlink -f ~)"
TMP_DIR="${HOME_DIR}/tmp/nodejs-install"
LIB_DIR="${HOME_DIR}/lib"
BIN_DIR="${HOME_DIR}/bin"
INC_DIR="${HOME_DIR}/include"
SHR_DIR="${HOME_DIR}/share"

mkdir -p ${TMP_DIR} ${LIB_DIR} ${BIN_DIR} ${INC_DIR} ${SHR_DIR}
cd ${TMP_DIR}
#wget ${NODE_URL}/${PACKAGE}.tar.gz
#tar -xzf ${PACKAGE}

cp -r ${PACKAGE}/bin/* ${BIN_DIR}/
cp -r ${PACKAGE}/lib/* ${LIB_DIR}/
cp -r ${PACKAGE}/include/* ${INC_DIR}/
cp -r ${PACKAGE}/share/* ${SHR_DIR}/
