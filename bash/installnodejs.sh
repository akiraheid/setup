#!/bin/bash
set -e

# Install the nodejs package

NODE_URL="https://nodejs.org/download/release/latest"
PACKAGE="node-v8.2.1-linux-x64"

HOME_DIR="$(readlink -f ~)"
INSTALL_DIR="${HOME_DIR}/.local"
TMP_DIR="${HOME}/tmp/nodejs-install"
LIB_DIR="${INSTALL_DIR}/lib"
BIN_DIR="${INSTALL_DIR}/bin"
INC_DIR="${INSTALL_DIR}/include"
SHR_DIR="${INSTALL_DIR}/share"

mkdir -p ${TMP_DIR} ${LIB_DIR} ${BIN_DIR} ${INC_DIR} ${SHR_DIR}
cd ${TMP_DIR}
wget ${NODE_URL}/${PACKAGE}.tar.gz
tar -xzf ${PACKAGE}.tar.gz

cp -r ${PACKAGE}/bin/* ${BIN_DIR}/
cp -r ${PACKAGE}/lib/* ${LIB_DIR}/
cp -r ${PACKAGE}/include/* ${INC_DIR}/
cp -r ${PACKAGE}/share/* ${SHR_DIR}/

echo ${LIB_DIR} >> ${HOME}/.path
echo ${BIN_DIR} >> ${HOME}/.path
echo ${INC_DIR} >> ${HOME}/.path
echo ${SHR_DIR} >> ${HOME}/.path

rm -r ${TMP_DIR}
