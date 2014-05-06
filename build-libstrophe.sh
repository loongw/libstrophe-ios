#!/bin/sh

#  Automatic build script for libstrophe
#  for iPhoneOS and iPhoneSimulator with Xcode 5.0
#
#  Created by Christopher A. Taylor (2013)
#
###########################################################################
#  Change values here							  #
#									  #
SDKVERSION="7.1"							  #
#									  #
###########################################################################
#									  #
# Don't change anything under this line!				  #
#									  #
###########################################################################

CURRENTPATH=`pwd`
DEVELOPER=`xcode-select --print-path`
PACKAGE="libstrophe"


cd libstrophe

############
# iPhone Simulator
ARCH="i386"
PLATFORM="iPhoneSimulator"
echo "Building ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"
echo "Please stand by..."

#export CC="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/usr/bin/gcc -arch ${ARCH}"
mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}.sdk"

echo "Configure ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"

./configure BSD-generic32

# add -isysroot to CC=
#sed -ie "s!^CFLAG=!CFLAG=-isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk !" "Makefile"
#sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=${SDKVERSION} !" "Makefile"
#sed -ie "s!^CFLAG=!CFLAG=-mstackrealign !" "Makefile"

CC="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/usr/bin/gcc -arch ${ARCH} -isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk -pipe -Os -gdwarf-2 -miphoneos-version-min=${SDKVERSION}" ./configure --host=${ARCH}-apple-darwin

echo "Make ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"

make libstrophe.a
#make install
cp "${CURRENTPATH}/libstrophe/libstrophe.a" "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}.sdk/"
cp "${CURRENTPATH}/libstrophe/strophe.h" "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}.sdk/"
make clean

echo "Building ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}, finished"
#############

#############
# iPhoneOS armv7
ARCH="armv7"
PLATFORM="iPhoneOS"
echo "Building ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"
echo "Please stand by..."

# /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang

mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"

echo "Configure ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"

CC="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -g -arch ${ARCH} -isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk -pipe -Os -gdwarf-2 -miphoneos-version-min=${SDKVERSION}" ./configure --host=${ARCH}-apple-darwin

#sed -ie "s!^CFLAG=!CFLAG=-isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk !" "Makefile"
#sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=${SDKVERSION} !" "Makefile"
# remove sig_atomic for iPhoneOS
#sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c"

echo "Make ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"

make -j libstrophe.a
#make install
cp "${CURRENTPATH}/libstrophe/libstrophe.a" "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/"
cp "${CURRENTPATH}/libstrophe/strophe.h" "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/"
make clean

echo "Building ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}, finished"
#############

#############
# iPhoneOS armv7s
ARCH="armv7s"
PLATFORM="iPhoneOS"
echo "Building ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"
echo "Please stand by..."

export CC="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch ${ARCH}"
mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"

echo "Configure ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"

CC="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -arch ${ARCH} -isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk -pipe -Os -gdwarf-2 -miphoneos-version-min=${SDKVERSION}" ./configure --host=${ARCH}-apple-darwin

#sed -ie "s!^CFLAG=!CFLAG=-isysroot ${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk !" "Makefile"
#sed -ie "s!^CFLAG=!CFLAG=-miphoneos-version-min=${SDKVERSION} !" "Makefile"
# remove sig_atomic for iPhoneOS
#sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c"

echo "Make ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}"

make -j libstrophe.a
#make install
cp "${CURRENTPATH}/libstrophe/libstrophe.a" "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/"
cp "${CURRENTPATH}/libstrophe/strophe.h" "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/"
make clean

echo "Building ${PACKAGE} for ${PLATFORM} ${SDKVERSION} ${ARCH}, finished"

#############

#############
# Universal Library
echo "Build universal library..."

lipo -create ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/libstrophe.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/libstrophe.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7s.sdk/libstrophe.a -output ${CURRENTPATH}/libstrophe.a

mkdir -p ${CURRENTPATH}/include
cp ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/strophe.h ${CURRENTPATH}/include/
echo "Building done."

echo "Cleaning up..."
rm -rf ${CURRENTPATH}/src
rm -rf ${CURRENTPATH}/bin
echo "Done."

