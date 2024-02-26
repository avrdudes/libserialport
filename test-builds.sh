#! /bin/sh

set -ex

cd "$(dirname "$0")"

rm -rf autom4te.cache
autoreconf -vis

rm -rf _cmb
cmake -S . -B _cmb -D CMAKE_INSTALL_PREFIX:PATH=/usr/local
cmake --build _cmb --verbose
cmake --build _cmb --target install DESTDIR="$PWD/_cmd"

mkdir _amb
cd _amb
../configure --prefix=/usr/local
make -j$(nproc)
make install DESTDIR="$PWD/../_amd"

cd ..

diff -u \
     <(find _amd | env LC_ALL=C sort | sed 's|^_amd||') \
     <(find _cmd | env LC_ALL=C sort | sed 's|^_cmd||')

diff -u _{am,cm}d/lib/pkgconfig/libserialport.pc
