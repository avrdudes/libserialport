#! /bin/sh

set -ex

cd "$(dirname "$0")"

rm -rf autom4te.cache
autoreconf -vis

for d in _{am,cm}{b,d}
do
    test -d "$d" || continue
    chmod -R +w "$d"
    rm -rf "$d"
done

cmake -S . -B _cmb -D CMAKE_INSTALL_PREFIX:PATH=/usr/local
cmake --build _cmb --verbose
cmake --build _cmb --target install DESTDIR="$PWD/_cmd"

mkdir _amb
cd _amb
configure_args=""
if test -d /usr/lib64; then
    configure_args="$configure_args --libdir=\${exec_prefix}/lib64"
fi
../configure --prefix=/usr/local ${configure_args}
make -j$(nproc) V=1
make install DESTDIR="$PWD/../_amd"
make -j$(nproc) doc
make -j$(nproc) distcheck

cd ..

diff -u \
     <(find _amd | env LC_ALL=C sort | sed 's|^_amd||') \
     <(find _cmd | env LC_ALL=C sort | sed 's|^_cmd||')

diff -u _{am,cm}d/lib/pkgconfig/libserialport.pc
