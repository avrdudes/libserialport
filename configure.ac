##
## This file is part of the libserialport project.
##
## Copyright (C) 2010-2012 Bert Vermeulen <bert@biot.com>
## Copyright (C) 2013 Martin Ling <martin-libserialport@earth.li>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

# We require at least autoconf 2.63 (AC_INIT format changed there).
AC_PREREQ([2.63])

# libserialport package version number (NOT the same as shared lib version!).
m4_pattern_forbid([sp_package_])
m4_define([sp_package_version_major], [0])
m4_define([sp_package_version_minor], [1])
m4_define([sp_package_version_micro], [1])
m4_define([sp_package_version_tweak], [23])
m4_define([sp_package_version], [sp_package_version_major.sp_package_version_minor.sp_package_version_micro]m4_ifdef([sp_package_version_tweak], [.][sp_package_version_tweak]))

# Library version for libserialport (NOT the same as the package version).
# Carefully read the libtool docs before updating these numbers!
# The algorithm for determining which number to change (and how) is nontrivial!
# http://www.gnu.org/software/libtool/manual/libtool.html#Updating-version-info
m4_define([sp_lib_version_current],  [1])
m4_define([sp_lib_version_revision], [0])
m4_define([sp_lib_version_age],      [1])
m4_define([sp_lib_version], [sp_lib_version_current:sp_lib_version_revision:sp_lib_version_age])

AC_INIT([avrdudes bugfix fork of sigrok libserialport],
	[sp_package_version],
	[https://github.com/avrdudes/libserialport/issues],
	[libserialport],
	[https://github.com/avrdudes/libserialport])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([autostuff])
AC_CONFIG_AUX_DIR([autostuff])

AH_BOTTOM([#if HAVE_STRUCT_TERMIOS_C_ISPEED && HAVE_STRUCT_TERMIOS_C_OSPEED
# define HAVE_TERMIOS_SPEED 1
#endif
#if HAVE_STRUCT_TERMIOS2_C_ISPEED && HAVE_STRUCT_TERMIOS2_C_OSPEED
# define HAVE_TERMIOS2_SPEED 1
#endif])

# We require at least automake 1.11 (needed for 'silent rules').
AM_INIT_AUTOMAKE([1.11 -Wall -Werror no-define check-news])
AM_SILENT_RULES([yes])
m4_ifdef([AM_PROG_AR], [AM_PROG_AR])

# Checks for programs.
AC_PROG_CC
AC_PROG_SED
AC_PROG_INSTALL
AC_PROG_LN_S

AC_DEFUN([SP_PROG], [dnl
  m4_assert([$# >= 2])[]dnl
  AC_ARG_VAR(m4_toupper($1), [$2])
  AS_VAR_IF(m4_toupper($1), [], [dnl
    AC_PATH_PROG(m4_toupper($1), [$1], [no])
  ])
  AM_CONDITIONAL([HAVE_PROG_]m4_toupper($1), [test "x$m4_toupper($1)" != xno])
])dnl

SP_PROG([doxygen], [doxygen documentation system])
SP_PROG([git],     [git revision control system])


## SP_PROG_VERSION(program, sh-var)
## Obtain the version of <program> and store it in <sh-var>.
AC_DEFUN([SP_PROG_VERSION],
[dnl
m4_assert([$# >= 2])[]dnl
sp_prog_ver=`$1 --version 2>&AS_MESSAGE_LOG_FD | sed 1q 2>&AS_MESSAGE_LOG_FD`
AS_CASE([[$]?:$sp_prog_ver],
        [[0:*[0-9].[0-9]*]], [$2=$sp_prog_ver],
        [$2=unknown])[]dnl
])

SP_PROG_VERSION([$CC], [sp_cc_version])

# Initialize libtool.
LT_INIT

AC_DEFINE_UNQUOTED([SP_PACKAGE_VERSION_MAJOR],  [sp_package_version_major], [.])
AC_DEFINE_UNQUOTED([SP_PACKAGE_VERSION_MINOR],  [sp_package_version_minor], [.])
AC_DEFINE_UNQUOTED([SP_PACKAGE_VERSION_MICRO],  [sp_package_version_micro], [.])
AC_DEFINE_UNQUOTED([SP_PACKAGE_VERSION_STRING], ["sp_package_version"],     [.])
AC_SUBST([SP_PACKAGE_VERSION], [sp_package_version])

AC_SUBST([SP_LIB_VERSION], ["sp_lib_version"])

AC_DEFINE_UNQUOTED([SP_LIB_VERSION_CURRENT],  [sp_lib_version_current],  [.])
AC_DEFINE_UNQUOTED([SP_LIB_VERSION_REVISION], [sp_lib_version_revision], [.])
AC_DEFINE_UNQUOTED([SP_LIB_VERSION_AGE],      [sp_lib_version_age],      [.])
AC_DEFINE_UNQUOTED([SP_LIB_VERSION_STRING],   ["sp_lib_version"],        [.])

dnl ------------------------------------------------------------------------
dnl When necessary, update the libserialport.h source file according
dnl to changed above sp_package_version* and sp_lib_version* values.
dnl ------------------------------------------------------------------------
m4_define([sp_sed_command_args], [])dnl
m4_define([sp_sed_command_add], [dnl
  m4_append([sp_sed_command_args],
            [ -e 's|^\([[:punct:]]define $1\)[[:space:]].*|\1 ]$2[|g'])dnl
])dnl
dnl
sp_sed_command_add([SP_PACKAGE_VERSION_MAJOR],  [sp_package_version_major])dnl
sp_sed_command_add([SP_PACKAGE_VERSION_MINOR],  [sp_package_version_minor])dnl
sp_sed_command_add([SP_PACKAGE_VERSION_MICRO],  [sp_package_version_micro])dnl
sp_sed_command_add([SP_PACKAGE_VERSION_STRING], ["sp_package_version"])dnl
dnl
sp_sed_command_add([SP_LIB_VERSION_CURRENT],  [sp_lib_version_current])dnl
sp_sed_command_add([SP_LIB_VERSION_REVISION], [sp_lib_version_revision])dnl
sp_sed_command_add([SP_LIB_VERSION_AGE],      [sp_lib_version_age])dnl
sp_sed_command_add([SP_LIB_VERSION_STRING],   ["sp_lib_version"])dnl
dnl
m4_esyscmd([./buildstuff/sed-update-source-file libserialport.h]m4_defn([sp_sed_command_args]))dnl
m4_case(m4_sysval, [0], [], [dnl
  m4_fatal([sed-update-source-file script returned non-0])
])dnl

dnl ------------------------------------------------------------------------
dnl Generate the CMakeLists.txt file from CMakeLists.txt.in according
dnl to the above sp_package_version* and sp_lib_version* values.
dnl ------------------------------------------------------------------------
m4_define([sp_sed_command_args], [])dnl
m4_define([sp_sed_command_add], [dnl
  m4_append([sp_sed_command_args],
            [ -e 's|[@]]$1[@|]$2[|g'])dnl
])dnl
dnl
sp_sed_command_add([PACKAGE_TARNAME], [AC_PACKAGE_TARNAME])dnl
sp_sed_command_add([PACKAGE_NAME],    [AC_PACKAGE_NAME])dnl
sp_sed_command_add([PACKAGE_VERSION], [AC_PACKAGE_VERSION])dnl
sp_sed_command_add([PACKAGE_URL],     [AC_PACKAGE_URL])dnl
dnl
dnl TODO: Make sure the _minor and _micro values are calculcated correctly.
m4_define([cmake_lib_version_major], [m4_eval(sp_lib_version_current - sp_lib_version_age)])dnl
m4_define([cmake_lib_version_minor], [sp_lib_version_age])dnl
m4_define([cmake_lib_version_micro], [sp_lib_version_revision])dnl
m4_define([cmake_lib_version], m4_defn([cmake_lib_version_major]).m4_defn([cmake_lib_version_minor]).m4_defn([cmake_lib_version_micro]))dnl
sp_sed_command_add([CMAKE_LIB_SOVERSION], [cmake_lib_version_major])dnl
sp_sed_command_add([CMAKE_LIB_VERSION],   [cmake_lib_version])dnl
dnl

m4_esyscmd([./buildstuff/sed-substitute CMakeLists.txt.in]m4_defn([sp_sed_command_args]))dnl
m4_case(m4_sysval, [0], [], [dnl
  m4_fatal([sed-substitute script returned non-0])
])dnl


AM_CONDITIONAL([LINUX], [test -z "${host_os##linux*}" || test -z "${host_os##uclinux*}"])
AM_CONDITIONAL([WIN32], [test -z "${host_os##mingw*}"])
AM_CONDITIONAL([MACOSX], [test -z "${host_os##darwin*}"])
AM_CONDITIONAL([FREEBSD], [test -z "${host_os##freebsd*}"])

AM_COND_IF([WIN32], [SP_LIBS='-lsetupapi'], [SP_LIBS=])
AC_SUBST([SP_LIBS])

AM_COND_IF([FREEBSD], [SP_PKGLIBS='libusb-2.0'], [SP_PKGLIBS=])
AC_SUBST([SP_PKGLIBS])

AM_COND_IF([MACOSX], [AC_CHECK_HEADER([IOKit/IOKitLib.h], [],
	[AC_MSG_ERROR([IOKit/IOKitLib.h not found])])])

AS_CASE([$host_os], [linux*|darwin*|mingw*|freebsd*],, [
	AC_DEFINE([NO_ENUMERATION], [1], [Enumeration is unsupported.])
	AC_DEFINE([NO_PORT_METADATA], [1], [Port metadata is unavailable.])
])

AC_SYS_LARGEFILE

# Define size_t if not defined as standard.
AC_TYPE_SIZE_T

# Check for specific termios structures.
AC_CHECK_TYPES([struct termios2],,,
	[[#include <linux/termios.h>]])
AC_CHECK_MEMBERS([struct termios.c_ispeed, struct termios.c_ospeed,
		struct termios2.c_ispeed, struct termios2.c_ospeed],,,
	[[#include <linux/termios.h>]])

# Check for the BOTHER definition, needed for setting arbitrary baud rates.
# We can't just #ifdef BOTHER in the code, because of the separation between
# code using libc headers and code using kernel termios.h headers.
AC_CHECK_DECLS([BOTHER],,, [[#include <linux/termios.h>]])

# Check for serial_struct.
AC_CHECK_TYPES([struct serial_struct],,, [[#include <linux/serial.h>]])

# Check for realpath().
AC_CHECK_FUNC([realpath], [AC_DEFINE(HAVE_REALPATH, 1, [realpath is available.])], [])

# Check for flock().
AC_CHECK_HEADER([sys/file.h], [AC_DEFINE(HAVE_SYS_FILE_H, 1, [sys/file.h is available.])], [])
AC_CHECK_FUNC([flock], [AC_DEFINE(HAVE_FLOCK, 1, [flock is available.])], [])

# Check for clock_gettime().
AC_CHECK_FUNC([clock_gettime],
	[AC_DEFINE(HAVE_CLOCK_GETTIME, 1, [clock_gettime is available.])], [])

AC_CACHE_CHECK([for visibility control], [sp_cv_visibility_control], [
	sp_saved_CFLAGS=$CFLAGS
	CFLAGS="$CFLAGS -Werror"
	AC_COMPILE_IFELSE([AC_LANG_SOURCE(
		[[__attribute__((visibility("hidden"))) void foo(void) {}]])],
		[sp_cv_visibility_control=attribute],
		[AC_COMPILE_IFELSE([AC_LANG_SOURCE(
			[[__declspec(dllexport) void foo(void) {}]])],
			[sp_cv_visibility_control=declspec],
			[sp_cv_visibility_control=none])])
	CFLAGS=$sp_saved_CFLAGS
])
AS_CASE([$sp_cv_visibility_control],
	[attribute],	[SP_API='__attribute__((visibility("default")))'
			SP_PRIV='__attribute__((visibility("hidden")))'],
	[declspec],	[SP_API='__declspec(dllexport)' SP_PRIV=],
			[SP_API= SP_PRIV=])
AC_DEFINE_UNQUOTED([SP_API], [$SP_API], [Macro preceding public API functions])
AC_DEFINE_UNQUOTED([SP_PRIV], [$SP_PRIV], [Macro preceding private functions])

AC_CONFIG_FILES([Makefile libserialport.pc])

AC_OUTPUT

cat >&AS_MESSAGE_FD <<_EOF

libserialport configuration summary:

 - Package version................. $SP_PACKAGE_VERSION
 - Library ABI version............. $SP_LIB_VERSION
 - Prefix.......................... $prefix
 - Building on..................... $build
 - Building for.................... $host
 - Building shared / static........ $enable_shared / $enable_static

Compile configuration:
 - C compiler...................... $CC
 - C compiler version.............. $sp_cc_version
 - C compiler flags................ $CFLAGS
 - Linker flags.................... $LDFLAGS

_EOF
