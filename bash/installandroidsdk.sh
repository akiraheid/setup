#!/bin/bash
set -e

# Install Android Studio SDK

URL="https://dl.google.com/android/repository"
PACKAGE="sdk-tools-linux-3859397.zip"

HOME_DIR="$(readlink -f ~)"
INSTALL_DIR="${HOME_DIR}/.local"
TMP_DIR="${HOME}/tmp/Android-SDK-install"

mkdir -p ${TMP_DIR}
cd ${TMP_DIR}
wget ${URL}/${PACKAGE}
unzip ${PACKAGE}

NEW_NAME=android-sdk
cp -r tools ${INSTALL_DIR}/${NEW_NAME}

export ANDROID_SDK=${INSTALL_DIR}/${NEW_NAME}

echo ${ANDROID_SDK} >> ${HOME}/.path
export PATH="${PATH}:${ANDROID_SDK}"

rm -r ${TMP_DIR}
