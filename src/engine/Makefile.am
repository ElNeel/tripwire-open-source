AUTOMAKE_OPTIONS = foreign no-dependencies

AM_CPPFLAGS = -I.. -I../..
LN=@LN@
DEFAULT_INCLUDES = $(D_INCLUDES)

noinst_LIBRARIES = libengine.a
libengine_adir=.
libengine_a_SOURCES = \
engine.cpp engineerrors.cpp enginestrings.cpp generatedb.cpp integritycheck.cpp \
mailmessage.cpp pipedmailmessage.cpp policyupdate.cpp smtpmailmessage.cpp \
stdengine.cpp syslog_trip.cpp tripwireutil.cpp twcmdline.cpp twcmdlineutil.cpp updatedb.cpp

libengine_a_HEADERS = \
engine.h engineerrors.h enginestrings.h generatedb.h integritycheck.h \
mailmessage.h policyupdate.h stdengine.h syslog_trip.h tripwireutil.h \
twcmdline.h twcmdlineutil.h updatedb.h

DEFS = @DEFS@		# This gets rid of the -I. so AM_CPPFLAGS must be more explicit
CLEANFILES = ../../lib/libengine.a *.gcno *.gcda

all: $(noinst_LIBRARIES)
	$(LN) -f $(noinst_LIBRARIES) ../../lib/libengine.a
