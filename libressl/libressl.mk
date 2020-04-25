TARG = libressl

<$mkbuild/mk.common-noinst

libressl:QV:
	CC="$CC -static" ./configure \
		--build="${TOOLCHAIN_TRIPLET}" \
		--host="${HOST_TOOLCHAIN_TRIPLET}" \
		--prefix="$PREFIX" \
		--mandir="$ROOT/share/man" \
		--disable-shared \
		--enable-static
	# Set path to libssl.a and libcrypto.a for apps/.
	#export LDFLAGS="-all-static $LDFLAGS -L`pwd`/crypto -L`pwd`/ssl -lcrypto -lssl"
	mv libtool libtool.old
	sed -e 's/ -shared / -Wl,-O1,--as-needed -static\0/g' libtool.old > libtool
	make -j$nprocs V="1" LDFLAGS="$LDFLAGS"
	# install lib for use as a dependency.
	make -j$nprocs install DESTDIR="`pwd`/lib" V="1"
	# remove .la files for now ?
	find `pwd`/lib -iname "*.la" -exec rm {} \;

install:QV:
	make -j$nprocs install DESTDIR="$ROOT" V="1"
