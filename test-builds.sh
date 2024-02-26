#! /bin/sh

set -ex

cd "$(dirname "$0")"

rm -rf autom4te.cache
autoreconf -vis

find_in_path() {
  local d
  local saved_IFS
  saved_IFS="$IFS"
  IFS=":"
  for d in $PATH
  do
    IFS="$saved_IFS"
    if test -x "$d/$1"
    then
      echo "$d/$1"
      return 0
    fi
  done
  IFS="$saved_IFS"
  return 1
}

for d in _{am,cm}{b,d}{,-w64}
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
cd ..

if find_in_path mingw64-configure && find_in_path mingw64-make
then
  mkdir _amb-w64
  cd _amb-w64
  mingw64-configure
  mingw64-make -j$(nproc) V=1
  mingw64-make install DESTDIR="$PWD/../_amd-w64"
  cd ..
fi

cd _amb
make -j$(nproc) doc
make -j$(nproc) distcheck
cd ..

diff -u \
     <(find _amd | env LC_ALL=C sort | sed 's|^_amd||') \
     <(find _cmd | env LC_ALL=C sort | sed 's|^_cmd||') \
||:

diff -u _{am,cm}d/lib/pkgconfig/libserialport.pc \
||:

diff -u \
     <(find _amd     -not -type d | env LC_ALL=C sort | sed 's|^_amd||'     | sed 's|^/usr/local||' | sed 's|^/lib64/|/lib/|') \
     <(find _amd-w64 -not -type d | env LC_ALL=C sort | sed 's|^_amd-w64||' | sed 's|^/usr/x86_64-w64-mingw32/sys-root/mingw||') \
||:

