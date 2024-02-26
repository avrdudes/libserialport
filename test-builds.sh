#! /usr/bin/env bash
#
# Bash features used:
#   - process substitution: <()
#   - arrays: declare -a
#   - brace globs: {foo,bar}

set -ex

cd "$(dirname "$0")"

rm -rf autom4te.cache
${AUTORECONF-autoreconf} -vis

find_in_path() {
    case "$1" in
	/*)
	    echo "$1"
	    return 0
	    ;;
    esac
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

${CMAKE-cmake} -S . -B _cmb -D CMAKE_INSTALL_PREFIX:PATH=/usr/local
${CMAKE-cmake} --build _cmb --verbose
${CMAKE-cmake} --build _cmb --target install DESTDIR="$PWD/_cmd"

mkdir _amb
cd _amb
declare -a configure_args=()
if test -d /usr/lib64; then
    configure_args+=("--libdir=\${exec_prefix}/lib64")
fi
../configure --prefix=/usr/local "${configure_args[@]}"
${MAKE-make} -j$(nproc) V=1
${MAKE-make} install DESTDIR="$PWD/../_amd"
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

have_mingw64=no
if find_in_path mingw64-cmake
then
    have_mingw64=yes
    mingw64-cmake -S . -B _cmb-w64
    ${MAKE-make} -C _cmb-w64 -j$(nproc)
    ${MAKE-make} -C _cmb-w64 install DESTDIR="$PWD/_cmd-w64"
fi

cd _amb
if find_in_path ${DOXYGEN-doxygen}
then
    ${MAKE-make} -j$(nproc) doc
fi
${MAKE-make} -j$(nproc) distcheck
cd ..

${DIFF-diff} -u \
     <(find _amd | env LC_ALL=C sort | sed 's|^_amd||') \
     <(find _cmd | env LC_ALL=C sort | sed 's|^_cmd||') \
||:

${DIFF-diff} -u _{am,cm}d/lib/pkgconfig/libserialport.pc \
||:

if test "x$have_mingw64" = xyes
then
    ${DIFF-diff} -u \
		 <(find _amd     -not -type d | env LC_ALL=C sort | sed 's|^_amd||'     | sed 's|^/usr/local||' | sed 's|^/lib64/|/lib/|') \
		 <(find _amd-w64 -not -type d | env LC_ALL=C sort | sed 's|^_amd-w64||' | sed 's|^/usr/x86_64-w64-mingw32/sys-root/mingw||') \
	||:

    ${DIFF-diff} -u \
		 <(find _amd-w64 | env LC_ALL=C sort | sed 's|^_amd-w64||') \
		 <(find _cmd-w64 | env LC_ALL=C sort | sed 's|^_cmd-w64||') \
	||:

    ${DIFF-diff} -u _{am,cm}d-w64/lib/pkgconfig/libserialport.pc \
	||:
fi

# End of file.
