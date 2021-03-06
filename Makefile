# most copyright says 2001 (one says 1999)
# internally in the old makefile we compile to bob2
# so lets call it bot2 or bob-2001
#

BINDIR=./bin
LIBDIR=./lib
OBJDIR=./obj
HDRDIR=./include
TESTDIR=./test

DIRS=$(BINDIR) $(LIBDIR) $(OBJDIR)

PROGS=$(BINDIR)/bob $(BINDIR)/bobc $(BINDIR)/bobi $(BINDIR)/bobmerge
LIBS=$(LIBDIR)/libbobc.a $(LIBDIR)/libbobi.a
HDRS=$(HDRDIR)/bob.h $(HDRDIR)/bobint.h $(HDRDIR)/bobcom.h

WFLAGS=-Wall -Wextra -pedantic -Wno-unused-parameter -Wno-missing-field-initializers -Wimplicit-fallthrough=2
XINCLUDES=-I$(HDRDIR) -I./bobcom -I./bobint

# trace is a mboot thing, not yet implemented
#XDEFINES=-DBOB_INCLUDE_FLOAT_SUPPORT -DWITH_TRACE

# FLOAT NOT WORKING DUE TO MATRIX , seems unfinished
XDEFINES=-DBOB_INCLUDE_FLOAT_SUPPORT

CFLAGS=$(XCFLAGS) $(WFLAGS) $(XINCLUDES) $(XDEFINES)

all:	$(DIRS) $(PROGS) $(LIBS)

$(BINDIR):
	mkdir $(@F)

$(LIBDIR):
	mkdir $(@F)

$(OBJDIR):
	mkdir $(@F)

###############
# BOB
###############

BOB_OBJS=\
$(OBJDIR)/bob.o

$(BINDIR)/bob:	$(BOB_OBJS) lib/libbobc.a lib/libbobi.a
	$(CC) -o $@ $(CFLAGS) $(BOB_OBJS) -L$(LIBDIR) -lbobc -lbobi -lm

$(BOB_OBJS):	$(OBJDIR)%.o:	bob%.c $(HDRS)
	$(CC) -c $(CFLAGS) $< -o $@

run:	$(BINDIR)/bob
	./$(BINDIR)/bob

###############
# BOBC
###############

BOBC_OBJS=\
$(OBJDIR)/bobc.o

$(BINDIR)/bobc:	$(BOBC_OBJS) lib/libbobc.a lib/libbobi.a
	$(CC) -o $@ $(CFLAGS) $(BOBC_OBJS) -L$(LIBDIR) -lbobc -lbobi -lm

$(BOBC_OBJS):	$(OBJDIR)%.o:	bobc%.c $(HDRS)
	$(CC) -c $(CFLAGS) $< -o $@

###############
# BOBI
###############

BOBI_OBJS=\
$(OBJDIR)/bobi.o

$(BINDIR)/bobi:	$(BOBI_OBJS) lib/libbobi.a
	$(CC) -o $@ $(CFLAGS) $(BOBI_OBJS) -L$(LIBDIR) -lbobi -lm

$(BOBI_OBJS):	$(OBJDIR)%.o:	bobi%.c $(HDRS)
	$(CC) -c $(CFLAGS) $< -o $@

###############
# BOBCOM
###############

BOBCOM_OBJS=\
$(OBJDIR)/bobcom.o \
$(OBJDIR)/bobeval.o \
$(OBJDIR)/bobscn.o \
$(OBJDIR)/bobwcode.o

$(BOBCOM_OBJS):	$(OBJDIR)%.o:	bobcom%.c $(HDRS)
	$(CC) -c $(CFLAGS) $< -o $@

$(LIBDIR)/libbobc.a:	$(BOBCOM_OBJS)
	$(AR) crs $(LIBDIR)/libbobc.a $(BOBCOM_OBJS)

###############
# BOBINT
###############

BOBINT_OBJS=\
$(OBJDIR)/bobcobject.o \
$(OBJDIR)/bobdebug.o \
$(OBJDIR)/bobenter.o \
$(OBJDIR)/bobenv.o \
$(OBJDIR)/boberror.o \
$(OBJDIR)/bobfcn.o \
$(OBJDIR)/bobfile.o \
$(OBJDIR)/bobfloat.o \
$(OBJDIR)/bobhash.o \
$(OBJDIR)/bobheap.o \
$(OBJDIR)/bobint.o \
$(OBJDIR)/bobinteger.o \
$(OBJDIR)/bobmath.o \
$(OBJDIR)/bobmethod.o \
$(OBJDIR)/bobobject.o \
$(OBJDIR)/bobparse.o \
$(OBJDIR)/bobrcode.o \
$(OBJDIR)/bobstdio.o \
$(OBJDIR)/bobstream.o \
$(OBJDIR)/bobstring.o \
$(OBJDIR)/bobsymbol.o \
$(OBJDIR)/bobtype.o \
$(OBJDIR)/bobvector.o

$(BOBINT_OBJS):	$(OBJDIR)%.o:	bobint%.c $(HDRS)
	$(CC) -c $(CFLAGS) $< -o $@

$(LIBDIR)/libbobi.a:	$(BOBINT_OBJS)
	@$(AR) crs $(LIBDIR)/libbobi.a $(BOBINT_OBJS)

###############
# BOBMERGE
###############

BOBMERGE_OBJS=\
$(OBJDIR)/bobmerge.o

$(BINDIR)/bobmerge:	$(BOBMERGE_OBJS)
	$(CC) -o $@ $(CFLAGS) $(BOBMERGE_OBJS)

$(BOBMERGE_OBJS):	$(OBJDIR)%.o:	util%.c $(HDRS)
	$(CC) -c $(CFLAGS) $< -o $@

$(BOBFILES): test.bob test.bbo

clean:	$(DIRS)
	rm -rf $(BINDIR)
	rm -rf $(LIBDIR)
	rm -rf $(OBJDIR)


test:
	( cd test; ./all_tests.sh )
