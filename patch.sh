#!/bin/sh

cp "${CURRENTPATH}/tls_securetransport.c" "${CURRENTPATH}/libstrophe/src/"

cp -R "${CURRENTPATH}/expat/" "${CURRENTPATH}/libstrophe/src/"

cp "${CURRENTPATH}/Makefile.am" "${CURRENTPATH}/libstrophe/"

cd "${CURRENTPATH}/libstrophe"

#sed -ie "s/-lssl -lcrypto -lz/-lz/g" "Makefile.am"
#sed -ie "s/tls_openssl.c/tls_securetransport.c/g" "Makefile.am"
sed -ie "s/AC_CHECK_HEADER(openssl\/ssl.h/#AC_CHECK_HEADER(sslblahblah/g" "configure.ac"
sed -ie "s/AC_CHECK_HEADER(expat.h/AC_CHECK_HEADER(stdlib.h/g" "configure.ac"
sed -ie "s/#include <expat.h>/#include \"expat.h\"/g" "src/parser_expat.c"

