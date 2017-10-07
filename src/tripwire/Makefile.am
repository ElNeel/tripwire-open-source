AUTOMAKE_OPTIONS = foreign no-dependencies
AM_INSTALL_PROGRAM_FLAGS = -m 755

AM_CPPFLAGS = -I$(srcdir)/..
LIBS = -ltripwire -lcryptlib -lengine @LIBS@
LDFLAGS = @LDFLAGS@ -L../../lib
LN_S = @LN@

sbin_PROGRAMS = tripwire
tripwiredir=.
tripwire_SOURCES = \
  stdtripwire.cpp tripwire.cpp tripwiremain.cpp tripwirestrings.cpp

tripwire_HEADERS = \
  stdtripwire.h tripwire.h tripwirestrings.h

DEFS = @DEFS@		# This gets rid of the -I. so AM_CPPFLAGS must be more explicit
CLEANFILES = ../../bin/tripwire ../../lib/libtripwire.a *.gcno *.gcda

all: $(sbin_PROGRAMS)
	@test -d ../../bin && $(LN) -f $(sbin_PROGRAMS) ../../bin
