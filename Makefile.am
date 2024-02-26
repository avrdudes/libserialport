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

ACLOCAL_AMFLAGS = -I autostuff
AM_LIBTOOLFLAGS = --silent
GNUMAKEFLAGS = --no-print-directory

# Enable more compiler warnings.
AM_CFLAGS = -std=c99 -Wall -Wextra -pedantic -Wmissing-prototypes -Wshadow
# Set flag used in libserialport.h to indicate we are building the library
# using autotools.
AM_CFLAGS += -DLIBSERIALPORT_ATBUILD

noinst_DATA =

lib_LTLIBRARIES = libserialport.la

libserialport_la_SOURCES = serialport.c timing.c libserialport_internal.h
if LINUX
libserialport_la_SOURCES += linux.c linux_termios.c linux_termios.h
endif
if WIN32
libserialport_la_SOURCES += windows.c
endif
if MACOSX
libserialport_la_SOURCES += macosx.c
endif
if FREEBSD
libserialport_la_SOURCES += freebsd.c
endif

libserialport_la_LIBADD = $(SP_LIBS)

libserialport_la_LDFLAGS = -version-info $(SP_LIB_VERSION) -no-undefined
if MACOSX
libserialport_la_LDFLAGS += -framework IOKit -framework CoreFoundation
endif

include_HEADERS = libserialport.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libserialport.pc

TESTS = test_timing
check_PROGRAMS = test_timing
test_timing_SOURCES = timing.c test_timing.c
test_timing_CFLAGS = $(AM_CFLAGS)

EXTRA_DIST = Doxyfile \
	examples/Makefile \
	examples/README \
	examples/list_ports.c \
	examples/port_info.c \
	examples/port_config.c \
	examples/await_events.c \
	examples/handle_errors.c

EXTRA_DIST += AUTHORS
EXTRA_DIST += COPYING
EXTRA_DIST += NEWS
EXTRA_DIST += README

EXTRA_DIST += autogen.sh
EXTRA_DIST += config-header.py
EXTRA_DIST += config-pattern

EXTRA_DIST += common.props
EXTRA_DIST += debug.props
EXTRA_DIST += release.props

EXTRA_DIST += libserialport.sln
EXTRA_DIST += libserialport.vcxproj
EXTRA_DIST += libserialport.vcxproj.filters

EXTRA_DIST += examples/Makefile
EXTRA_DIST += examples/README
EXTRA_DIST += examples/examples.sln

EXTRA_DIST += examples/await_events.c
EXTRA_DIST += examples/projects/await_events.vcxproj
EXTRA_DIST += examples/projects/await_events.vcxproj.filters

EXTRA_DIST += examples/handle_errors.c
EXTRA_DIST += examples/projects/handle_errors.vcxproj
EXTRA_DIST += examples/projects/handle_errors.vcxproj.filters

EXTRA_DIST += examples/list_ports.c
EXTRA_DIST += examples/projects/list_ports.vcxproj
EXTRA_DIST += examples/projects/list_ports.vcxproj.filters

EXTRA_DIST += examples/port_config.c
EXTRA_DIST += examples/projects/port_config.vcxproj
EXTRA_DIST += examples/projects/port_config.vcxproj.filters

EXTRA_DIST += examples/port_info.c
EXTRA_DIST += examples/projects/port_info.vcxproj
EXTRA_DIST += examples/projects/port_info.vcxproj.filters

EXTRA_DIST += examples/send_receive.c
EXTRA_DIST += examples/projects/send_receive.vcxproj
EXTRA_DIST += examples/projects/send_receive.vcxproj.filters

SED_CMDS =
SED_CMDS += -e 's|[@]PACKAGE_TARNAME[@]|$(PACKAGE_TARNAME)|g'
SED_CMDS += -e 's|[@]PACKAGE_TARNAME[@]|$(PACKAGE_TARNAME)|g'

EXTRA_DIST += CMakeLists.txt.in
EXTRA_DIST += $(srcdir)/CMakeLists.txt
noinst_DATA += $(srcdir)/CMakeLists.txt
$(srcdir)/CMakeLists.txt: CMakeLists.txt.in
	if $(SED) $(SED_CMDS) $< > $@.tmp.$$$$; then \
	  mv -f "$@.tmp.$$$$" "$@"; \
	else \
	  s="$?"; \
	  rm -f "$@.tmp.$$$$"; \
	  exit "$s"; \
	fi

.PHONY: ChangeLog doc

ChangeLog:
if HAVE_PROG_GIT
	if test -d '$(top_srcdir)/.git'; then \
	  $(GIT) --git-dir '$(top_srcdir)/.git' log > ChangeLog; \
	else \
	  echo "Generated dummy ChangeLog file (no .git directory)" > ChangeLog; \
	fi
else
	echo "Generated dummy ChangeLog file (no git tool)" > ChangeLog
endif

DISTCLEANFILES = ChangeLog
dist-hook: ChangeLog

if HAVE_PROG_DOXYGEN
doc: $(srcdir)/libserialport.h Doxyfile
	doxygen `test -f Doxyfile || echo '$(srcdir)/'`Doxyfile
endif

EXTRA_DIST += windows.rc.in
